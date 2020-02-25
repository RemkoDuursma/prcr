bookdown::render_book(input = "rmd/index.Rmd", 
                      output_format = "bookdown::pdf_book", 
                      new_session = TRUE, 
                      clean = FALSE)
