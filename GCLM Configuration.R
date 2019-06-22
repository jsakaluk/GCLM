library(devtools)
library(roxygen2)
library(usethis)

usethis::use_gpl3_license(name = "John K. Sakaluk")
usethis::use_package("lavaan", "Imports")

usethis::use_citation()
usethis::use_roxygen_md()
usethis::use_readme_rmd()
usethis::use_pipe()

usethis::use_package_doc()
#usethis::use_news_md()
usethis::use_description(fields = list(Title = "GCLM",
                                       Description = "Functions for Automated lavaan() Scripting of Generalized Cross-Lagged Panel Models (Zyphur et al., 2019)",
                                       `Authors@R`= 'c(
  person("John", "Sakaluk", email = "jksakaluk@gmail.com", role = "cre", comment = c(ORCID = "0000-0002-2515-9822"))',
                                       License = "GPL-3"))


remove.packages("dySEM")
.rs.restartR()

devtools::build()
devtools::install()
devtools::document()
devtools::build_manual()
devtools::check()

citEntry(entry="Article",
         title = "Dyadic Measurement Invariance and Its Importance for Replicability in Romantic Relationship Science",
         author = personList(person("John", "Sakaluk", "K."), person("Robyn", "Kilshaw", "E."), person("Alexandra", "Fisher", "N.")),
         journal = "Personal Relationships (in press)",
         year = "2019",
         volume = "",
         header="To cite dySEM in publications use:",
         pages = "",
         textVersion =
           paste("Sakaluk, J. K., Kilshaw, R. E., & Fisher, A. N. (2019) Dyadic Measurement Invariance",
                 "and Its Importance for Replicability in Romantic Relationship Science. Personal Relationships (in press)")
)

citation("dySEM")
