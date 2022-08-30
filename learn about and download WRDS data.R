# SETUP ######################################################################

## Load Packages ####
library(pacman)
library(RPostgres)
library(glue)
library(arrow)
library(tictoc)

## Load Helper Scripts ####
source("_Global Parameters.R")
#source("utils.R")

# LOG INTO WRDS ##############################################################

if(exists("wrds")){
  dbDisconnect(wrds)  # because otherwise WRDS might time out
}

wrds <- dbConnect(Postgres(),
                  host='wrds-pgdata.wharton.upenn.edu',
                  port=9737,
                  user=rstudioapi::askForSecret("WRDS user"),
                  password=rstudioapi::askForSecret("WRDS pw"),
                  sslmode='require',
                  dbname='wrds')
wrds  # checks whether WRDS connection exists

# LIST WRDS TABLES AND INFORMATION ###########################################

## List all the data libraries available at WRDS ####
res <- dbSendQuery(wrds, "select
                            distinct table_schema
                          from
                            information_schema.tables
                          where
                            table_type ='VIEW' or table_type ='FOREIGN TABLE'
                          order by
                            table_schema")
WRDSlibraries <- dbFetch(res, n=-1) #n=-1 includes all rows
dbClearResult(res)
WRDSlibraries

## List the tables within Audit Analytics ####
res <- dbSendQuery(wrds, "select
                            distinct table_name
                          from
                            information_schema.columns
                          where
                            table_schema='audit'
                          order by
                            table_name")
AAtables <- dbFetch(res, n=-1)
dbClearResult(res)
AAtables

## Determine the variables available within a given table ####
res <- dbSendQuery(wrds, "select
                            column_name
                          from
                            information_schema.columns
                          where
                            table_schema='audit' and table_name='auditopin'
                          order by
                            column_name")
AAOpinVars<- dbFetch(res, n=-1) 
dbClearResult(res)
AAOpinVars

### start timer
tictoc::tic()

# PULL DATA FROM AUDIT ANALYTICS AUDIT OPINION DATA ##########################
res <- dbSendQuery(wrds, "select 
                            audit_op_key, auditor_affil_fkey, 
                            auditor_affilname, auditor_fkey, auditor_name,
                            sig_date_of_op_x, sig_date_of_op_s, going_concern,
                            auditor_city, auditor_state, auditor_state_name,
                            auditor_country, auditor_region, 
                            auditor_con_sup_reg, fiscal_year_of_op,
                            fiscal_year_end_op, op_aud_pcaob, pcaob_reg_num,
                            note_1_date, note_2_date, note_3_date,note_4_date,
                            note_5_date, accnt_basis, ftp_file_fkey, 
                            form_fkey, file_date, file_accepted, file_size, 
                            http_name_html, http_name_text, company_fkey,
                            best_edgar_ticker, eventdate_aud_fkey, 
                            eventdate_aud_name, opinion_text1, opinion_text2,
                            opinion_text3
                          from
                            audit.auditopin"
)
AAOpinData <- dbFetch(res, n=-1) 
dbClearResult(res)
AAOpinData

## Download Data from WRDS and Save to Disk ####
write_parquet(AAOpinData,glue("{data_path}/auditopinion.parquet"))

### stop timer
tictoc::toc()

# CLEAN UP ###################################################################

# Clear environment
rm(list = ls()) 

# Clear packages
p_unload(all)  # Remove all add-ons

# Clear console
cat("\014")  # ctrl+L