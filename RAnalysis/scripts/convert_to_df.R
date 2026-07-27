convert_to_df <- function (file_in) {
  file_out <- as.data.frame(file_in[-c(1:26), -c(1,15)]) # drop first columns and first 26 rows
  colnames(file_out) <- c("Plate_row", 1,2,3,4,5,6,7,8,9,10,11,12)
  
  x.hrmin <- as.numeric(gsub("^.*_(\\d+)\\.xlsx$", "\\1", x))
  file_out <- file_out %>%  
    tidyr::pivot_longer(
      cols = -Plate_row,
      names_to = "Plate_col",
      values_to = "flourescence"
    ) %>% 
    dplyr::mutate(filename = as.character(x.2)) %>% 
    dplyr::mutate(timepoint = gsub("^.*?(T\\d+).*$", "\\1", x.2), 
                  plate = gsub("^.*plate(\\d+).*", "\\1", x.2), 
                  Well = paste0(Plate_row,Plate_col),
                  time= as.POSIXlt((strptime(x.hrmin, format = "%H%M")),
                                   format = "%H:%M")
                  
    )
  
  return(file_out)
}
