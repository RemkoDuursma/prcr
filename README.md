A Learning Guide to R: data, analytical, and programming skills




## Instructions

Script `compile_gitbook.R`, renders the book as a gitbook. Output in `_book/index.html`.

Script `compile_pdf.R`, renders the book as PDF via LaTeX. 

Important input files:
- index.Rmd: Preface, and includes a block with knitr settings
- _output.yml:  settings
-  css/style.css: for formatting, including fonts
- preamble.tex: required packages and settings for LaTeX (PDF only)
