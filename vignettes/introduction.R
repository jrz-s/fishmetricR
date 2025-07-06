## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(fishmetricR)

## -----------------------------------------------------------------------------

library(fishmetricR)

# Example 1: Retrieve coefficients for a single species
output1 <- get_allometric(genus = "Brycon"
                         , species = "orthotaenia")

print(output1)

# Example 2: Retrieve coefficients for multiple species
output2 <- get_fish_allometric(genus = c("Clarias","Piaractus","Brycon")
                         , species = c("gariepinus","brachypomus","orthotaenia"))

print(output2)


