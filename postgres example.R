

url <- glue::glue("postgres://{mjvgsdzg:RsIxTmV9a95Gbb6Vo7IgG9wZNiv4Hq5L@",
                  "balarama.db.elephantsql.com:5432/mjvgsdzg")




library(DBI)
library(RPostgreSQL)


con <- dbConnect(drv = PostgreSQL(),
                 user = "mjvgsdzg",
                 password = "RsIxTmV9a95Gbb6Vo7IgG9wZNiv4Hq5L",
                 host = "balarama.db.elephantsql.com",
                 port = 5432,
                 dbname = "mjvgsdzg")

                 
library(dplyr)
library(dbplyr)

library(lgrdata)
data("automobiles")

copy_to(con, automobiles,
        indexes = list("car_name",
                       "origin"),
        temporary = FALSE)

cars <- tbl(con, "automobiles")
  

heavycars_query <- cars %>%
  filter(weight > 2000)

show_query(heavycars_query)

explain(heavycars_query)

heavycars <- collect(heavycars_query)


select(cars,
       car_name %like% "buick") %>% collect

filter(cars,
       grepl("buick", car_name)
       ) %>% collect



  
# REAL CODE  
con <- DBI::dbConnect(drv = PostgreSQL(),
                      user = "mjvgsdzg",
                      password = rstudioapi::askForPassword("Database password"),
                      host = "balarama.db.elephantsql.com",
                      port = 5432,
                      dbname = "mjvgsdzg")

