install.packages("rcompanion")
install.packages("tidyr")
install.packages("pgirmess")

library(rcompanion)
library(tidyr)
library(pgirmess)

############ Read data #############.

ds_file = "data_study_anonymized.csv"   ## add path to filename

ds = read.table(
  file=ds_file, encoding="UTF-8", fileEncoding="UTF-8",
  header = FALSE, sep = "\t", quote = "\"",
  dec = ".", row.names = "CASE",
  col.names = c(
    "CASE","SERIAL","REF","QUESTNNR","MODE","STARTED","SD01","SD15_01","SD15_01a",
    "SD19_01","SD20_01","ST01","ST01_01","CO17_01","CO17_02","CO17_03","CO25_01",
    "CO25_02","CO25_03","CO30_01","CO30_02","CO30_03","CO19_01","CO19_02","CO19_03",
    "CO31_01","CO31_02","CO31_03","CO21_01","CO21_02","CO21_03","CO27_01","CO27_02",
    "CO27_03","CO18_01","CO18_02","CO18_03","CO29_01","CO29_02","CO29_03","CO22_01",
    "CO22_02","CO22_03","CO20_01","CO20_02","CO20_03","Z101_CP","Z101","Z102_CP",
    "Z102","Z103_CP","Z103","OP01_01","OP02_01","OP03_01","OP04_01","TIME002",
    "TIME003","TIME004","TIME005","TIME006","TIME007","TIME008","TIME009","TIME010",
    "TIME011","TIME012","TIME013","TIME_SUM","MAILSENT","LASTDATA","FINISHED",
    "Q_VIEWER","LASTPAGE","MAXPAGE","MISSING","MISSREL","TIME_RSI","DEG_TIME"
  ),
  as.is = TRUE,
  colClasses = c(
    CASE="numeric", SERIAL="character", REF="character", QUESTNNR="character",
    MODE="factor", STARTED="POSIXct", SD01="numeric", SD15_01="character",
    SD15_01a="logical", SD19_01="numeric", SD20_01="character", ST01="numeric",
    ST01_01="logical", CO17_01="numeric", CO17_02="numeric", CO17_03="numeric",
    CO25_01="numeric", CO25_02="numeric", CO25_03="numeric", CO30_01="numeric",
    CO30_02="numeric", CO30_03="numeric", CO19_01="numeric", CO19_02="numeric",
    CO19_03="numeric", CO31_01="numeric", CO31_02="numeric", CO31_03="numeric",
    CO21_01="numeric", CO21_02="numeric", CO21_03="numeric", CO27_01="numeric",
    CO27_02="numeric", CO27_03="numeric", CO18_01="numeric", CO18_02="numeric",
    CO18_03="numeric", CO29_01="numeric", CO29_02="numeric", CO29_03="numeric",
    CO22_01="numeric", CO22_02="numeric", CO22_03="numeric", CO20_01="numeric",
    CO20_02="numeric", CO20_03="numeric", Z101_CP="numeric", Z101="numeric",
    Z102_CP="numeric", Z102="numeric", Z103_CP="numeric", Z103="numeric",
    OP01_01="character", OP02_01="character", OP03_01="character",
    OP04_01="character", TIME002="integer", TIME003="integer",
    TIME004="integer", TIME005="integer", TIME006="integer", TIME007="integer",
    TIME008="integer", TIME009="integer", TIME010="integer", TIME011="integer",
    TIME012="integer", TIME013="integer", TIME_SUM="integer",
    MAILSENT="POSIXct", LASTDATA="POSIXct", FINISHED="logical",
    Q_VIEWER="logical", LASTPAGE="numeric", MAXPAGE="numeric",
    MISSING="numeric", MISSREL="numeric", TIME_RSI="numeric", DEG_TIME="numeric"
  ),
  skip = 1,
  check.names = TRUE, fill = TRUE,
  strip.white = FALSE, blank.lines.skip = TRUE,
  comment.char = "",
  na.strings = ""
)

rm(ds_file)

attr(ds, "project") = "KI-Verstehen"
attr(ds, "description") = "Counterfactuals2"
attr(ds, "date") = "2022-08-14 22:55:37"
attr(ds, "server") = "https://www.soscisurvey.de"

# Variable und Value Labels
ds$SD01 = factor(ds$SD01, levels=c("1","2","3","-9"), labels=c("weiblich","männlich","divers","[NA] nicht beantwortet"), ordered=FALSE)
attr(ds$SD15_01a,"F") = "nicht gewählt"
attr(ds$SD15_01a,"T") = "ausgewählt"
attr(ds$ST01_01,"F") = "nicht gewählt"
attr(ds$ST01_01,"T") = "ausgewählt"
attr(ds$CO17_01,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO17_01,"7") = "Stimme voll und ganz zu"
attr(ds$CO17_02,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO17_02,"7") = "Stimme voll und ganz zu"
attr(ds$CO17_03,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO17_03,"7") = "Stimme voll und ganz zu"
attr(ds$CO25_01,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO25_01,"7") = "Stimme voll und ganz zu"
attr(ds$CO25_02,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO25_02,"7") = "Stimme voll und ganz zu"
attr(ds$CO25_03,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO25_03,"7") = "Stimme voll und ganz zu"
attr(ds$CO30_01,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO30_01,"7") = "Stimme voll und ganz zu"
attr(ds$CO30_02,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO30_02,"7") = "Stimme voll und ganz zu"
attr(ds$CO30_03,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO30_03,"7") = "Stimme voll und ganz zu"
attr(ds$CO19_01,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO19_01,"7") = "Stimme voll und ganz zu"
attr(ds$CO19_02,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO19_02,"7") = "Stimme voll und ganz zu"
attr(ds$CO19_03,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO19_03,"7") = "Stimme voll und ganz zu"
attr(ds$CO31_01,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO31_01,"7") = "Stimme voll und ganz zu"
attr(ds$CO31_02,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO31_02,"7") = "Stimme voll und ganz zu"
attr(ds$CO31_03,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO31_03,"7") = "Stimme voll und ganz zu"
attr(ds$CO21_01,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO21_01,"7") = "Stimme voll und ganz zu"
attr(ds$CO21_02,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO21_02,"7") = "Stimme voll und ganz zu"
attr(ds$CO21_03,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO21_03,"7") = "Stimme voll und ganz zu"
attr(ds$CO27_01,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO27_01,"7") = "Stimme voll und ganz zu"
attr(ds$CO27_02,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO27_02,"7") = "Stimme voll und ganz zu"
attr(ds$CO27_03,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO27_03,"7") = "Stimme voll und ganz zu"
attr(ds$CO18_01,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO18_01,"7") = "Stimme voll und ganz zu"
attr(ds$CO18_02,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO18_02,"7") = "Stimme voll und ganz zu"
attr(ds$CO18_03,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO18_03,"7") = "Stimme voll und ganz zu"
attr(ds$CO29_01,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO29_01,"7") = "Stimme voll und ganz zu"
attr(ds$CO29_02,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO29_02,"7") = "Stimme voll und ganz zu"
attr(ds$CO29_03,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO29_03,"7") = "Stimme voll und ganz zu"
attr(ds$CO22_01,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO22_01,"7") = "Stimme voll und ganz zu"
attr(ds$CO22_02,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO22_02,"7") = "Stimme voll und ganz zu"
attr(ds$CO22_03,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO22_03,"7") = "Stimme voll und ganz zu"
attr(ds$CO20_01,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO20_01,"7") = "Stimme voll und ganz zu"
attr(ds$CO20_02,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO20_02,"7") = "Stimme voll und ganz zu"
attr(ds$CO20_03,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO20_03,"7") = "Stimme voll und ganz zu"
attr(ds$Z101,"1") = "1"
attr(ds$Z101,"2") = "2"
attr(ds$Z102,"1") = "1"
attr(ds$Z102,"2") = "2"
attr(ds$Z103,"1") = "1"
attr(ds$Z103,"2") = "2"
attr(ds$FINISHED,"F") = "abgebrochen"
attr(ds$FINISHED,"T") = "ausgefüllt"
attr(ds$Q_VIEWER,"F") = "Teilnehmer"
attr(ds$Q_VIEWER,"T") = "Durchklicker"
comment(ds$SERIAL) = "Seriennummer (sofern verwendet)"
comment(ds$REF) = "Referenz (sofern im Link angegeben)"
comment(ds$QUESTNNR) = "Fragebogen, der im Interview verwendet wurde"
comment(ds$MODE) = "Interview-Modus"
comment(ds$STARTED) = "Zeitpunkt zu dem das Interview begonnen hat (Europe/Berlin)"
comment(ds$SD01) = "Geschlecht"
comment(ds$SD15_01) = "Beschäftigung (offen): [01]"
comment(ds$SD15_01a) = "Beschäftigung (offen): [01]: Ich befinde mich noch in der Ausbildung"
comment(ds$SD19_01) = "Alter:  ... Jahre"
comment(ds$SD20_01) = "Anmerkungen: [01]"
comment(ds$ST01) = "Zustimmung: Ausweichoption (negativ) oder Anzahl ausgewählter Optionen"
comment(ds$ST01_01) = "Zustimmung: Ich stimme den Versuchsbedingungen zu und bin über 16 Jahre alt."
comment(ds$CO17_01) = "Frage_F_Concept: Die Information hilft, die Entscheidung des Programms besser zu verstehen."
comment(ds$CO17_02) = "Frage_F_Concept: Diese Information ist nützlich."
comment(ds$CO17_03) = "Frage_F_Concept: Diese Information zu erhalten erhöht die Kontrollierbarkeit der KI."
comment(ds$CO25_01) = "Frage_K_Concept_fremd_lang: Die Information hilft Clara, die Entscheidung des Programms besser zu verstehen."
comment(ds$CO25_02) = "Frage_K_Concept_fremd_lang: Diese Information ist nützlich für Clara."
comment(ds$CO25_03) = "Frage_K_Concept_fremd_lang: Diese Information zu erhalten erhöht die Kontrollierbarkeit der KI."
comment(ds$CO30_01) = "Frage_K_Concept_fremd_kurz: Die Information hilft Clara, die Entscheidung des Programms besser zu verstehen."
comment(ds$CO30_02) = "Frage_K_Concept_fremd_kurz: Diese Information ist nützlich für Clara."
comment(ds$CO30_03) = "Frage_K_Concept_fremd_kurz: Diese Information zu erhalten erhöht die Kontrollierbarkeit der KI."
comment(ds$CO19_01) = "Frage_A_Concept: Die Information hilft, die Entscheidung des Programms besser zu verstehen."
comment(ds$CO19_02) = "Frage_A_Concept: Diese Information ist nützlich."
comment(ds$CO19_03) = "Frage_A_Concept: Diese Information zu erhalten erhöht die Kontrollierbarkeit der KI."
comment(ds$CO31_01) = "Frage_A_Concept_kurz: Die Information hilft mir, die Entscheidung des Programms besser zu verstehen."
comment(ds$CO31_02) = "Frage_A_Concept_kurz: Diese Information ist nützlich."
comment(ds$CO31_03) = "Frage_A_Concept_kurz: Diese Information zu erhalten erhöht die Kontrollierbarkeit der KI."
comment(ds$CO21_01) = "Frage_M_Concept_Patient_fremd_kurz: Die Information hilft Clara, die Entscheidung des Programms besser zu verstehen."
comment(ds$CO21_02) = "Frage_M_Concept_Patient_fremd_kurz: Diese Information ist nützlich für Clara."
comment(ds$CO21_03) = "Frage_M_Concept_Patient_fremd_kurz: Diese Information zu erhalten erhöht die Kontrollierbarkeit der KI."
comment(ds$CO27_01) = "Frage_M_Concept_Patient_fremd_lang: Die Information hilft Clara, die Entscheidung des Programms besser zu verstehen."
comment(ds$CO27_02) = "Frage_M_Concept_Patient_fremd_lang: Diese Information ist nützlich für Clara."
comment(ds$CO27_03) = "Frage_M_Concept_Patient_fremd_lang: Diese Information zu erhalten erhöht die Kontrollierbarkeit der KI."
comment(ds$CO18_01) = "Frage_F_Counterfactual: Die Information hilft, die Entscheidung des Programms besser zu verstehen."
comment(ds$CO18_02) = "Frage_F_Counterfactual: Diese Information ist nützlich."
comment(ds$CO18_03) = "Frage_F_Counterfactual: Diese Information zu erhalten erhöht die Kontrollierbarkeit der KI."
comment(ds$CO29_01) = "Frage_K_Counterfactual_fremd: Die Information hilft Clara, die Entscheidung des Programms besser zu verstehen."
comment(ds$CO29_02) = "Frage_K_Counterfactual_fremd: Diese Information ist nützlich für Clara."
comment(ds$CO29_03) = "Frage_K_Counterfactual_fremd: Diese Information zu erhalten erhöht die Kontrollierbarkeit der KI."
comment(ds$CO22_01) = "Frage_M_Counterfactual_Patient_fremd: Die Information hilft Clara, die Entscheidung des Programms besser zu verstehen."
comment(ds$CO22_02) = "Frage_M_Counterfactual_Patient_fremd: Diese Erklärung ist nützlich für Clara."
comment(ds$CO22_03) = "Frage_M_Counterfactual_Patient_fremd: Diese Information zu erhalten erhöht die Kontrollierbarkeit der KI."
comment(ds$CO20_01) = "Frage_A_Counterfactual: Die Information hilft, die Entscheidung des Programms besser zu verstehen."
comment(ds$CO20_02) = "Frage_A_Counterfactual: Diese Information ist nützlich."
comment(ds$CO20_03) = "Frage_A_Counterfactual: Diese Information zu erhalten erhöht die Kontrollierbarkeit der KI."
comment(ds$Z101_CP) = "Z2: Vollständige Leerungen der Urne bisher"
comment(ds$Z101) = "Z2: Gezogener Code"
comment(ds$Z102_CP) = "Z2: Vollständige Leerungen der Urne bisher"
comment(ds$Z102) = "Z2: Gezogener Code"
comment(ds$Z103_CP) = "Z2: Vollständige Leerungen der Urne bisher"
comment(ds$Z103) = "Z2: Gezogener Code"
comment(ds$OP01_01) = "Open: [01]"
comment(ds$OP02_01) = "Open: [01]"
comment(ds$OP03_01) = "Open: [01]"
comment(ds$OP04_01) = "Open: [01]"
comment(ds$TIME002) = "Verweildauer Seite 2"
comment(ds$TIME003) = "Verweildauer Seite 3"
comment(ds$TIME004) = "Verweildauer Seite 4"
comment(ds$TIME005) = "Verweildauer Seite 5"
comment(ds$TIME006) = "Verweildauer Seite 6"
comment(ds$TIME007) = "Verweildauer Seite 7"
comment(ds$TIME008) = "Verweildauer Seite 8"
comment(ds$TIME009) = "Verweildauer Seite 9"
comment(ds$TIME010) = "Verweildauer Seite 10"
comment(ds$TIME011) = "Verweildauer Seite 11"
comment(ds$TIME012) = "Verweildauer Seite 12"
comment(ds$TIME013) = "Verweildauer Seite 13"
comment(ds$TIME_SUM) = "Verweildauer gesamt (ohne Ausreißer)"
comment(ds$MAILSENT) = "Versandzeitpunkt der Einladungsmail (nur für nicht-anonyme Adressaten)"
comment(ds$LASTDATA) = "Zeitpunkt als der Datensatz das letzte mal geändert wurde"
comment(ds$FINISHED) = "Wurde die Befragung abgeschlossen (letzte Seite erreicht)?"
comment(ds$Q_VIEWER) = "Hat der Teilnehmer den Fragebogen nur angesehen, ohne die Pflichtfragen zu beantworten?"
comment(ds$LASTPAGE) = "Seite, die der Teilnehmer zuletzt bearbeitet hat"
comment(ds$MAXPAGE) = "Letzte Seite, die im Fragebogen bearbeitet wurde"
comment(ds$MISSING) = "Anteil fehlender Antworten in Prozent"
comment(ds$MISSREL) = "Anteil fehlender Antworten (gewichtet nach Relevanz)"
comment(ds$TIME_RSI) = "Maluspunkte für schnelles Ausfüllen"
comment(ds$DEG_TIME) = "Maluspunkte für schnelles Ausfüllen"



# Assure that the comments are retained in subsets
as.data.frame.avector = as.data.frame.vector
`[.avector` <- function(x,i,...) {
  r <- NextMethod("[")
  mostattributes(r) <- attributes(x)
  r
}
ds_tmp = data.frame(
  lapply(ds, function(x) {
    structure( x, class = c("avector", class(x) ) )
  } )
)
mostattributes(ds_tmp) = attributes(ds)
ds = ds_tmp
rm(ds_tmp)













############ Calculations #############

table(ds$SD01)
summary(ds$SD19_01)
sd(ds$SD19_01)

variables = ds[13:45]
for (i in variables){
  print(summary(i))}

summary(ds$CO17_01)

##### Long versus Short concept #####

mean(ds$CO19_01, na.rm=TRUE)
mean(ds$CO31_01, na.rm=TRUE)

wilcox.test(x = ds$CO19_01, ds$CO31_01, alternative = "two.sided", paired = FALSE, conf.int = TRUE, 
            exact = FALSE, conf.level = 0.95, na.omit=TRUE)
wilcox.test(x = ds$CO19_02, ds$CO31_02, alternative = "two.sided", paired = FALSE, conf.int = TRUE, 
            exact = FALSE, conf.level = 0.95, na.omit=TRUE)
wilcox.test(x = ds$CO19_03, ds$CO31_03, alternative = "two.sided", paired = FALSE, conf.int = TRUE, 
            exact = FALSE, conf.level = 0.95, na.omit=TRUE)
wilcox.test(x = ds$CO27_01, ds$CO21_01, alternative = "two.sided", paired = FALSE, conf.int = TRUE, 
            exact = FALSE, conf.level = 0.95, na.omit=TRUE)
wilcox.test(x = ds$CO27_02, ds$CO21_02, alternative = "two.sided", paired = FALSE, conf.int = TRUE, 
            exact = FALSE, conf.level = 0.95, na.omit=TRUE)
wilcox.test(x = ds$CO27_03, ds$CO21_03, alternative = "two.sided", paired = FALSE, conf.int = TRUE, 
            exact = FALSE, conf.level = 0.95, na.omit=TRUE)
wilcox.test(x = ds$CO25_01, ds$CO30_01, alternative = "two.sided", paired = FALSE, conf.int = TRUE, 
            exact = FALSE, conf.level = 0.95, na.omit=TRUE)
wilcox.test(x = ds$CO25_02, ds$CO30_02, alternative = "two.sided", paired = FALSE, conf.int = TRUE, 
            exact = FALSE, conf.level = 0.95, na.omit=TRUE)
wilcox.test(x = ds$CO25_03, ds$CO30_03, alternative = "two.sided", paired = FALSE, conf.int = TRUE, 
            exact = FALSE, conf.level = 0.95, na.omit=TRUE)

# Concept versus counterfactual for long concepts

animal_long <- subset(ds, Z101 == 1)
wilcox.test(x = animal_long$CO19_01, animal_long$CO20_01, alternative = "two.sided", paired = TRUE, conf.int = TRUE, 
            exact = FALSE, conf.level = 0.95, na.omit=TRUE)
wilcox.test(x = animal_long$CO19_02, animal_long$CO20_02, alternative = "two.sided", paired = TRUE, conf.int = TRUE, 
            exact = FALSE, conf.level = 0.95, na.omit=TRUE)
wilcox.test(x = animal_long$CO19_03, animal_long$CO20_03, alternative = "two.sided", paired = TRUE, conf.int = TRUE, 
            exact = FALSE, conf.level = 0.95, na.omit=TRUE)

medicine_long <- subset(ds, Z102 == 1)
wilcox.test(x = medicine_long$CO27_01, medicine_long$CO22_01, alternative = "two.sided", paired = TRUE, conf.int = TRUE, 
            exact = FALSE, conf.level = 0.95, na.omit=TRUE)
wilcox.test(x = medicine_long$CO27_02, medicine_long$CO22_02, alternative = "two.sided", paired = TRUE, conf.int = TRUE, 
            exact = FALSE, conf.level = 0.95, na.omit=TRUE)
wilcox.test(x = medicine_long$CO27_03, medicine_long$CO22_03, alternative = "two.sided", paired = TRUE, conf.int = TRUE, 
            exact = FALSE, conf.level = 0.95, na.omit=TRUE)

loan_long <- subset(ds, Z103 == 1)
wilcox.test(x = loan_long$CO25_01, loan_long$CO29_01, alternative = "two.sided", paired = TRUE, conf.int = TRUE, 
            exact = FALSE, conf.level = 0.95, na.omit=TRUE)
wilcox.test(x = loan_long$CO25_02, loan_long$CO29_02, alternative = "two.sided", paired = TRUE, conf.int = TRUE, 
            exact = FALSE, conf.level = 0.95, na.omit=TRUE)
wilcox.test(x = loan_long$CO25_03, loan_long$CO29_03, alternative = "two.sided", paired = TRUE, conf.int = TRUE, 
            exact = FALSE, conf.level = 0.95, na.omit=TRUE)

mean(ds$CO25_02, na.rm=TRUE)
mean(ds$CO29_02, na.rm=TRUE)

# Credit: Long concept is less useful than counterfactual

rFromWilcox<-function(wilcoxModel, N){
  z<- qnorm(wilcoxModel$p.value/2)
  r<- z/ sqrt(N)
  cat(wilcoxModel$data.name, 'Effect Size, r = ', r, 'z =', z)}

wilmodel <- wilcox.test(loan_long$CO25_02, y = loan_long$CO29_02,
                          paired = TRUE, exact = FALSE,
                          conf.int = TRUE, conf.level = 0.95)
rFromWilcox(wilmodel, 96)



##### Concept versus counterfactual for short concepts #####

mean(ds$CO31_01, na.rm=TRUE)
mean(ds$CO20_01, na.rm=TRUE)

animal_short <- subset(ds, Z101 == 2)
wilcox.test(x = animal_short$CO31_01, animal_short$CO20_01, alternative = "two.sided", paired = TRUE, conf.int = TRUE, 
            exact = FALSE, conf.level = 0.95, na.omit=TRUE)
wilcox.test(x = animal_short$CO31_02, animal_short$CO20_02, alternative = "two.sided", paired = TRUE, conf.int = TRUE, 
            exact = FALSE, conf.level = 0.95, na.omit=TRUE)
wilcox.test(x = animal_short$CO31_03, animal_short$CO20_03, alternative = "two.sided", paired = TRUE, conf.int = TRUE, 
            exact = FALSE, conf.level = 0.95, na.omit=TRUE)

medicine_short <- subset(ds, Z102 == 2)
wilcox.test(x = medicine_short$CO21_01, medicine_short$CO22_01, alternative = "two.sided", paired = TRUE, conf.int = TRUE, 
            exact = FALSE, conf.level = 0.95, na.omit=TRUE)
wilcox.test(x = medicine_short$CO21_02, medicine_short$CO22_02, alternative = "two.sided", paired = TRUE, conf.int = TRUE, 
            exact = FALSE, conf.level = 0.95, na.omit=TRUE)
wilcox.test(x = medicine_short$CO21_03, medicine_short$CO22_03, alternative = "two.sided", paired = TRUE, conf.int = TRUE, 
            exact = FALSE, conf.level = 0.95, na.omit=TRUE)

loan_short <- subset(ds, Z103 == 2)
wilcox.test(x = loan_short$CO30_01, loan_short$CO29_01, alternative = "two.sided", paired = TRUE, conf.int = TRUE, 
            exact = FALSE, conf.level = 0.95, na.omit=TRUE)
wilcox.test(x = loan_short$CO30_02, loan_short$CO29_02, alternative = "two.sided", paired = TRUE, conf.int = TRUE, 
            exact = FALSE, conf.level = 0.95, na.omit=TRUE)
wilcox.test(x = loan_short$CO30_03, loan_short$CO29_03, alternative = "two.sided", paired = TRUE, conf.int = TRUE, 
            exact = FALSE, conf.level = 0.95, na.omit=TRUE)



##### Differences in counterfactual rating over scenarios #####

understanding_CF <- gather(ds, t, v, CO18_01, CO20_01, CO22_01, CO29_01)
friedmanmc(understanding_CF$v, understanding_CF$t, understanding_CF$STARTED)
boxplot(understanding_CF$v~understanding_CF$t)

usefulness_CF <- gather(ds, t, v, CO18_02, CO20_02, CO22_02, CO29_02)
friedmanmc(usefulness_CF$v, usefulness_CF$t, usefulness_CF$STARTED)
boxplot(usefulness_CF$v~usefulness_CF$t)

friedman.test(usefulness_CF$v, usefulness_CF$t, usefulness_CF$STARTED)

mean(ds$CO18_02, na.rm=TRUE)
mean(ds$CO20_02, na.rm=TRUE)
mean(ds$CO22_02, na.rm=TRUE)
mean(ds$CO29_02, na.rm=TRUE)
# For Animals and Medicine, counterfactuals were rated worse than Loan

control_CF <- gather(ds, t, v, CO18_03, CO20_03, CO22_03, CO29_03)
friedmanmc(control_CF$v, control_CF$t, control_CF$STARTED)
boxplot(control_CF$v~control_CF$t)



##### Differences in concept rating over scenarios #####

animal_short <- subset(ds, Z101 == 2)
overall_concepts <- ds
  
overall_concepts$CO19_01[is.na(overall_concepts$CO19_01)] = 0
overall_concepts$CO19_02[is.na(overall_concepts$CO19_02)] = 0
overall_concepts$CO19_03[is.na(overall_concepts$CO19_03)] = 0
overall_concepts$CO27_01[is.na(overall_concepts$CO27_01)] = 0
overall_concepts$CO27_02[is.na(overall_concepts$CO27_02)] = 0
overall_concepts$CO27_03[is.na(overall_concepts$CO27_03)] = 0
overall_concepts$CO25_01[is.na(overall_concepts$CO25_01)] = 0
overall_concepts$CO25_02[is.na(overall_concepts$CO25_02)] = 0
overall_concepts$CO25_03[is.na(overall_concepts$CO25_03)] = 0
overall_concepts$CO31_01[is.na(overall_concepts$CO31_01)] = 0
overall_concepts$CO31_02[is.na(overall_concepts$CO31_02)] = 0
overall_concepts$CO31_03[is.na(overall_concepts$CO31_03)] = 0
overall_concepts$CO21_01[is.na(overall_concepts$CO21_01)] = 0
overall_concepts$CO21_02[is.na(overall_concepts$CO21_02)] = 0
overall_concepts$CO21_03[is.na(overall_concepts$CO21_03)] = 0
overall_concepts$CO30_01[is.na(overall_concepts$CO30_01)] = 0
overall_concepts$CO30_02[is.na(overall_concepts$CO30_02)] = 0
overall_concepts$CO30_03[is.na(overall_concepts$CO30_03)] = 0

overall_concepts$animals01 <- overall_concepts$CO19_01 + overall_concepts$CO31_01
overall_concepts$animals02 <- overall_concepts$CO19_02 + overall_concepts$CO31_02
overall_concepts$animals03 <- overall_concepts$CO19_03 + overall_concepts$CO31_03
overall_concepts$medicine01 <- overall_concepts$CO27_01 + overall_concepts$CO21_01
overall_concepts$medicine02 <- overall_concepts$CO27_02 + overall_concepts$CO21_02
overall_concepts$medicine03 <- overall_concepts$CO27_03 + overall_concepts$CO21_03
overall_concepts$loan01 <- overall_concepts$CO25_01 + overall_concepts$CO30_01
overall_concepts$loan02 <- overall_concepts$CO25_02 + overall_concepts$CO30_02
overall_concepts$loan03 <- overall_concepts$CO25_03 + overall_concepts$CO30_03

understanding_CO <- gather(overall_concepts, t, v, CO17_01, animals01, medicine01, loan01)
friedmanmc(understanding_CO$v, understanding_CO$t, understanding_CO$STARTED)
boxplot(understanding_CO$v~understanding_CO$t)

usefulness_CO <- gather(overall_concepts, t, v, CO17_02, animals02, medicine02, loan02)
friedmanmc(usefulness_CO$v, usefulness_CO$t, usefulness_CO$STARTED)
boxplot(usefulness_CO$v~usefulness_CO$t)

control_CO <- gather(overall_concepts, t, v, CO17_03, animals03, medicine03, loan03)
friedmanmc(control_CO$v, control_CO$t, control_CO$STARTED)
boxplot(control_CO$v~control_CO$t)

#nothing