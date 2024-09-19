library(readr)
library(writexl)
library(readxl)


# Termos
termos <- c("Cidade Empreendedora", "PCE")

#Base 2019
df2019 <- read_csv("DataLab/03. Análises/SGEC/Programa Cidade Empreendedora/2019.csv", 
                  locale = locale(encoding = "cp1252"))

df2020 <- read_csv("DataLab/03. Análises/SGEC/Programa Cidade Empreendedora/2020.csv", 
                   locale = locale(encoding = "cp1252"))

df2021 <- read_csv("DataLab/03. Análises/SGEC/Programa Cidade Empreendedora/2021.csv", 
                   locale = locale(encoding = "cp1252"))

df2022 <- read_csv("DataLab/03. Análises/SGEC/Programa Cidade Empreendedora/2022.csv", 
                   locale = locale(encoding = "cp1252"))

df2023 <- read_csv("DataLab/03. Análises/SGEC/Programa Cidade Empreendedora/2023.csv", 
                   locale = locale(encoding = "cp1252"))

#Juntar 2023 e 2024
df_combinado <- rbind(df2019,df2020,df2021,df2022,df2023)


#Verificação de Termos
df_combinado$Linha_Termos <- sapply(1:nrow(df_combinado), function(i) {
  if (any(grepl(paste(termos, collapse = "|"), df_combinado$DS_OBJETIVO[i], ignore.case = TRUE))) {
    i
  } else {
    0  # Substitua NA por 0
  }
})


#Ocorrências
num_ocorrencias <- sum(df_combinado$Linha_Termos != 0)


#Filtrar PCE
df_filtrado <- df_combinado[df_combinado$Linha_Termos != 0, ]

write_xlsx(df_filtrado, "DataLab/03. Análises/SGEC/Programa Cidade Empreendedora/df_filtrado.xlsx")


#Juntar Bases Portal

X2019 <- read_excel("DataLab/03. Análises/SGEC/Programa Cidade Empreendedora/Bases Portal/2019.xls")
X2020 <- read_excel("DataLab/03. Análises/SGEC/Programa Cidade Empreendedora/Bases Portal/2020.xls")
X2021 <- read_excel("DataLab/03. Análises/SGEC/Programa Cidade Empreendedora/Bases Portal/2021.xls")
X2022 <- read_excel("DataLab/03. Análises/SGEC/Programa Cidade Empreendedora/Bases Portal/2022.xls")
X2023 <- read_excel("DataLab/03. Análises/SGEC/Programa Cidade Empreendedora/Bases Portal/2023.xls")

#Juntar 2023 e 2024
df_combinado_Portal <- rbind(X2019,X2020,X2021,X2022,X2023)

write_xlsx(df_combinado_Portal, "DataLab/03. Análises/SGEC/Programa Cidade Empreendedora/df_combinado_Portal.xlsx")







