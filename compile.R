# see _output.yml for settings
bookdown::render_book('index.Rmd', 'bookdown::gitbook', new_session=TRUE, clean=TRUE)
#bookdown::render_book('index.Rmd', 'bookdown::pdf_book', new_session=TRUE, clean=TRUE)
#-->does not work in same session at the moment, still conflict Hmisc/dplyr
