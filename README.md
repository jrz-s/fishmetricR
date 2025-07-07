[![License:
MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html)

R package to obtain allometric coefficients of fish from
[FishBase](https://www.fishbase.se/), via web scraping.

Developed to facilitate ecological and morphometric analyses of species,
especially useful for research in ecology, fish biology and fisheries
management.

------------------------------------------------------------------------

## Installation

To install directly from GitHub:

    # Install the remotes package if you don't have it already
    install.packages("remotes")

# Install fishmetricR from GitHub

remotes::install\_github(“jrz-s/fishmetricR”)

# Load package

library(fishmetricR)

# Application example

Example 1: Retrieve coefficients for a unique species

fishmetricR::get\_fish\_allometric(genus = “Brycon”, species =
“orthotaenia”)

Example 2: Retrieve coefficients for multiple species

fishmetricR::get\_fish\_allometric( genus = c(“Clarias”, “Piaractus”,
“Brycon”), species = c(“gariepinus”, “brachypomus”, “orthotaenia”))

# What it does?

The get\_fish\_allometric()) function performs web scraping of FishBase
to collect allometric coefficients.

The data returned includes:

-   *a*: slope of the length-weight equation

-   *b*: exponent of the length-weight equation

It also includes other relevant information such as minimum and maximum
sizes, location, sample size, R², etc.

## Allometric equation

FishBase provides length-weight relationships based on the classical
allometric equation:

*W* = *a* ⋅ *L*<sup>*b*</sup>

Where:

-   *W* is the body weight (usually in grams),
-   *L* is the total, standard, or fork length (usually in centimeters),
-   *a* is the intercept coefficient (related to body form), and
-   *b* is the allometric exponent (related to growth pattern).

To estimate these coefficients using linear regression, the equation is
log-transformed into its linear form:

log<sub>10</sub>(*W*) = log<sub>10</sub>(*a*) + *b* ⋅ log<sub>10</sub>(*L*)

This transformation allows the estimation of log<sub>10</sub>(*a*) and
*b* using ordinary least squares. FishBase provides the values of *a*
and *b* obtained through this procedure. The parameter *b* is
biologically informative — for example:

-   *b* ≈ 3: isometric growth (body shape remains proportional),
-   *b* &gt; 3: positive allometric growth (fish become stouter as they
    grow),
-   *b* &lt; 3: negative allometric growth (fish become more elongated
    as they grow).

# References

-   Froese, R. & Pauly, D. (Eds). FishBase. World Wide Web electronic
    publication. Link access: <https://fishbase.se>

-   **fishmetricR** package documentation.
