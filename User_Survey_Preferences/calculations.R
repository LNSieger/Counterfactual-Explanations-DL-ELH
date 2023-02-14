install.packages("rcompanion")
install.packages("tidyr")
install.packages("pgirmess")

library(rcompanion)
library(tidyr)
library(pgirmess)

############ Read data #############.

setwd(" ")                                    ###set directory of the file data_survey_anonymized.csv
ds_file = "data_survey_anonymized.csv"

ds = read.table(
  file=ds_file, encoding="UTF-8",
  header = FALSE, sep = "\t", quote = "\"",
  dec = ".", row.names = "CASE",
  col.names = c(
    "CASE","SERIAL","REF","QUESTNNR","MODE","STARTED","SD01","SD15_01","SD15_01a",
    "SD19_01","SD20_01","ST01","ST01_01","CO02_01","CO02_02","CO06_01","CO06_02",
    "CO06_03","CO07_01","CO07_02","CO07_03","CO07_04","CO07_05","CO05_01","CO05_02",
    "CO05_03","CO05_04","CO05_05","CO08_01","CO08_02","CO08_03","CO09_01","CO09_02",
    "CO09_03","CO10_01","CO17_01","CO11_01","CO18_01","CO12_01","CO19_01","CO13_01",
    "CO20_01","CO14_01","CO21_01","CO15_01","CO22_01","Z101_CP","Z101","Z104_CP",
    "Z104x01","Z104x02","Z104x03","Z104x04","Z104x05","Z104x06","Z105_CP","Z105x01",
    "Z105x02","Z105x03","Z105x04","Z105x05","Z105x06","TIME002","TIME003","TIME004",
    "TIME005","TIME006","TIME007","TIME008","TIME009","TIME010","TIME011","TIME012",
    "TIME013","TIME014","TIME015","TIME016","TIME017","TIME018","TIME019",
    "TIME_SUM","MAILSENT","LASTDATA","FINISHED","Q_VIEWER","LASTPAGE","MAXPAGE",
    "MISSING","MISSREL","TIME_RSI","DEG_TIME"
  ),
  as.is = TRUE,
  colClasses = c(
    CASE="numeric", SERIAL="character", REF="character", QUESTNNR="character",
    MODE="factor", STARTED="POSIXct", SD01="numeric", SD15_01="character",
    SD15_01a="logical", SD19_01="numeric", SD20_01="character", ST01="numeric",
    ST01_01="logical", CO02_01="numeric", CO02_02="numeric", CO06_01="numeric",
    CO06_02="numeric", CO06_03="numeric", CO07_01="numeric", CO07_02="numeric",
    CO07_03="numeric", CO07_04="numeric", CO07_05="numeric", CO05_01="numeric",
    CO05_02="numeric", CO05_03="numeric", CO05_04="numeric", CO05_05="numeric",
    CO08_01="numeric", CO08_02="numeric", CO08_03="numeric", CO09_01="numeric",
    CO09_02="numeric", CO09_03="numeric", CO10_01="numeric", CO17_01="numeric",
    CO11_01="numeric", CO18_01="numeric", CO12_01="numeric", CO19_01="numeric",
    CO13_01="numeric", CO20_01="numeric", CO14_01="numeric", CO21_01="numeric",
    CO15_01="numeric", CO22_01="numeric", Z101_CP="numeric", Z101="numeric",
    Z104_CP="numeric", Z104x01="numeric", Z104x02="numeric", Z104x03="numeric",
    Z104x04="numeric", Z104x05="numeric", Z104x06="numeric", Z105_CP="numeric",
    Z105x01="numeric", Z105x02="numeric", Z105x03="numeric", Z105x04="numeric",
    Z105x05="numeric", Z105x06="numeric", TIME002="integer", TIME003="integer",
    TIME004="integer", TIME005="integer", TIME006="integer", TIME007="integer",
    TIME008="integer", TIME009="integer", TIME010="integer", TIME011="integer",
    TIME012="integer", TIME013="integer", TIME014="integer", TIME015="integer",
    TIME016="integer", TIME017="integer", TIME018="integer", TIME019="integer",
    TIME_SUM="integer", MAILSENT="POSIXct", LASTDATA="POSIXct",
    FINISHED="logical", Q_VIEWER="logical", LASTPAGE="numeric",
    MAXPAGE="numeric", MISSING="numeric", MISSREL="numeric", TIME_RSI="numeric",
    DEG_TIME="numeric"
  ),
  skip = 1,
  check.names = TRUE, fill = TRUE,
  strip.white = FALSE, blank.lines.skip = TRUE,
  comment.char = "",
  na.strings = ""
)

rm(ds_file)

attr(ds, "project") = "KI-Erklaerungen"
attr(ds, "description") = "Counterfactuals"
attr(ds, "date") = "2022-05-03 16:32:43"
attr(ds, "server") = "https://www.soscisurvey.de"

# Variable und Value Labels
ds$CASE = row.names(ds)
ds$SD01 = factor(ds$SD01, levels=c("1","2","3","-9"), labels=c("weiblich","männlich","divers","[NA] nicht beantwortet"), ordered=FALSE)
attr(ds$SD15_01a,"F") = "nicht gewählt"
attr(ds$SD15_01a,"T") = "ausgewählt"
attr(ds$ST01_01,"F") = "nicht gewählt"
attr(ds$ST01_01,"T") = "ausgewählt"
attr(ds$CO02_01,"1") = "Hilft mir gar nicht"
attr(ds$CO02_01,"7") = "Hilft mir sehr"
attr(ds$CO02_02,"1") = "Hilft mir gar nicht"
attr(ds$CO02_02,"7") = "Hilft mir sehr"
attr(ds$CO06_01,"1") = "Hilft mir gar nicht"
attr(ds$CO06_01,"7") = "Hilft mir sehr"
attr(ds$CO06_02,"1") = "Hilft mir gar nicht"
attr(ds$CO06_02,"7") = "Hilft mir sehr"
attr(ds$CO06_03,"1") = "Hilft mir gar nicht"
attr(ds$CO06_03,"7") = "Hilft mir sehr"
attr(ds$CO07_01,"1") = "Hilft mir gar nicht"
attr(ds$CO07_01,"7") = "Hilft mir sehr"
attr(ds$CO07_02,"1") = "Hilft mir gar nicht"
attr(ds$CO07_02,"7") = "Hilft mir sehr"
attr(ds$CO07_03,"1") = "Hilft mir gar nicht"
attr(ds$CO07_03,"7") = "Hilft mir sehr"
attr(ds$CO07_04,"1") = "Hilft mir gar nicht"
attr(ds$CO07_04,"7") = "Hilft mir sehr"
attr(ds$CO07_05,"1") = "Hilft mir gar nicht"
attr(ds$CO07_05,"7") = "Hilft mir sehr"
attr(ds$CO05_01,"1") = "Hilft mir gar nicht"
attr(ds$CO05_01,"7") = "Hilft mir sehr"
attr(ds$CO05_02,"1") = "Hilft mir gar nicht"
attr(ds$CO05_02,"7") = "Hilft mir sehr"
attr(ds$CO05_03,"1") = "Hilft mir gar nicht"
attr(ds$CO05_03,"7") = "Hilft mir sehr"
attr(ds$CO05_04,"1") = "Hilft mir gar nicht"
attr(ds$CO05_04,"7") = "Hilft mir sehr"
attr(ds$CO05_05,"1") = "Hilft mir gar nicht"
attr(ds$CO05_05,"7") = "Hilft mir sehr"
attr(ds$CO08_01,"1") = "Hilft mir gar nicht"
attr(ds$CO08_01,"7") = "Hilft mir sehr"
attr(ds$CO08_02,"1") = "Hilft mir gar nicht"
attr(ds$CO08_02,"7") = "Hilft mir sehr"
attr(ds$CO08_03,"1") = "Hilft mir gar nicht"
attr(ds$CO08_03,"7") = "Hilft mir sehr"
attr(ds$CO09_01,"1") = "Hilft mir gar nicht"
attr(ds$CO09_01,"7") = "Hilft mir sehr"
attr(ds$CO09_02,"1") = "Hilft mir gar nicht"
attr(ds$CO09_02,"7") = "Hilft mir sehr"
attr(ds$CO09_03,"1") = "Hilft mir gar nicht"
attr(ds$CO09_03,"7") = "Hilft mir sehr"
attr(ds$CO10_01,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO10_01,"7") = "Stimme voll und ganz zu"
attr(ds$CO17_01,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO17_01,"7") = "Stimme voll und ganz zu"
attr(ds$CO11_01,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO11_01,"7") = "Stimme voll und ganz zu"
attr(ds$CO18_01,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO18_01,"7") = "Stimme voll und ganz zu"
attr(ds$CO12_01,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO12_01,"7") = "Stimme voll und ganz zu"
attr(ds$CO19_01,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO19_01,"7") = "Stimme voll und ganz zu"
attr(ds$CO13_01,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO13_01,"7") = "Stimme voll und ganz zu"
attr(ds$CO20_01,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO20_01,"7") = "Stimme voll und ganz zu"
attr(ds$CO14_01,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO14_01,"7") = "Stimme voll und ganz zu"
attr(ds$CO21_01,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO21_01,"7") = "Stimme voll und ganz zu"
attr(ds$CO15_01,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO15_01,"7") = "Stimme voll und ganz zu"
attr(ds$CO22_01,"1") = "Stimme überhaupt nicht zu"
attr(ds$CO22_01,"7") = "Stimme voll und ganz zu"
attr(ds$Z101,"1") = "1"
attr(ds$Z101,"2") = "2"
attr(ds$Z104x01,"1") = "A1"
attr(ds$Z104x01,"2") = "A2"
attr(ds$Z104x01,"3") = "A3"
attr(ds$Z104x01,"4") = "A4"
attr(ds$Z104x01,"5") = "A5"
attr(ds$Z104x01,"6") = "A6"
attr(ds$Z104x02,"1") = "A1"
attr(ds$Z104x02,"2") = "A2"
attr(ds$Z104x02,"3") = "A3"
attr(ds$Z104x02,"4") = "A4"
attr(ds$Z104x02,"5") = "A5"
attr(ds$Z104x02,"6") = "A6"
attr(ds$Z104x03,"1") = "A1"
attr(ds$Z104x03,"2") = "A2"
attr(ds$Z104x03,"3") = "A3"
attr(ds$Z104x03,"4") = "A4"
attr(ds$Z104x03,"5") = "A5"
attr(ds$Z104x03,"6") = "A6"
attr(ds$Z104x04,"1") = "A1"
attr(ds$Z104x04,"2") = "A2"
attr(ds$Z104x04,"3") = "A3"
attr(ds$Z104x04,"4") = "A4"
attr(ds$Z104x04,"5") = "A5"
attr(ds$Z104x04,"6") = "A6"
attr(ds$Z104x05,"1") = "A1"
attr(ds$Z104x05,"2") = "A2"
attr(ds$Z104x05,"3") = "A3"
attr(ds$Z104x05,"4") = "A4"
attr(ds$Z104x05,"5") = "A5"
attr(ds$Z104x05,"6") = "A6"
attr(ds$Z104x06,"1") = "A1"
attr(ds$Z104x06,"2") = "A2"
attr(ds$Z104x06,"3") = "A3"
attr(ds$Z104x06,"4") = "A4"
attr(ds$Z104x06,"5") = "A5"
attr(ds$Z104x06,"6") = "A6"
attr(ds$Z105x01,"1") = "F1"
attr(ds$Z105x01,"2") = "F2"
attr(ds$Z105x01,"3") = "F3"
attr(ds$Z105x01,"4") = "F4"
attr(ds$Z105x01,"5") = "F5"
attr(ds$Z105x01,"6") = "F6"
attr(ds$Z105x02,"1") = "F1"
attr(ds$Z105x02,"2") = "F2"
attr(ds$Z105x02,"3") = "F3"
attr(ds$Z105x02,"4") = "F4"
attr(ds$Z105x02,"5") = "F5"
attr(ds$Z105x02,"6") = "F6"
attr(ds$Z105x03,"1") = "F1"
attr(ds$Z105x03,"2") = "F2"
attr(ds$Z105x03,"3") = "F3"
attr(ds$Z105x03,"4") = "F4"
attr(ds$Z105x03,"5") = "F5"
attr(ds$Z105x03,"6") = "F6"
attr(ds$Z105x04,"1") = "F1"
attr(ds$Z105x04,"2") = "F2"
attr(ds$Z105x04,"3") = "F3"
attr(ds$Z105x04,"4") = "F4"
attr(ds$Z105x04,"5") = "F5"
attr(ds$Z105x04,"6") = "F6"
attr(ds$Z105x05,"1") = "F1"
attr(ds$Z105x05,"2") = "F2"
attr(ds$Z105x05,"3") = "F3"
attr(ds$Z105x05,"4") = "F4"
attr(ds$Z105x05,"5") = "F5"
attr(ds$Z105x05,"6") = "F6"
attr(ds$Z105x06,"1") = "F1"
attr(ds$Z105x06,"2") = "F2"
attr(ds$Z105x06,"3") = "F3"
attr(ds$Z105x06,"4") = "F4"
attr(ds$Z105x06,"5") = "F5"
attr(ds$Z105x06,"6") = "F6"
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
comment(ds$CO02_01) = "Frage Girl: \"Ich hätte dieses Lebewesen nicht als Mensch klassifiziert, wenn es keine Beine hätte.\""
comment(ds$CO02_02) = "Frage Girl: \"Ich hätte dieses Lebewesen nicht als Mensch klassifiziert, wenn es nicht einer Wohnung leben würde.\""
comment(ds$CO06_01) = "Frage Snake: \"Ich hätte dieses Lebewesen nicht als Schlange klassifiziert, wenn es keine Eier legen würde.\""
comment(ds$CO06_02) = "Frage Snake: \"Ich hätte dieses Lebewesen nicht als Schlange klassifiziert, wenn es nicht an Land leben würde.\""
comment(ds$CO06_03) = "Frage Snake: \"Ich hätte dieses Lebewesen nicht als Schlange klassifiziert, wenn es keine Schuppen hätte.\""
comment(ds$CO07_01) = "Frage Penguin: \"Ich hätte dieses Lebewesen nicht als Pinguin klassifiziert, wenn es keine Eier legen würde.\""
comment(ds$CO07_02) = "Frage Penguin: \"Ich hätte dieses Lebewesen nicht als Pinguin klassifiziert, wenn es nicht gleichwarm wäre.\""
comment(ds$CO07_03) = "Frage Penguin: \"Ich hätte dieses Lebewesen nicht als Pinguin klassifiziert, wenn es keine Beine hätte.\""
comment(ds$CO07_04) = "Frage Penguin: \"Ich hätte dieses Lebewesen nicht als Pinguin klassifiziert, wenn es nicht im Wasser leben würde.\""
comment(ds$CO07_05) = "Frage Penguin: \"Ich hätte dieses Lebewesen nicht als Pinguin klassifiziert, wenn es keine Federn hätte.\""
comment(ds$CO05_01) = "Frage Eagle: \"Ich hätte dieses Lebewesen nicht als Adler klassifiziert, wenn es keine Eier legen würde.\""
comment(ds$CO05_02) = "Frage Eagle: \"Ich hätte dieses Lebewesen nicht als Adler klassifiziert, wenn es nicht gleichwarm wäre.\""
comment(ds$CO05_03) = "Frage Eagle: \"Ich hätte dieses Lebewesen nicht als Adler klassifiziert, wenn es keine Beine hätte.\""
comment(ds$CO05_04) = "Frage Eagle: \"Ich hätte dieses Lebewesen nicht als Adler klassifiziert, wenn es nicht in der Luft leben würde.\""
comment(ds$CO05_05) = "Frage Eagle: \"Ich hätte dieses Lebewesen nicht als Adler klassifiziert, wenn es keine Federn hätte.\""
comment(ds$CO08_01) = "Frage Turtle: \"Ich hätte dieses Lebewesen nicht als Wasserschildkröte klassifiziert, wenn es keine Eier legen würde.\""
comment(ds$CO08_02) = "Frage Turtle: \"Ich hätte dieses Lebewesen nicht als Wasserschildkröte klassifiziert, wenn es keine Beine hätte.\""
comment(ds$CO08_03) = "Frage Turtle: \"Ich hätte dieses Lebewesen nicht als Wasserschildkröte klassifiziert, wenn es keine Schuppen hätte.\""
comment(ds$CO09_01) = "Frage Croco: \"Ich hätte dieses Lebewesen nicht als Krokodil klassifiziert, wenn es keine Eier legen würde.\""
comment(ds$CO09_02) = "Frage Croco: \"Ich hätte dieses Lebewesen nicht als Krokodil klassifiziert, wenn es keine Beine hätte.\""
comment(ds$CO09_03) = "Frage Croco: \"Ich hätte dieses Lebewesen nicht als Krokodil klassifiziert , wenn es keine Schuppen hätte.\""
comment(ds$CO10_01) = "Frage_M_g: Die Erklärung hilft mir, die Entscheidung des Programms besser zu verstehen."
comment(ds$CO17_01) = "Frage_M_hC: Die Erklärung hilft mir, die Entscheidung des Programms besser zu verstehen."
comment(ds$CO11_01) = "Frage_F_g: Die Erklärung hilft mir, die Entscheidung des Programms besser zu verstehen."
comment(ds$CO18_01) = "Frage_F_hC: Die Erklärung hilft mir, die Entscheidung des Programms besser zu verstehen."
comment(ds$CO12_01) = "Frage_B_g: Die Erklärung hilft mir, die Entscheidung des Programms besser zu verstehen."
comment(ds$CO19_01) = "Frage_B_hS: Die Erklärung hilft mir, die Entscheidung des Programms besser zu verstehen."
comment(ds$CO13_01) = "Frage_S_g: Die Erklärung hilft mir, die Entscheidung des Programms besser zu verstehen."
comment(ds$CO20_01) = "Frage_S_hS: Die Erklärung hilft mir, die Entscheidung des Programms besser zu verstehen."
comment(ds$CO14_01) = "Frage_GF_g: Die Erklärung hilft mir, die Entscheidung des Programms besser zu verstehen."
comment(ds$CO21_01) = "Frage_GF_hC: Die Erklärung hilft mir, die Entscheidung des Programms besser zu verstehen."
comment(ds$CO15_01) = "Frage_GM_g: Die Erklärung hilft mir, die Entscheidung des Programms besser zu verstehen."
comment(ds$CO22_01) = "Frage_GM_hC: Die Erklärung hilft mir, die Entscheidung des Programms besser zu verstehen."
comment(ds$Z101_CP) = "Z2: Vollständige Leerungen der Urne bisher"
comment(ds$Z101) = "Z2: Gezogener Code"
comment(ds$Z104_CP) = "Z6: Vollständige Leerungen der Urne bisher"
comment(ds$Z104x01) = "Z6: Gezogener Code (1)"
comment(ds$Z104x02) = "Z6: Gezogener Code (2)"
comment(ds$Z104x03) = "Z6: Gezogener Code (3)"
comment(ds$Z104x04) = "Z6: Gezogener Code (4)"
comment(ds$Z104x05) = "Z6: Gezogener Code (5)"
comment(ds$Z104x06) = "Z6: Gezogener Code (6)"
comment(ds$Z105_CP) = "Z6f: Vollständige Leerungen der Urne bisher"
comment(ds$Z105x01) = "Z6f: Gezogener Code (1)"
comment(ds$Z105x02) = "Z6f: Gezogener Code (2)"
comment(ds$Z105x03) = "Z6f: Gezogener Code (3)"
comment(ds$Z105x04) = "Z6f: Gezogener Code (4)"
comment(ds$Z105x05) = "Z6f: Gezogener Code (5)"
comment(ds$Z105x06) = "Z6f: Gezogener Code (6)"
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
comment(ds$TIME014) = "Verweildauer Seite 14"
comment(ds$TIME015) = "Verweildauer Seite 15"
comment(ds$TIME016) = "Verweildauer Seite 16"
comment(ds$TIME017) = "Verweildauer Seite 17"
comment(ds$TIME018) = "Verweildauer Seite 18"
comment(ds$TIME019) = "Verweildauer Seite 19"
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


table(ds$SD20_01)

summary(ds$SD19_01)
sd(ds$SD19_01)
summary(ds$SD01)
table(ds$SD15_01)
table(ds$SD15_01a)

### Family

FamilyList_N39 <- list(ds$CO10_01, ds$CO18_01, ds$CO19_01, ds$CO13_01, ds$CO14_01, ds$CO22_01)
FamilyList_N33 <- list(ds$CO17_01, ds$CO11_01, ds$CO12_01, ds$CO20_01, ds$CO21_01, ds$CO15_01)

#(Two lists because n slightly differs from randomization)

FamilyList_N39_names <- list("ds$CO10_01", "ds$CO18_01", "ds$CO19_01", "ds$CO13_01", "ds$CO14_01", "ds$CO22_01")
FamilyList_N33_names <- list("ds$CO17_01", "ds$CO11_01", "ds$CO12_01", "ds$CO20_01", "ds$CO21_01", "ds$CO15_01")

# Deviation from center

rFromWilcox<-function(wilcoxModel, N){
  z<- qnorm(wilcoxModel$p.value/2)
  r<- z/ sqrt(N)
  cat(wilcoxModel$data.name, 'Effect Size, r = ', r, 'z =', z)}

ind = 1
for(i in FamilyList_N39) {
  print(paste("Question", FamilyList_N39_names[ind]))
  wilcox.test(i, mu = 4, alternative = "two.sided",
              conf.int = TRUE, conf.level = 0.95)
  wilmodel <- wilcox.test(i, mu = 4, alternative = "two.sided",
                          conf.int = TRUE, conf.level = 0.95)
  print(wilmodel)
  rFromWilcox(wilmodel, 39)
  ind <- ind+1;
  cat("\n", "\n")
}
summary(ds$CO17_01)
summary(ds$CO18_01)

for(i in FamilyList_N39) {
  print(summary(i))}

#sig: 
# CO18_01, <.001, r =  -0.8117968 z = -5.069669
# Father hasChild
# CO19_01, <.001, r =  -0.782292 z = -4.885412
# Brother hasSibling
# CO22_01, <.001, r =  -0.7809491 z = -4.877026
# Grandmother hasChild

ind = 1
for(i in FamilyList_N33) {
  print(paste("Question", FamilyList_N33_names[ind]))
  wilcox.test(i, mu = 4, alternative = "two.sided",
              conf.int = TRUE, conf.level = 0.95)
  wilmodel <- wilcox.test(i, mu = 4, alternative = "two.sided",
                          conf.int = TRUE, conf.level = 0.95)
  print(wilmodel)
  rFromWilcox(wilmodel, 33)
  ind <- ind+1;
  cat("\n", "\n")
}

for(i in FamilyList_N33) {
  print(summary(i))}

#sig:
# CO17_01, <.001, r =  -0.8415885 z = -4.834558
# Mother hasChild
# CO20_01, <.001, r =  -0.7146806 z = -4.105527
# Sister hasChild
# CO21_01, <.001, r =  -0.7850345 z = -4.50968
# Grandfather hasChild



### Counterfactuals prefered by algorithm ###
install.packages("rstatix")
library(rstatix)

Family_Mother.long <- ds %>%
  gather(key = "Group", value = "Rating", CO10_01, CO17_01)

wilcox_test(Family_Mother.long, formula = Rating ~ Group, p.adjust.method = "bonferroni", paired = TRUE, conf.level = 0.95, detailed = TRUE)

### Participant ratings ###

#CO10_01 #Frage_M_g
#CO17_01 #Frage_M_hC

wilcox.test(ds$CO10_01, y = ds$CO17_01,
            paired = FALSE, exact = FALSE,
            conf.int = TRUE, conf.level = 0.95)
#p<.001

#CO11_01 #Frage_F_g
#CO18_01 #Frage_F_hC

wilcox.test(ds$CO11_01, y = ds$CO18_01,
            paired = FALSE, exact = FALSE,
            conf.int = TRUE, conf.level = 0.95)
#p<.001

#CO12_01 #Frage_B_g
#CO19_01 #Frage_B_hS

wilcox.test(ds$CO12_01, y = ds$CO19_01,
            paired = FALSE, exact = FALSE,
            conf.int = TRUE, conf.level = 0.95)
#p<.001

#CO13_01 #Frage_S_g
#CO20_01 #Frage_S_hS

wilcox.test(ds$CO13_01, y = ds$CO20_01,
            paired = FALSE, exact = FALSE,
            conf.int = TRUE, conf.level = 0.95)
#p<.01

#CO14_01 #Frage_GF_g
#CO21_01 #Frage_GF_hC

wilcox.test(ds$CO14_01, y = ds$CO21_01,
            paired = FALSE, exact = FALSE,
            conf.int = TRUE, conf.level = 0.95)
#p<.001

#CO15_01 #Frage_GM_g
#CO22_01 #Frage_GM_hC

wilcox.test(ds$CO15_01, y = ds$CO22_01,
            paired = FALSE, exact = FALSE,
            conf.int = TRUE, conf.level = 0.95)
#p<.001


### Animals ###

# Deviation from center

AnimalList <- list(ds$CO02_01, ds$CO02_02, ds$CO06_01, ds$CO06_02, ds$CO06_03, ds$CO07_01, ds$CO07_02, ds$CO07_03, 
                   ds$CO07_04, ds$CO07_05, ds$CO05_01, ds$CO05_02, ds$CO05_03, ds$CO05_04, ds$CO05_05, 
                   ds$CO08_01, ds$CO08_02, ds$CO08_03, ds$CO09_01, ds$CO09_02, ds$CO09_03)

VarNamesA <- list("girl1", "girl2", "snake1", "snake2", "snake3", "penguin1", "penguin2", "penguin3", "penguin4", 
                  "penguin5", "eagle1", "eagle2", "eagle3", "eagle4", "eagle5", "turtle1", "turtle2", "turtle3",
                  "croco1", "croco2", "croco3")

# Deviation from center

ind = 1
for(i in AnimalList) {
  print(paste("Question", VarNamesA[ind]))
  wilcox.test(i, mu = 4, exact = FALSE, alternative = "greater",
              conf.int = TRUE, conf.level = 0.95)
  wilmodelA <- wilcox.test(i, mu = 4, exact = FALSE, alternative = "greater",
                          conf.int = TRUE, conf.level = 0.95)
  print(wilmodelA)
  rFromWilcox(wilmodelA, 72)
  ind <- ind+1;
  cat("\n", "\n")
}

for(i in AnimalList) {
  print(mean(i))
}

### Comparisons ###
# ("Girl" computed with wilcox because there are two items, others with friedmann because >3 items)


wilcox.test(ds$CO02_01, y = ds$CO02_02,
            paired = TRUE, exact = FALSE,
            conf.int = TRUE, conf.level = 0.95)
wilmodel_g <- wilcox.test(ds$CO02_01, y = ds$CO02_02,
                         paired = TRUE, exact = FALSE,
                         conf.int = TRUE, conf.level = 0.95)
rFromWilcox(wilmodel_g, 72)

#Snake
snake <- gather(ds, t, v, CO06_01:CO06_03)
friedmanmc(snake$v, snake$t, snake$CASE)
# CO06_01-CO06_02    38.5     28.72776       TRUE
# CO06_02-CO06_03    63.5     28.72776       TRUE

#penguin
penguin <- gather(ds, t, v, CO07_01:CO07_05)
friedmanmc(penguin$v, penguin$t, penguin$CASE)
# CO07_01-CO07_02    55.0     53.25972       TRUE

#eagle
eagle <- gather(ds, t, v, CO05_01:CO05_05)
friedmanmc(eagle$v, eagle$t, eagle$CASE)
#CO05_01-CO05_02    65.5     53.25972       TRUE
#CO05_01-CO05_03    60.0     53.25972       TRUE
#CO05_02-CO05_04    89.5     53.25972       TRUE
#CO05_02-CO05_05   114.5     53.25972       TRUE
#CO05_03-CO05_04    84.0     53.25972       TRUE
#CO05_03-CO05_05   109.0     53.25972       TRUE


#turtle
turtle <- gather(ds, t, v, CO08_01:CO08_03)
friedmanmc(turtle$v, turtle$t, turtle$CASE)
# CO08_01-CO08_03    41.5     28.72776       TRUE

#croco
croco <- gather(ds, t, v, CO09_01:CO09_03)
friedmanmc(croco$v, croco$t, croco$CASE)
#nothing





