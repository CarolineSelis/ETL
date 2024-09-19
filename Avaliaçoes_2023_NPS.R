#Lê a base de dados
library(readxl)
base <- read_excel("DataLab/03. Análises/NIP/Dados Avaliações - Doc 2 20230721.xlsx")
names (base)

#Montando Dataframe com as variéveis de interesse

library(dplyr)

base_n <- data.frame(base$`NOTA NPS REPLICADA`, base$TIPO_RELACAO, base$ESCOLARIDADE,base$TIPO_SEXO,
                     base$REGIONAL, base$DS_COMUNICACAO, base$DS_CANAL_ATEND, base$DS_MODALIDADE, 
                     base$TP_PORTE_PJ, base$DS_SETOR_PJ, base$DS_SC_PERFIL, base$Orientação, base$Oficinas,
                     base$Seminários, base$`Missões Técnicas`, base$Feiras, base$Caravanas, base$`Livros e Revistas`,
                     base$Conteudista, base$Consultoria, base$Palestras, base$`Rodadas de Negócio`, base$Cursos,
                     base$Coaching, base$`Receptivo Call Center`, base$Mentoria)


#Renomeia as colunas 
base_n <-rename(.data =base_n, "Notas" = base..NOTA.NPS.REPLICADA., "Tipo_relacao" = base.TIPO_RELACAO,
                "Escolaridade" = base.ESCOLARIDADE, "Genêro" = base.TIPO_SEXO, "Regional" = base.REGIONAL,
                "Comunicacao" = base.DS_COMUNICACAO, "Canal" = base.DS_CANAL_ATEND,  
                "Modalidade" = base.DS_MODALIDADE,"Porte" = base.TP_PORTE_PJ, "Setor" = base.DS_SETOR_PJ )

base_n <- rename (.data =base_n,"Perfil" = base.DS_SC_PERFIL )

#Informações do dataframe
head(base_n)
names(base_n)



# Modelo completo + r2_40%
library(MASS)
library(leaps)
mod <- lm(Notas ~., data = base_n)
summary(mod)

#Ajuste de janela para Plotagem de gráfico
par(mfrow = c(2, 2))
#Plotagem de gráfico de erros
plot (mod)


m1 <- step(mod, direction = "both")

