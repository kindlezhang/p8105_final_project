Data Manipulation and cleaning
================
Yunshen Bai
2023-12-02

``` r
library(tidyverse)
library(rvest)
library(httr)
```

## source 1:corruption index

``` r
corruption=read_csv("./data/corruption_index.csv")|>
  janitor::clean_names()|>
  mutate(value=(as.numeric(x2020_yr2020)+as.numeric(x2020_yr2020)+as.numeric(x2020_yr2020))/3)|>
  select(country_name,country_code,series_name,value)|>
  pivot_wider(
    names_from = "series_name",
    values_from = "value"
  )|>
  janitor::clean_names()
```

## sourse 2:GDP

``` r
GDP=read_csv("./data/GDP.csv")|>
  janitor::clean_names()|>
  filter(average_gdp!="#DIV/0!")|>
  mutate(GDP=as.numeric(average_gdp))|>
  select(country_name,country_code,GDP)
```

    ## Rows: 266 Columns: 68
    ## -- Column specification --------------------------------------------------------
    ## Delimiter: ","
    ## chr  (5): Country Name, Country Code, Indicator Name, Indicator Code, averag...
    ## dbl (63): 1960, 1961, 1962, 1963, 1964, 1965, 1966, 1967, 1968, 1969, 1970, ...
    ## 
    ## i Use `spec()` to retrieve the full column specification for this data.
    ## i Specify the column types or set `show_col_types = FALSE` to quiet this message.

## source 3:continent

``` r
Africa=
  read_html("https://www.countrycallingcodes.com/iso-country-codes/africa-codes.php") |>
  html_elements("tr+ tr td:nth-child(3) font") |>
  html_text()

Asia=
  read_html("https://www.countrycallingcodes.com/iso-country-codes/asia-codes.php") |>
  html_elements("tr+ tr td:nth-child(3) font") |>
  html_text()

Europe=
  read_html("https://www.countrycallingcodes.com/iso-country-codes/africa-codes.php") |>
  html_elements("tr+ tr td:nth-child(3) font") |>
  html_text()

North_America=
  read_html("https://www.countrycallingcodes.com/iso-country-codes/north-america-codes.php") |>
  html_elements("tr+ tr td:nth-child(3) font") |>
  html_text()

South_America=
  read_html("https://www.countrycallingcodes.com/iso-country-codes/south-america-codes.php") |>
  html_elements("tr+ tr td:nth-child(3) font") |>
  html_text()

Oceania=
  read_html("https://www.countrycallingcodes.com/iso-country-codes/australia-codes.php") |>
  html_elements("tr+ tr td:nth-child(3) font") |>
  html_text()

Antarctica=
  read_html("https://www.countrycallingcodes.com/iso-country-codes/antarctica-codes.php") |>
  html_elements("tr+ tr td:nth-child(3) font") |>
  html_text()
```

## source 4: coordinate

``` r
coordinate_html=
  read_html("https://developers.google.com/public-data/docs/canonical/countries_csv?hl=en")

country_name=
  coordinate_html |>
  html_elements("td:nth-child(4)") |>
  html_text()

country_code=
  coordinate_html |>
  html_elements("td:nth-child(1)") |>
  html_text() 

latitude=
  coordinate_html |>
  html_elements("td:nth-child(2)") |>
  html_text()

longitude=
  coordinate_html |>
  html_elements("td:nth-child(3)") |>
  html_text()

country_coordinate=
  data.frame(country_name,country_code,latitude,longitude)
```

## source 5: developed/developing

``` r
developed=
  read_csv("./data/developed-countries-2023.csv")|>
  pull(cca3)
```

    ## Rows: 66 Columns: 18
    ## -- Column specification --------------------------------------------------------
    ## Delimiter: ","
    ## chr  (6): country, cca3, cca2, region, subregion, officialName
    ## dbl (11): place, pop2023, growthRate, area, ccn3, landAreaKm, density, densi...
    ## lgl  (1): unMember
    ## 
    ## i Use `spec()` to retrieve the full column specification for this data.
    ## i Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
least_develpoed=
  read_csv("./data/least-developed-countries-2023.csv")|>
  pull(cca3)
```

    ## Rows: 49 Columns: 21
    ## -- Column specification --------------------------------------------------------
    ## Delimiter: ","
    ## chr  (8): country, cca3, cca2, region, subregion, officialName, LeastDevelop...
    ## dbl (12): place, pop2023, growthRate, area, ccn3, landAreaKm, density, densi...
    ## lgl  (1): unMember
    ## 
    ## i Use `spec()` to retrieve the full column specification for this data.
    ## i Specify the column types or set `show_col_types = FALSE` to quiet this message.

## source 6: country code

``` r
isso_code=
  read_html("https://www.countrycode.org/")|>
  html_elements("td:nth-child(3)")|>
  html_text()

country_name_isso=
  read_html("https://www.countrycode.org/")|>
  html_elements("td:nth-child(1)")|>
  html_text()

country_code=data.frame(country_name_isso,str_split_fixed(isso_code, '/',2))|>
  rename(c(country_code_2=X1,country_code_3=X2))
```
