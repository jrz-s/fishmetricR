#' @title Get allometric data from FishBase for a single species
#'
#' @description This function web scrapes the FishBase (https://fishbase.se/) website to obtain the coefficients of the length-weight equation.
#'
#' @author Zárate-Salazar, Jhonatan Rafael (Researcher | PPEC - UFS)
#' @seealso \url{mailto:rzaratesalazar@gmail.com}
#' @details Agronomist | Biodiversity - MS | Soil Science - PhD
#' @param genus Name of the genus of the fish (ex: "Brycon")
#' @param species Name of the fish species (ex: "orthotaenia")
#' @return A `data.frame` with the allometric coefficients `a`, `b` and other coefficients.
#'
#' @importFrom magrittr %>%
#' @importFrom rvest html_nodes html_table html_elements html_attr
#' @importFrom dplyr everything
#' @importFrom tidyr separate unite
#' @importFrom stringr str_sub str_to_upper str_to_lower str_remove str_extract str_replace
#' @importFrom tibble tibble enframe
#'
#' @export

get_allometric <- function(genus,species){

  genus <- paste0(
    genus %>%
      stringr::str_sub(start = 1,end = 1) %>%
      stringr::str_to_upper()
    ,genus %>%
      stringr::str_sub(start = 2,end = nchar(genus)) %>%
      stringr::str_to_lower())

  species <- species %>% stringr::str_to_lower()

  # get url summary
  url_summary <- paste0("https://fishbase.se/summary/", genus, "_", species, ".html")

  # read url summary
  link <- tryCatch(rvest::read_html(url_summary), error = function(e) return(NA))
  if(is.na(link)) return(tibble::tibble(genus, species, erro = "Principal page/link not found"))

  # search all links with 'LWRelationshipList.php'
  allometric_link <- link %>%
    rvest::html_elements("a") %>%
    rvest::html_attr("href") %>%
    stringr::str_subset("LWRelationshipList\\.php")

  # If you can't find the link, return a warning
  if(length(allometric_link) == 0){
    return(tibble::tibble(genus, species, erro = "Allometry link not found"))
  }

  # get first link complete
  complete_link <- paste0("https://fishbase.se", allometric_link[1])

  # fish link attributed
  fish_link <- tryCatch(rvest::read_html(complete_link), error = function(e) return(NA))
  if(is.na(fish_link)) return(tibble::tibble(genus, species, erro = "Fish page/link not found"))

  # allometric table access
  table <- fish_link %>%
    html_nodes('#eco') %>%
    html_table(header = TRUE,convert = TRUE)

  # get table (string manipulation)
  table <- tibble::enframe(
    x = table
    ,name = "name1"
    ,value = "name2") %>%
    tidyr::unnest(name2) %>%
    dplyr::select(!name1) %>%
    janitor::clean_names() %>%
    tidyr::separate(col = "length_cm"
                    ,into = c("length_min","length_max")
                    ,sep = "- "
                    ,convert = TRUE
                    ,remove = TRUE) %>%
    tidyr::separate(col = "length_min"
                    ,into = c("length_min","LM2")
                    ,convert = TRUE
                    ,remove = TRUE) %>%
    tidyr::unite("length_min"
                 ,c("length_min","LM2")
                 ,sep = "."
                 ,remove = TRUE
                 ,na.rm = TRUE) %>%
    dplyr::mutate(length_min = as.numeric(length_min)) %>%
    dplyr::select(a,b,sex,length_min,length_max,lengthtype,r2,sd_b,sd_log10_a,n,territory,locality) %>%
    dplyr::mutate(r2 = r2 %>% stringr::str_remove(pattern = "&nbsp")) %>%
    dplyr::mutate(r2 = as.numeric(r2)) %>%
    tidyr::separate(col = 'locality'
                    ,into = c('local','period')
                    ,sep = '/'
                    ,remove = TRUE) %>%
    dplyr::mutate(period = period %>% stringr::str_remove(pattern = "\\.")) %>%
    dplyr::rename('country' = territory
                  ,'locality' = local) %>%
    dplyr::mutate(prov1 = locality %>%
                    stringr::str_remove(pattern = '[\\,][ ][0-9]{4}[-][0-9]{2}')) %>%
    dplyr::mutate(prov1 = prov1 %>%
                    stringr::str_remove(pattern = '[0-9]{2}|[0-9]{4}')) %>%
    dplyr::mutate(prov2 = locality %>%
                    stringr::str_extract(pattern = '[\\,][ ][0-9]{4}[-][0-9]{2}')) %>%
    tidyr::separate(col = 'prov2'
                    ,into = c('prov2','prov3')
                    ,sep = '-'
                    ,remove = TRUE) %>%
    dplyr::mutate(prov2 = prov2 %>%
                    stringr::str_remove(pattern = '[\\,][ ]')) %>%
    dplyr::mutate(prov4 = paste0(prov2 %>% stringr::str_sub(start = 1,end = 2),prov3)) %>%
    dplyr::mutate(period2 = paste0(prov2,'-',prov4)) %>%
    dplyr::mutate(period = period %>% stringr::str_remove(pattern = '[ ]')) %>%
    dplyr::mutate(period = period %>% stringr::str_replace(pattern = ' - ',replacement = '-')) %>%
    dplyr::mutate(period = ifelse(is.na(period),period2,period)) %>%
    dplyr::select(!c(locality,prov2,prov3,prov4,period2)) %>%
    dplyr::rename('locality' = prov1) %>%
    dplyr::mutate(period2 = period %>% stringr::str_detect(pattern = '[0-9]{4}[-][0-9]{4}',negate = TRUE)) %>%
    dplyr::mutate(period = ifelse(period2 == TRUE,NA,period)) %>%
    dplyr::select(!period2) %>%
    dplyr::mutate(genus = genus
                  ,species = species
                  ,scientific_name = paste(genus,species)
                  ,a = a %>% as.numeric
                  ,b = b %>% as.numeric
                  ,length_min = length_min %>% as.numeric
                  ,length_max = length_max %>% as.numeric
                  ,r2 = r2 %>% as.numeric
                  ,sd_b = sd_b %>% as.numeric
                  ,sd_log10_a = sd_log10_a %>% as.numeric
                  ,n = n %>% as.numeric) %>%
    dplyr::select(scientific_name,genus,species, everything()) %>%
    dplyr::select(!period,period) %>% suppressWarnings()

  return(table)

}

# -------------------------------------------------------------------------
# -------------------------------------------------------------------------
# -------------------------------------------------------------------------
