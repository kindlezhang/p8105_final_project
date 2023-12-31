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
  select(country_name,country_code,GDP)|>
  mutate(GDP=GDP/10^9)
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
  read_html("https://www.countrycallingcodes.com/iso-country-codes/europe-codes.php") |>
  html_elements("tr+ tr td:nth-child(3) font") |>
  html_text()|>
  append("JEY")

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
least_develpoed=
  read_csv("./data/least-developed-countries-2023.csv")|>
  pull(cca3)
```

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
  rename(c(country_code_2=X1,country_code_3=X2))|>
  mutate(country_code_2=gsub('[ ]','',country_code_2),
         country_code_3=gsub('[ ]','',country_code_3))|>
  distinct(country_code_3, .keep_all = T)
```

## overall dataset

``` r
corruption_data=left_join(corruption,country_code,join_by(country_code==country_code_3))|>
  left_join(GDP,join_by(country_code==country_code))|>
  left_join(country_coordinate,join_by(country_code_2==country_code))|>
  mutate(development=case_when(
    country_code %in% developed ~ "Developed",
    country_code %in% least_develpoed ~ "Least Developed",
    (!country_code %in% developed) & (!country_code %in% least_develpoed) ~ "Developing"
  ))|>
  mutate(continent=case_when(
    country_code %in% Asia ~ "Asia",
    country_code %in% Africa ~ "Africa",
    country_code %in% Europe ~ "Europe",
    country_code %in% North_America ~ "North America",
    country_code %in% South_America ~ "South America",
    country_code %in% Oceania ~ "Oceania",
    country_code %in% Antarctica ~ "Antarctica"
  ))|>
  select(country_name,
         corruption_index=control_of_corruption_estimate,
         government_effectiveness=government_effectiveness_estimate,
         political_stability_and_absence_of_violence_terrorism=political_stability_and_absence_of_violence_terrorism_estimate,
         regulatory_quality=regulatory_quality_estimate,
         rule_of_law=rule_of_law_estimate,
         voice_and_accountability=voice_and_accountability_estimate,
         GDP,latitude,longitude,development,continent)
```
