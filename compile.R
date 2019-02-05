# see _output.yml for settings
bookdown::render_book('index.Rmd', 'bookdown::gitbook')
#bookdown::render_book('index.Rmd', 'bookdown::pdf_book')
#-->does not work in same session at the moment, still conflict Hmisc/dplyr
