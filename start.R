library(bookdown)

# see _output.yml for settings
bookdown::render_book('index.Rmd', 'bookdown::gitbook')


# ... eventuall
bookdown::render_book('index.Rmd', 'bookdown::pdf_book', clean=FALSE)
