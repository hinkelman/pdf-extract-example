library(dplyr)
# GUI alternative to tabulapdf: https://tabula.technology
library(tabulapdf) 

bind_rows_mod <- function(df_list){
  lapply(df_list, function(dfx) mutate(dfx, across(everything(), as.character))) |> 
    bind_rows()
}

# Good File ---------------------------------------------------------------

gf = bind_rows(extract_tables("good-file.pdf"))

# Problem File 1 ----------------------------------------------------------

# extract and bind tables from all pages
pf1_ap = bind_rows_mod(extract_tables("problem-file-1.pdf"))
# specify pages to extract good pages
pf1_gp = bind_rows(extract_tables("problem-file-1.pdf", pages = c(4:12, 14:15))) |> 
  # change column order to match bad pages
  relocate(Comments, .after = Dilution)
# extract data from bad pages; page 13 has columns in different order from other bad pages
pf1_bp_list = extract_tables("problem-file-1.pdf", pages = 1:3, col_names = FALSE)
pf1_bp = lapply(pf1_bp_list, function(dfx) setNames(dfx[-1,], names(pf1_gp))) |> 
  bind_rows()
# still left with some dates that are corrupted by neighboring column in pf1_bp
# also need to handle page 13

# Problem File 2 ----------------------------------------------------------

pf2_list = extract_tables("problem-file-2.pdf")
sapply(pf2_list, ncol)
pf2_gp = bind_rows(extract_tables("problem-file-2.pdf", pages = 1:9))
# last two pages seem to need to be handled manually

# Problem File 3 ----------------------------------------------------------

# use locator to manually select areas
pf3_pg1_area = locate_areas("problem-file-3.pdf", pages = 1)[[1]]
pf3_pg1 = extract_tables("problem-file-3.pdf", pages = 1, 
                          area = list(pf3_pg1_area), guess = FALSE)[[1]]
# for this file, page 1 area works for other 3 tables
pf3 = extract_tables("problem-file-3.pdf", pages = 2:4,
                     area = list(pf3_pg1_area), guess = FALSE) |> 
  bind_rows()
