---
  title: "Logistic Regression Test"
author: "Jesse Postma, Vani Rembet"
date: "`r Sys.Date()`"
output: html_document
---
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)

library(ggplot2)
library(tidyr)
```

```{r}
german_form <- read.table("Duitse taalvaardigheid onderzoek(1-154).csv", header = T, sep = ';', fileEncoding = 'latin1')
colnames(german_form) <- paste0("V", 1:ncol(german_form)) # verander headers naar kortere alternatief
head(german_form)
#zoek een persoon
german_form[1:2, ]
```
#### Dont forget: V16 is scale 1-5 dus geen vraag

```{r}
# Data uithalen
german_long <- pivot_longer(
  german_form,
  cols = 17:66,
  names_to = "question",
  values_to = "answer"
)

# Data opschonen
german_long$answer <- as.numeric(as.character(german_long$answer))

german_long <- subset(german_long, answer %in% c(0,1))

# Vraagnummers
german_long$question_num <- as.numeric(gsub("V", "", german_long$question)) - min(as.numeric(gsub("V", "", german_long$question))) + 1

# Logistic regression
model <- glm(answer ~ question_num, data = german_long, family = binomial)

a_0 <- coef(model)[1] # intercept
a_1 <- coef(model)[2] # helling

x_50 <- -a_0 / a_1 # 50% kans

# Voorspelling: wat is de kans dat iemand een vraag goed beantwoordt, gegeven het vraagnummer?
pred_data <- data.frame(
  question_num = seq(
    min(german_long$question_num),
    max(german_long$question_num)
  )
)

pred_data$prob <- predict(model, newdata = pred_data, type = "response")

# Grafiek maken
ggplot(german_long, aes(x = question_num, y = answer)) +
  geom_jitter(alpha = 0.1, height = 0.05) +
  geom_line(data = pred_data, aes(y = prob), color = "darkred") +
  geom_point(data = pred_data, aes(y = prob), color = "darkred") +
  labs(
    x = "Vraagnummer",
    y = "Slagingskans",
    title = "Gemiddelde behaalde niveau van alle deelnemers"
  ) +
  theme_minimal()
```
```{r}
# Data uithalen
german_long <- pivot_longer(
  german_form,
  cols = 17:66,
  names_to = "question",
  values_to = "answer"
)

# Data opschonen
german_long$answer <- as.numeric(as.character(german_long$answer))
german_long <- subset(german_long, answer %in% c(0,1))

# Vraagnummers
german_long$question_num <- as.numeric(gsub("V", "", german_long$question)) - min(as.numeric(gsub("V", "", german_long$question))) + 1

# Niveaus
german_long$gedeelte <- ceiling(german_long$question_num / 10) * 10

# Aantal goed per persoon per niveau
scores_gedeelte <- aggregate(answer ~ V1 + gedeelte, data = german_long, FUN = sum)

# Kies een persoon
scores_per_persoon <- aggregate(answer ~ V1, data = german_long, FUN = mean)
colnames(scores_per_persoon) <- c("persoon", "score")

persoon_id <- scores_per_persoon$persoon[2]
persoon_data <- subset(german_long, V1 == persoon_id)

# Drempel
drempel <- 6

persoon_scores <- subset(scores_gedeelte, V1 == persoon_id)
persoon_scores <- persoon_scores[order(persoon_scores$gedeelte), ]
behaald <- persoon_scores$gedeelte[cumprod(persoon_scores$answer >= drempel) == 1] # cumall: TRUE zolang alle voorgaande ook TRUE zijn, stopt bij eerste FALSE
hoogste_niveau <- ifelse(length(behaald) > 0, max(behaald), 0)

if (hoogste_niveau <- 10) niveau <- 'A1'
if (hoogste_niveau <- 20) {niveau <- 'A2'}
if (hoogste_niveau <- 30) {niveau <- 'B1'}
if (hoogste_niveau <- 40) {niveau <- 'B2'}
if (hoogste_niveau <- 20) {niveau <- 'C1'}

niveaus <- c('A1', 'A2', 'B1', 'B2', 'C1')
# Plotten
ggplot(persoon_data, aes(x = factor(gedeelte), y = answer)) +
  geom_jitter(alpha = 0.1, height = 0.05) +
  geom_boxplot() +
  labs(
    x = "Vraagnummer",
    y = "Slagingskans",
    title = paste("Niveau persoon", persoon_id, "=", hoogste_niveau)
  ) +
  theme_minimal()

# niveau van één individu opvragen
ggplot(persoon_data, aes(x = factor(gedeelte), y = answer)) +
  geom_jitter(alpha = 0.1, height = 0.05) +
  labs(
    x = "Vraagnummer",
    y = "Slagingskans",
    title = paste("Niveau persoon", persoon_id, "=", niveau)
  ) +
  theme_minimal()

# niveaus meerdere individuen
personen <- scores_per_persoon$persoon[1]

ggplot(persoon_data, aes(x = factor(gedeelte), y = niveaus)) +
  geom_jitter(alpha = 0.1, height = 0.05) +
  labs(
    x = "Vraagnummer",
    y = "Slagingskans",
    title = paste("Niveau persoon", persoon_id, "=", niveau)
  ) +
  theme_minimal()  
```

---
  title: "Logistic Individual"
author: "Jesse Postma"
date: "`r Sys.Date()`"
output: html_document
---
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)

library(ggplot2)
library(tidyr)
library(mirt)
library(dplyr)

```

### Dit is een implementatie van logistic regression per persoon zodat er een niveau uit valt te halen.

#### Inlezen en fitten aan model

```{r}
german_res <- read.table("Duitse taalvaardigheid onderzoek(1-154).csv", sep = ';', fileEncoding = 'latin1', skip = 1)


questions <- german_res %>% select(V17:V66) # pak alle antwoorden (1/0)

irt_model <- mirt(data = questions, model = 1, itemtype = "Rasch")
# fit aan een irt model

individual_scores <- fscores(irt_model) # haal resultaten uit model
item_params <- coef(irt_model, IRTpars = TRUE, simplify = TRUE)$item
head(item_params)
```

#### Drempel gebruiken

```{r}
# Define the logit for your chosen probability (e.g., 80% mastery)
prob_target <- 0.60
logit_add <- log(prob_target / (1 - prob_target))

diff_A1 <- mean(item_params[paste0("V", 17:26), "b"])
diff_A2 <- mean(item_params[paste0("V", 27:36), "b"])
diff_B1 <- mean(item_params[paste0("V", 37:46), "b"])
diff_B2 <- mean(item_params[paste0("V", 47:56), "b"])
diff_C1C2 <- mean(item_params[paste0("V", 57:66), "b"])

# Calculate the final threshold required to accomplish that level with probability
threshold_A2 <- diff_A2 + logit_add
threshold_B1 <- diff_B1 + logit_add
threshold_B2 <- diff_B2 + logit_add
threshold_C1C2 <- diff_C1C2 + logit_add

# Print them out so you can see your exact mathematical cut-offs!
cat("Threshold for A2:", threshold_A2, "\n")
cat("Threshold for B1:", threshold_B1, "\n")
cat("Threshold for B2:", threshold_B2, "\n")
cat("Threshold for C1/2:", threshold_C1C2, "\n")

```

#### Nu kunnen we nieuwe kolommen genereren met score en niveau pp

```{r}
# met dplyr df aanpassen:

cleaned_data <- german_res %>% 
  mutate(
    score = as.numeric(individual_scores),
    
    CEFR = case_when(
      score < threshold_A2 ~ "A1",
      score >= threshold_A2 & score < threshold_B1 ~ "A2",
      score >= threshold_B1 & score < threshold_B2 ~ "B1",
      score >= threshold_B2 & score < threshold_C1C2 ~ "B2",
      score >= threshold_C1C2 ~ "C1/C2",
      TRUE ~ "Unknown"
    )
  ) %>% 
  select(-(V17:V66))

```

#### Basic info

```{r}
cat("Hoogste score: " ,which.max(cleaned_data$score), "\n")
cat("Laagste score: " ,which.min(cleaned_data$score), "\n")
```

#### Goede namen voor kolommen toevoegen en file uitschrijven

```{r}
names <- c("id", "t_start", "t_end", "auth", "consent", "leeftijd", "opleiding", "d_grens", "woonwerk_duits", "fam_kennis", "gebruik_hoevaak", "situaties", "interesse_taal", "interesse_duits", "duits_belang", "schatting", "score", "CEFR")

colnames(cleaned_data) <- names

cleaned_data

write.csv(cleaned_data, "../ruwe_data/cleaned_scores.csv")
```