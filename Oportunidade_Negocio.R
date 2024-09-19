#Pacotes
library(ggpubr)
library(factoextra)
library(writexl)
library(dplyr)
library(readxl)
library(ggpubr)

#Carregamento dos dados
base <- read_excel("~/DataLab/12. Feira do Empreendedor/2024/Oportunida de Negócio/Aplicação Metodologia/Base.xlsm", 
                   col_types = c("text", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric"))


#Retira NA
df <- data.frame(na.omit(base))
head(df, 3)

# k-means com k = 4
set.seed(123)
res.km <- kmeans(scale(df[, -1]), 4, nstart = 25)

# K-means clusters 
res.km$cluster
res.km

fviz_cluster(res.km, data = df[, -1],
             palette = c("#E69F00", "#56B4E9", "#CC79A7","#009E73"), 
             geom = "point",
             ellipse.type = "convex", 
             ggtheme = theme_bw()
)


# Dimension usando PCA
res.pca <- prcomp(df[, -1],  scale = TRUE)

# Coordenadas 
ind.coord <- as.data.frame(get_pca_ind(res.pca)$coord)

# Adiciona cluster do K-means
ind.coord$cluster <- factor(res.km$cluster)

# Adiciona nome cidades
ind.coord$MUNICIPIO <- df$MUNICIPIO
head(ind.coord)

# Percentage of variance explained by dimensions
eigenvalue <- round(get_eigenvalue(res.pca), 1)
variance.percent <- eigenvalue$variance.percent
head(eigenvalue)

#Montar base para Plotagem

#Base só do cluster 2 (Curitiba)
dados <- subset(ind.coord, cluster ==2)

#Base filtrado Dim 1 e Dim 2 e municipio
dados <- dados [,c(1,2,46)]
dados [,c(1,2)] <- data.frame(scale(dados[,c(1,2)]))


# Definir o ponto de referência para o cálculo das distâncias
ponto_de_referencia <- c(dados$Dim.1[30], dados$Dim.2[30])

# Calcular as distâncias euclidianas entre cada ponto e o ponto de referência
distancias <- sqrt((dados$Dim.1 - ponto_de_referencia[1])^2 + (dados$Dim.2 - ponto_de_referencia[2])^2)

#Juntar bases de distância e dados
dados <- cbind(dados,distancias)

# Ordenar as distâncias e obter os índices dos 10 números mais próximos
indices_mais_proximos <- order(distancias)[1:11]

# Criar dataframe para os 10 pontos mais próximos
pontos_proximos <- dados[indices_mais_proximos, ]


# Criar o gráfico com ggplot2
ggplot() +
  geom_point(data = dados, aes(x = Dim.1, y = Dim.2), color = "gray50", size = 3) +  # Todos os pontos em cinza
  geom_point(data = pontos_proximos, aes(x = Dim.1, y = Dim.2), color = "#56B4E9", size = 3, shape = 21, fill = "#56B4E9") +  # 10 pontos mais próximos em vermelho com borda preenchida
  geom_point(data = data.frame(x = ponto_de_referencia[1], y = ponto_de_referencia[2]), aes(x, y), color = "darkblue", size = 4, shape = 19) +  # Ponto de referência como um ponto verde escuro
  labs(x = "Dimensão 1", y = "Dimensão 2", title = "10 Municípios Mais Próximos") +  # Título centralizado
  theme(plot.title = element_text(hjust = 0.5))  # Centralizar o título

#Pontos com os 10 municípios
ggplot() +
  geom_point(data = pontos_proximos, aes(x = Dim.1, y = Dim.2), color = "gray50", size = 3) +  # Todos os pontos em cinza
  geom_point(data = pontos_proximos, aes(x = Dim.1, y = Dim.2), color = "#56B4E9", size = 3, shape = 21, fill = "#56B4E9") +  # 10 pontos mais próximos em azul claro
  geom_text(data = pontos_proximos, aes(x = Dim.1, y = Dim.2, label = MUNICIPIO ), color = "black", vjust = -0.5) +  # Nomes das cidades
  geom_point(data = data.frame(x = ponto_de_referencia[1], y = ponto_de_referencia[2]), aes(x, y), color = "darkblue", size = 4, shape = 19) +  # Ponto de referência como um ponto verde escuro
  labs(x = "Dimensão 1", y = "Dimensão 2", title = "10 Municípios Mais Próximos") +  # Título centralizado
  theme(plot.title = element_text(hjust = 0.5)) 

#10 municípios
pontos_proximos

