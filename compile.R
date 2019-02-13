# Render book as HTML and PDF
# Important input files:
#   _output.yml:  settings
#   css/style.css: for formatting, including fonts
#   index.Rmd: includes a block with knitr settings
#   preamble.tex: required packages and settings for LaTeX (PDF only)
# Output:
#  _book/index.html (and link to PDF from there)
bookdown::render_book('index.Rmd', 'bookdown::gitbook', new_session=TRUE, clean=TRUE)
bookdown::render_book('index.Rmd', 'bookdown::pdf_book', new_session=TRUE, clean=TRUE)


# Quick command to re-render some of the document.
# Do this when you are adjusting the CSS, for example
if(FALSE){
  bookdown::render_book(input=c('index.Rmd',"01-intro.Rmd"),
                        'bookdown::gitbook',
                        preview=TRUE,
                        new_session=TRUE, clean=TRUE)
}
