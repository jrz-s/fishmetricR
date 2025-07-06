#Avoid NOTEs from undefined global variables in R CMD check
utils::globalVariables(c(
  "name1", "name2", "length_min", "a", "b", "sex", "length_max", "lengthtype", "r2",
  "sd_b", "sd_log10_a", "n", "territory", "locality", "period", "prov1", "prov2", "prov3",
  "prov4", "period2", "scientific_name"
))
