###############################################################
##           basic analyisys for the shapening               ##
###############################################################
#  History
#  2014-11-25 mg  first commited version
###############################################################
#  TODO
#  [ ] eckig-rund und rund-eckig vereinheitlichen 
#  [ ] rauswerfen von schlechten Werten 
#  [ ] hypothehens integrieren
#  [ ] Automatisches auswerfen der Plots
#  [ ] aggregierung als Struktur machen 
#  [X] stimulus codierung zerlegen und Factoren draus machen :)
###############################################################

# Workspace leeren
rm(list = ls())

# pfad setzen optional wenn das rskript mit doppelkilck ausgeführt wurde 
setwd("~/forgeOC/EXPERIMENTE/003 Shapes1/dataplayground")
#setwd("~/git/the-shapening/results/")


###############################################################
# pakete installieren


# pakete laden

library(stringr)

###############################################################
# get list of all csv files 
# http://stackoverflow.com/questions/11433432/importing-multiple-csv-files-into-r
csvlist = list.files(pattern="*.csv")

# bob initieren
bob= rbind (read.csv(csvlist[1]))

# loop alle dateien einlesen und in ein file klatschen 
howmanycsv=length(csvlist)
for (i in 2:howmanycsv) {
  bob= rbind (bob , read.csv(csvlist[i]))
}

###############################################################
# Missing values
# missing values durck NA ersetzen 
# für die Reaktopnszeiten
bob$reactionStimOFF[bob$keyValue==9999] <- NA
bob$reactionStimON[bob$keyValue==9999] <- NA

# und die eigentlichen keys
bob$keyValue[bob$keyValue==9999] <- NA

# hats funtioniert ?
bob$keyValue==9999
#sollte auch mit recode gehn


# erster überblick
summary(bob)

#################################################################
#sicherheitskopie
bob_full = bob

#################################################################
#Übung raus 
bob = subset(bob, bob$blockBeschreibung != 'übung' )


#################################################################
# STRING stuff
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

################################################################
# position nach foveal und nonfoveal sortieren
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

################################################################
#vp rauswerfen :) die komische sachen machen
#bob_time = data frame dass für berechnungen mit der reaktionszeit verwendet werden kann
#bob_rating = daza frame dass für berechnungen mit dem rating genutzt werden kann

# check if VP has more than ??? missing values

sum(is.na(bob$keyValue))

# bob_time
# die ersten vier vp fliegen aus alles sachen mit der reaktionszeit raus da hier die buttonbox quatsch aufgezeihnet hat
bob_time = subset(bob, bob$vpNummer>4)

#http://forums.psy.ed.ac.uk/R/P01582/essential-10/
summary(bob_time, bob_time$vpNummer==12)

bob=bob_time[ bob_time$vpNummer==12]

summary(bob_time)

# bob_rating 
bob_rating = subset(bob,)
summary(bob_rating)


################################################################
# Aggregation über die versuchspersonen 
# aggVp anlegen für alle daten die über de versuchspersonen aggregiert werden


###############################################################
# aggShapes
# agg

###############################################################
# Hypothese 2 (Reaktionszeit foveal = nonfoveal)
# Wahrnehmung von objekten kann entweder foveal oder nonfoveal geschehen. Da sich hier die Verarbeitungszeiten unterscheiden sollte die auch in diesem Experiment nachweisbar sein. Dementsprechen werden die Reaktionszeiten Reaktionszeiten unterscheiden sich zwischen der fovealen und den nonfovealen Bedingung

bob_time_foveal    = subset (bob_time, bob$foveal_nonfoveal=='foveal')
bob_time_nonfoveal = subset (bob_time, bob$foveal_nonfoveal=='nonfoveal')
summary(bob_time_foveal$reactionStimOFF)
summary(bob_time_nonfoveal$reactionStimOFF)

tapply(bob$reactionStimOFF , bob$vpCode_lower , mean, na.exclude=TRUE)

plot(bob_time_nonfoveal$reactionStimOFF, bob_time_nonfoveal$stimulus_str_splitGRUNDFORM)
plot(bob_time_foveal$reactionStimOFF   , bob_time_foveal$stimulus_str_splitGRUNDFORM   )

t.test(bob_time_foveal$reactionStimOFF,bob_time_nonfoveal$reactionStimOFF)
wilcox.test(bob_time_foveal$reactionStimOFF,bob_time_nonfoveal$reactionStimOFF)

###############################################################
# Hypothese 3 (Reaktionszeit Dreieck < Viereck & Kreis)
# Die Reaktionszeiten auf dreieckige Stimuli weisen eine geringere Reaktionszeit auf als andere Stimuli (Raab & Carbon, 2012)

###############################################################
# Hypothese 4 (Skala(eckig-rund) ≡ rund-eckig)
# Skala rund-eckig ist gleich der Skala eckig-rund

###############################################################
# Hypothese 5 (Richtung ??)
# das pointy end gibt die Richtung an für links rechts

###############################################################
# Hypothese 6 (Skala(eckig-rund) Tendenz zu Extremwerten )
# eckig und rund werden recht binär angegeben werdend a es sich imvergleich zu
# marius seiner studie wirklich nur dinge ohne runde ecken handelt

###############################################################
# Hypothese 7 (Reaktionszeit (rot ≡ grün ≡





###############################################################
#plots

################################################################
listvpNummer = unique(bob$vpNummer)
listvpCode  = unique(bob$vpCode)
##reaktionszeiten 
for(i in 1:length(listvpNummer)){
  plot (  bob$reactionStimOFF[bob$vpNummer==listvpNummer[i]], col ='white')
  lines ( bob$reactionStimOFF[bob$vpNummer==listvpNummer[i]], col ='red')
}



###############################################################

plot (bob$reactionStimOFF)

OLDplotpar <- par(col)
par(OLDplotpar)
nVP= 4

plot ( bob$blockIndex[complete.cases(bob$keyValue)]  , bob$reactionStimOFF [complete.cases(bob$keyValue)&bob$vpNummer==1], 'l', col = 'red')
lines (bob$reactionStimOFF [complete.cases(bob$keyValue)&bob$vpNummer==2], 'l', col=blue)

par(pch=22, col="red") # plotting symbol and color
par(mfrow=c(2,4)) # all plots on one page 
opts= c('vp1', 'vp2' ,'vp3' ,'vp4')
for(i in 1:length(opts)){
  heading = paste(opts[i])
  plot(bob$reactionStimOFF[bob$vpNummer==i], 'n', main=heading)
  lines(bob$reactionStimOFF[bob$vpNummer==i])
}

for(i in 1:4){
plot (  bob$reactionStimOFF[bob$vpNummer==i], col ='white')
lines ( bob$reactionStimOFF[bob$vpNummer==i], col ='red')
}


lines ( bob$reactionStimOFF[bob$vpNummer==2], col='blue')
lines ( bob$reactionStimOFF[bob$vpNummer==3], col='green')
lines ( bob$reactionStimOFF[bob$vpNummer==4], col='black')

# generelle tastenverteilung
plot (bob$keyValue)

# spezielle tastenverteilung
plot (bob$blockBeschreibung , bob$keyValue )
plot (bob$keyValue [bob$blockBeschreibung=='links_rechts'] )
plot (bob$keyValue [bob$blockBeschreibung=='rund_eckig'])
plot (bob$keyValue [bob$blockBeschreibung=='übung'])

mean (bob$dauerBetween)
mean (bob$dauerStim)

######################################################################
#citation
x <- citation()
toBibtex(x)




##########################################################################
#probestuff

min(bob$keyValue)
max(bob$keyValue)
cut(bob$keyValue)
