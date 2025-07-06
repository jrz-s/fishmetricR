#' @title Get allometric data from FishBase for multiple species
#'
#' @description This function web scrapes the FishBase (https://fishbase.se/) website to obtain the coefficients of the length-weight equation.
#'
#' @author Zárate-Salazar, Jhonatan Rafael (Researcher | PPEC - UFS)
#' @seealso \url{mailto:rzaratesalazar@gmail.com}
#' @details Agronomist | Biodiversity - MS | Soil Science - PhD
#' @param genus character vector with of the name of the genus of the fish
#' @param species character verctor with of the name of the fish species
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

get_fish_allometric <- function(genus,species){

  sp <- tibble::tibble(
    genus = genus, species = species)

  db <- sp %>%
    purrr::pmap_dfr(~get_allometric(..1,..2))

  return(db)

}

# -------------------------------------------------------------------------
# -------------------------------------------------------------------------
# -------------------------------------------------------------------------
