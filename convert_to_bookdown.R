


replace_slash_commands <- function(x, 
                               commands = c("code","fun","texttt"), 
                               content=".*?",
                               replacement="\\1",
                               prefix="",
                               suffix=""){

  for(command in commands){
    search_regex <- sprintf("\\\\%s\\{(%s)\\}", command, content)
    replace_regex <- paste0(prefix, replacement, suffix)
    x <- gsub(search_regex, x, replacement=replace_regex)
  }
  
return(x)
}
  

replace_code_chunks <- function(x){
  
  search_regex <- "^<<(.*?)>>="
  replace_regex <-"```{r \\1}"
  x <- gsub(search_regex, x, replacement=replace_regex)

  return(x)
}

# shorthand
delete_slash_commands <- function(...)replace_slash_commands(..., replacement="")


convert_to_rmd <- function(infile){
  outfile <- paste0(tools::file_path_sans_ext(infile),".Rmd")

  library(magrittr)
  
  z <- replace_slash_commands(readLines(infile),
                              commands=c("code","texttt","fun","FUN",
                                         "pack","PACK","menu"),
                              prefix="`", suffix="`") %>%
    replace_slash_commands("label", prefix="{#", suffix="}") %>%
    replace_slash_commands("R", prefix="R", suffix="") %>%
    replace_slash_commands("url", prefix="<", suffix=">") %>%
    replace_slash_commands("chapter", prefix="# ", suffix="") %>%
    replace_slash_commands("section", prefix="## ", suffix="") %>%
    replace_slash_commands("subsection", prefix="### ", suffix="") %>%
    replace_slash_commands("subsection\\*", prefix="### ", suffix="") %>%
    replace_slash_commands("subsubsection", prefix="#### ", suffix="") %>%
    replace_slash_commands("subsubsection\\*", prefix="#### ", suffix="") %>%
    delete_slash_commands("index") %>%
    
    replace_slash_commands("begin", content="furtherreading", 
                           replacement="> **Further reading**") %>%
    delete_slash_commands("end", content="furtherreading") %>%
    
    replace_slash_commands("begin", content="trybox", 
                           replacement="> **Try this yourself**") %>%
    delete_slash_commands("end", content="trybox") %>%
    
    replace_slash_commands("emph", prefix="*", suffix="*") %>%
    
    replace_slash_commands("begin", content="equation", replacement="$$") %>%
    replace_slash_commands("end", content="equation", replacement="$$") %>%
    replace_slash_commands("textsuperscript", prefix="^", suffix="^")
    
  
  # Replace head of code chunks
  z <- replace_code_chunks(z)
  
  # End of code chunks
  z[grep("^@",z)] <- "```"
  
  
  writeLines(z, outfile)

}

