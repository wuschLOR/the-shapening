################################################################################
##                             Datenaufbereitung                              ##
################################################################################
#  History
#  2014-12-09 mg  all 
#  2014-11-25 mg  first commited version
################################################################################
#  TODO
#  [ ] rauswerfen von schlechten Werten 
#  [ ] Automatisches auswerfen der Plots
#  [X] stimulus codierung zerlegen und Factoren draus machen :)
################################################################################

# Workspace leeren
rm(list = ls())


# pfad setzen optional wenn das rskript mit doppelkilck ausgeführt wurde 
setwd("~/git/the-shapening/results/")


# pakete installieren ##########################################################

# install.packages("stringr")

# pakete laden #################################################################

library(stringr)


# get list of all csv files ####################################################
# http://stackoverflow.com/questions/11433432/importing-multiple-csv-files-into-r
csvlist = list.files(pattern="*.csv")

# bob initieren
bob= rbind (read.csv(csvlist[1]))

# loop alle dateien einlesen und in ein file klatschen 
howmanycsv=length(csvlist)
for (i in 2:howmanycsv) {
  bob= rbind (bob , read.csv(csvlist[i]))
}


# Missing values ###############################################################
# missing values durck NA ersetzen 

# für die Reaktopnszeiten
bob$reactionStimOFF[bob$keyValue==9999] <- NA
bob$reactionStimON[bob$keyValue==9999]  <- NA
# und die eigentlichen keys
bob$keyValue[bob$keyValue==9999]        <- NA

# hats funtioniert ?
bob$keyValue==9999
#sollte auch mit recode gehn


# erster überblick
summary(bob)


# sicherheitskopie #############################################################
bob_full = bob


#Übung raus ####################################################################
bob      = subset(bob , bob$blockBeschreibung != 'übung' )


# STRING stuff #################################################################
# http://gastonsanchez.com/blog/resources/how-to/2013/09/22/Handling-and-Processing-Strings-in-R.html
# erst mal die buchtaben normalisieren

bob$vpCode_lower_str=tolower(bob$vpCode)
bob$vpCode_lower= as.factor(bob$vpCode_lower_str)

#vpcode zwerlegung
summary(bob$vpCode_lower_str)
bob$vpGeburt = str_sub(bob$vpCode_lower_str, 4, 7)
bob$vpGeburt = as.numeric (bob$vpGeburt)
bob$vpGeburt_alter = 2014-bob$vpGeburt

bob$vpSex    = str_sub(bob$vpCode_lower_str, 8, 8)
bob$vpSex         <- as.factor(bob$vpSex)
levels(bob$vpSex) <- c('male' , 'female')


# die stimulus codierunng zerlegen
bob$stimulus_str <- as.character(bob$stimulus)
# trennt "3_N_B_180.png" bei den '_'

temp.str_split= str_split_fixed(bob$stimulus_str ,'_',4)

# temp in die verschienden variablen auflösen
bob$stimulus_str_splitGRUNDFORM <- ( temp.str_split )[,1]
bob$stimulus_str_splitZWEITFORM <- ( temp.str_split )[,2]
bob$stimulus_str_splitFARBE     <- ( temp.str_split )[,3]
bob$stimulus_str_splitWINKEL    <- ( temp.str_split )[,4]


# in fakoren umwandeln
bob$stimulus_str_splitGRUNDFORM  <- as.factor(bob$stimulus_str_splitGRUNDFORM)
bob$stimulus_str_splitZWEITFORM  <- as.factor(bob$stimulus_str_splitZWEITFORM)
bob$stimulus_str_splitFARBE      <- as.factor(bob$stimulus_str_splitFARBE)
bob$stimulus_str_splitWINKEL     <- as.factor(bob$stimulus_str_splitWINKEL)

levels(bob$stimulus_str_splitGRUNDFORM)
levels(bob$stimulus_str_splitZWEITFORM)
levels(bob$stimulus_str_splitFARBE)
levels(bob$stimulus_str_splitWINKEL)

# levels neu setzen
levels(bob$stimulus_str_splitGRUNDFORM) <- c('circle' , 'triangle' , 'square')
levels(bob$stimulus_str_splitZWEITFORM) <- c('cut' , 'heigth' , 'normal' , 'width' )
levels(bob$stimulus_str_splitFARBE)     <- c('blue' , 'green' , 'orange' , 'red')
levels(bob$stimulus_str_splitWINKEL)    <- c( '000' , '045' , '090' , '135' , '180' , '225' , '270' , '315' )


# position nach foveal und nonfoveal sortieren #################################
f.nonfoveal <- function(x){
  if(x==1){return('foveal')}
  if(x>1){return('nonfoveal')}
}
f.nonfoveal(1)
f.nonfoveal(2)

# f. anwenden
bob$foveal_nonfoveal <- sapply(bob$stimPosition, f.nonfoveal)
# in factor umwandeln
bob$foveal_nonfoveal <- as.factor(bob$foveal_nonfoveal)

summary(bob)


# speichern als Rdata ##########################################################

save(bob , file="shapes1data.Rda")
foreign:::write.dta(bob, "shapes1data.dta") # kann spss auch importiern
