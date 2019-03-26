
theme_datapelikaan <- function (base_size = 14, base_family = "sans") {
  
  half_line <- base_size/2
  
  ret <- theme_bw(base_family = base_family, base_size = base_size) + 
    theme(legend.background = element_blank(), 
          
          legend.key = element_blank(), 
          panel.background = element_blank(), 
          # panel.border = element_rect(fill = NA, 
          #                             colour = "black"),
          strip.background = element_blank(), 
          plot.background = element_blank(), 
          axis.line = element_blank(), 
          axis.title.x = element_text(margin = margin(t = 1.2 * half_line), vjust = 1), 
          axis.title.y = element_text(margin = margin(r = 1.2 * half_line), vjust = 1), 
          axis.text = element_text(size = rel(0.7), 
                                   colour = "black"),
          axis.text.x = element_text(margin = margin(t=0.9* half_line)),
          axis.text.y = element_text(margin = margin(r=0.9 * half_line)),
          legend.title = element_text(size = 0.9 * base_size),
          panel.grid = element_blank())
  
  ret
}

