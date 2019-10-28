bookdown::render_book(input="rmd/index.Rmd",
                      'bookdown::gitbook', new_session=TRUE, clean=TRUE)

bookdown::render_book(input="rmd/index.Rmd", 
	                  'bookdown::pdf_book', new_session=TRUE, clean=FALSE)

