#' @title Get allometric data from FishBase for multiple species
#'
#' @description
#' This function performs web scraping on the FishBase website (https://fishbase.se/)
#' to obtain the coefficients of the length-weight equation for one or more fish species.
#'
#' @details
#' The length-weight relationship is based on the classical allometric equation:
#'
#' \deqn{W = a \cdot L^b}
#'
#' Where:
#' - \eqn{W} is the body weight (in grams),
#' - \eqn{L} is the length (in cm),
#' - \eqn{a} is the intercept,
#' - \eqn{b} is the allometric exponent.
#'
#' The equation is log-transformed for linear regression:
#' \deqn{\log_{10}(W) = \log_{10}(a) + b \cdot \log_{10}(L)}
#'
#' Values of \eqn{b} indicate growth type:
#' - \eqn{b ≈ 3}: isometric growth,
#' - \eqn{b > 3}: positive allometry,
#' - \eqn{b < 3}: negative allometry.
#'
#' @param genus A character vector with the genus name(s) of the fish.
#' @param species A character vector with the species name(s) of the fish.
#'
#' @return A `data.frame` containing:
#' \itemize{
#'   \item `a`: intercept of the allometric equation
#'   \item `b`: exponent of the allometric equation
#'   \item `scientific_name`, `genus`, `species`, `locality`, etc.
#' }
#'
#' @author
#' Zárate-Salazar, Jhonatan Rafael, PhD \cr
#' Researcher | PPEC - UFS \cr
#' Email: \email{rzaratesalazar@gmail.com} \cr
#' ORCID: \url{https://orcid.org/0000-0001-9251-5340} \cr
#' Lattes: \url{http://lattes.cnpq.br/5635448203792516}
#'
#' @seealso \url{https://fishbase.se/}
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
