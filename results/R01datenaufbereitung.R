################################################################################
##                          00 datenaufbereitung                              ##
################################################################################
#  History
#  2014-12-23 mg  $blockBeschreibung_harmonized $keyValue_harmonized done
#  2014-12-14 mg  new positions colums
#  2014-12-09 mg  some changes
#  2014-11-25 mg  first commited version
################################################################################
#  TODO
#  [ ] Automatisches auswerfen der Plots
#  [X] stimulus codierung zerlegen und Factoren draus machen :)
#  [X] eckig_rund und rund_eckig zusammenführen $blockBeschreibung_harmonized $keyValue_harmonized
#  [ ] einfügen der bonus information durch die kurztests
#  [X] andre csv ignorieren (das war easy)
################################################################################

# Workspace leeren
rm(list = ls())


# pfad setzen optional wenn das rskript mit doppelkilck ausgeführt wurde 
#setwd("~/git/the-shapening/results/")


# pakete installieren ##########################################################

# install.packages("stringr")

# pakete laden #################################################################

library(stringr)


# daten kurztest ###############################################################

pretests = read.csv("TEST data.csv")

# get list of all csv files ####################################################
# http://stackoverflow.com/questions/11433432/importing-multiple-csv-files-into-r
# Dateiname aufbau: 'vpNummer _ vpCode _output.csv'
csvlist = list.files(pattern="*_output.csv")

# bob initieren
bob = rbind (read.csv(csvlist[1]))

# loop alle dateien einlesen und in ein file klatschen 
howmanycsv=length(csvlist)
for (i in 2:howmanycsv) {
  bob = rbind (bob , read.csv(csvlist[i]))
}

# merge pretests to maindata ###################################################
vpn = unique(pretests$vpNummer)
for (i in vpn) {
  bob$vpNummer_pre  [bob$vpNummer==i] <-              pretests$vpNummer      [pretests$vpNummer==i]
  bob$vpCode_pre    [bob$vpNummer==i] <- as.character(pretests$vpCode        [pretests$vpNummer==i])
  bob$vpGeburt_pre  [bob$vpNummer==i] <-              pretests$vpGeburt      [pretests$vpNummer==i]
  bob$vpSex_pre     [bob$vpNummer==i] <- as.character(pretests$vpSex         [pretests$vpNummer==i])
  bob$vpAlter_pre   [bob$vpNummer==i] <-              pretests$vpAlter       [pretests$vpNummer==i]
  bob$vpSehschaerfe [bob$vpNummer==i] <-              pretests$vpSehschaerfe [pretests$vpNummer==i]
  bob$vpFarbsehen   [bob$vpNummer==i] <- as.character(pretests$vpFarbsehen   [pretests$vpNummer==i])
  bob$vpAuegigkeit  [bob$vpNummer==i] <- as.character(pretests$vpAuegigkeit  [pretests$vpNummer==i])
  bob$vpHaendigkeit [bob$vpNummer==i] <- as.character(pretests$vpHaendigkeit [pretests$vpNummer==i])
}

bob$vpCode_pre    <- as.factor(bob$vpCode_pre   )
bob$vpSex_pre     <- as.factor(bob$vpSex_pre    )
bob$vpFarbsehen   <- as.factor(bob$vpFarbsehen  )
bob$vpAuegigkeit  <- as.factor(bob$vpAuegigkeit )
bob$vpHaendigkeit <- as.factor(bob$vpHaendigkeit)

# prüfen ob alles übereinstimmt
# erst mal die Buchstaben auf lower case bringen
bob$vpCode_lower_str=tolower(bob$vpCode)
bob$vpCode= as.factor(bob$vpCode_lower_str)


bob$vpCode_match  = as.character(bob$vpCode)== as.character(bob$vpCode_pre)
bob$vpSex_match   = as.character(bob$vpSex)== as.character(bob$vpSex_pre)
bob$vpGeburt_match =  bob$vpGeburt == bob$vpGeburt_pre

bob$vpNummer[bob$vpCode_match   == FALSE]
bob$vpNummer[bob$vpSex_match    == FALSE]
bob$vpNummer[bob$vpGeburt_match == FALSE]

# Missing values ###############################################################
# missing values durck NA ersetzen 

# für die Reaktopnszeiten
bob$reactionStimOFF[bob$keyValue==9999] <- NA
bob$reactionStimON[bob$keyValue==9999]  <- NA
# und die eigentlichen keys
bob$keyValue[bob$keyValue==9999]        <- NA

# hats funtioniert ?
#bob$keyValue==9999
#sollte auch mit recode gehn


# erster überblick
summary(bob)

# keyValues -1 da die cedrus box nur werte von 2-8 ausgibt######################
f.value <- function(datarow){
  math=datarow-1
  return(math)
}
bob$keyValue= mapply(f.value, bob$keyValue)

# sicherheitskopie #############################################################
bob_full = bob


#Übung raus ####################################################################
bob      = subset(bob , bob$blockBeschreibung != 'übung' )


# STRING stuff #################################################################
# http://gastonsanchez.com/blog/resources/how-to/2013/09/22/Handling-and-Processing-Strings-in-R.html
# erst mal die Buchstaben auf lower case bringen

# bob$vpCode_lower_str=tolower(bob$vpCode)
# bob$vpCode= as.factor(bob$vpCode_lower_str)

#vpcode zwerlegung Aufbau abc1998m #############################################
summary(bob$vpCode_lower_str)

# Geburtsdatum extrahieren
bob$vpGeburt = str_sub(bob$vpCode_lower_str, 4, 7) 
bob$vpGeburt = as.numeric (bob$vpGeburt)
bob$vpGeburt_alter = 2014-bob$vpGeburt

# Geschlecht extrahieren
bob$vpSex    = str_sub(bob$vpCode_lower_str, 8, 8)
bob$vpSex         <- as.factor(bob$vpSex)
levels(bob$vpSex) <- c('male' , 'female')


# die stimulus codierunng zerlegen #############################################
bob$stimulus_str <- as.character(bob$stimulus)
# trennt "3_N_B_180.png" bei den '_'

temp.str_split= str_split_fixed(bob$stimulus_str ,'_',4)

# temp in die verschienden variablen auflösen
bob$stimulusGRUNDFORM <- ( temp.str_split )[,1]
bob$stimulusZWEITFORM <- ( temp.str_split )[,2]
bob$stimulusFARBE     <- ( temp.str_split )[,3]
bob$stimulusWINKEL    <- ( temp.str_split )[,4]


# in fakoren umwandeln
bob$stimulusGRUNDFORM  <- as.factor(bob$stimulusGRUNDFORM)
bob$stimulusZWEITFORM  <- as.factor(bob$stimulusZWEITFORM)
bob$stimulusFARBE      <- as.factor(bob$stimulusFARBE)
bob$stimulusWINKEL     <- as.factor(bob$stimulusWINKEL)

levels(bob$stimulusGRUNDFORM)
levels(bob$stimulusZWEITFORM)
levels(bob$stimulusFARBE)
levels(bob$stimulusWINKEL)

# levels neu setzen
levels(bob$stimulusGRUNDFORM) <- c('circle' , 'triangle' , 'square')
levels(bob$stimulusZWEITFORM) <- c('cut' , 'heigth' , 'normal' , 'width' )
levels(bob$stimulusFARBE)     <- c('blue' , 'green' , 'orange' , 'red')
levels(bob$stimulusWINKEL)    <- c( '000' , '045' , '090' , '135' , '180' , '225' , '270' , '315' )


# levels an stim positions #####################################################
#                3          3          3          3
#        3      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   % = border / free space
#               %% ###1L## %% ###1M## %% ###1R## %%   # = actual face
#               %% ####### %% ####### %% ####### %%
#        3      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#               %% ###2L## %% ###2M## %% ###2R## %%
#               %% ####### %% ####### %% ####### %%   + = fixcross cross
#        3      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#               %% ###3L## %% ###3M## %% ###3R## %%
#               %% ####### %% ####### %% ####### %%
#        3      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# positonArray(1) = {rect.M2};
# positonArray(2) = {rect.L1};
# positonArray(3) = {rect.L3};
# positonArray(4) = {rect.R1};
# positonArray(5) = {rect.R3};

bob$stimPosition <-as.factor(bob$stimPosition)
levels(bob$stimPosition) <- c('mitte', 'links_oben', 'links_unten', 'rechts_oben','rechts_unten')

# neue spalte links mitte rechts ###############################################
f.position.lmr <- function(datarow){
  if(datarow == 'mitte'       ){return ('mitte' )}
  if(datarow == 'links_oben'  ){return ('links' )}  
  if(datarow == 'links_unten' ){return ('links' )}
  if(datarow == 'rechts_oben' ){return ('rechts')}
  if(datarow == 'rechts_unten'){return ('rechts')}
}
# f. anwenden
bob$positionLMR <- sapply(bob$stimPosition, f.position.lmr)
bob$positionLMR <- as.factor(bob$positionLMR) # in factor umwandeln
summary(bob$positionLMR)

# neue spalte links mitte rechts ###############################################
f.position.omu <- function(datarow){
  if(datarow == 'mitte'       ){return ('mitte')}
  if(datarow == 'links_oben'  ){return ('oben' )}  
  if(datarow == 'links_unten' ){return ('unten')}
  if(datarow == 'rechts_oben' ){return ('oben' )}
  if(datarow == 'rechts_unten'){return ('unten')}
}
# f. anwenden
bob$positionOMU <- sapply(bob$stimPosition, f.position.omu)
bob$positionOMU <- as.factor(bob$positionOMU) # in factor umwandeln
summary(bob$positionOMU)


# neue spalte foveal und nonfoveal  ############################################
f.position.nonfoveal <- function(datarow){
  if(datarow=='mitte'){return('foveal')   }
  if(datarow!='mitte'){return('nonfoveal')}
}
# f. anwenden
bob$positionFoveal_Nonfoveal <- sapply(bob$stimPosition, f.position.nonfoveal)
bob$positionFoveal_Nonfoveal <- as.factor(bob$positionFoveal_Nonfoveal) # in factor umwandeln
summary(bob$positionFoveal_Nonfoveal)

# eckig_rund und rund_eckig zusammenführen #####################################
a=summary(bob$keyValue)

f.harmonize.block <- function(datarow){
  if(datarow=='rund_eckig'){return('eckig_rund')} 
  if(datarow!='rund_eckig'){return(as.character( datarow))}
}

f.harmonize.key <- function(datarow, caserow){
  if(caserow=='rund_eckig'){return(8-datarow)}
  if(caserow!='rund_eckig'){return(datarow)}
}

bob$keyValue_harmonized =         mapply(f.harmonize.key, bob$keyValue , bob$blockBeschreibung )
bob$blockBeschreibung_harmonized =sapply(bob$blockBeschreibung, f.harmonize.block)

bob$blockBeschreibung_harmonized<- as.factor(bob$blockBeschreibung_harmonized)

# hilfsvariablen löschen #######################################################
bob$vpCode_lower_str <- NULL
bob$stimulus_str     <- NULL

# speichern als Rdata ##########################################################

write.csv          (bob, file = "shapes1data.csv")
save               (bob, file = "shapes1data.Rda")
foreign:::write.dta(bob, file = "shapes1data.dta") # kann spss auch importiern

# sessionInfo speichern ########################################################
# https://stackoverflow.com/questions/21967254/how-to-write-a-reader-friendly-sessioninfo-to-text-file
writeLines(capture.output(sessionInfo()), "sessionInfo_R01.txt")

# end ##########################################################################