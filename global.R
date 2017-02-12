library(dplyr)

allzips <- readRDS("data/superzip.rds")
allzips$latitude <- jitter(allzips$latitude)
allzips$longitude <- jitter(allzips$longitude)
allzips$college <- allzips$college * 100
allzips$zipcode <- formatC(allzips$zipcode, width=5, format="d", flag="0")
row.names(allzips) <- allzips$zipcode



colnames(allzips)[which(names(allzips) == "college")] <- "education"


colnames(allzips)[which(names(allzips) == "adultpop")] <- "population"

cleantable <- allzips %>%
  select(
    City = city.x,
    State = state.x,
    Zipcode = zipcode,
    Rank = rank,
    Score = centile,
    Superzip = superzip,
    Population = population,
    Education = education,
    Income = income,
    Lat = latitude,
    Long = longitude
  )
