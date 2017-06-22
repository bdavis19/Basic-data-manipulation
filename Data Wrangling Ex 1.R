# Libraries to use
library(tidyverse)

# Read the CSV file for use
prodPurchases <- read.csv("refine_original.csv", header = TRUE, sep = ",")

# Correct spelling errors in company name and make them lower case
prodPurchases$company <- tolower(prodPurchases$company)
prodPurchases$company <- sub(pattern = ".*\\ps$", replacement = "Philips", x = prodPurchases$company)
prodPurchases$company <- sub(pattern = "^ak.*", replacement = "Akzo", x = prodPurchases$company)
prodPurchases$company <- sub(pattern = "^u.*", replacement = "Unilever", x = prodPurchases$company)
prodPurchases$company <- sub(pattern = "^v.*", replacement = "Van Houten", x = prodPurchases$company)

# Separate the Product.code...number column
prodPurchases <- separate(prodPurchases, "Product.code...number", c("product_code", "product_number"), sep = "-")

# Add a column with a readable version of Cateogry
prodPurchases$product_category <- sub(pattern = "^p$", replacement = "Smartphone", x = sub("^x$", "Laptop", sub("^v$", "TV", sub("^q$", "Tablet", prodPurchases$product_code))))

# Add a column with the full address separated by commas
prodPurchases <- prodPurchases %>% 
  mutate(full_address = paste(address, city, country, sep = ","))

# Create dummy variables for company and product category
prodPurchases <- mutate(prodPurchases, company_philips = ifelse(company == "Philips", 1, 0))
prodPurchases <- mutate(prodPurchases, company_akzo = ifelse(company == "Akzo", 1, 0))
prodPurchases <- mutate(prodPurchases, company_van_houten = ifelse(company == "Van Houten", 1, 0))
prodPurchases <- mutate(prodPurchases, company_unilever = ifelse(company == "Unilever", 1, 0))
prodPurchases <- mutate(prodPurchases, product_smartphone = ifelse(product_category == "Smartphone", 1, 0))
prodPurchases <- mutate(prodPurchases, product_tv = ifelse(product_category == "TV", 1, 0))
prodPurchases <- mutate(prodPurchases, product_laptop = ifelse(product_category == "Laptop", 1, 0))
prodPurchases <- mutate(prodPurchases, product_tablet = ifelse(product_category == "Tablet", 1, 0))

# Write to csv
write.csv(prodPurchases, "refine_clean.csv")