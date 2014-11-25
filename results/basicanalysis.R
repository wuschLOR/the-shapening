###############################################################
##                 Auswertung Shapening 1                    ##
###############################################################

# Workspace leeren
rm(list = ls())

# pfad setzen
setwd("~/git/the-shapening/results/")

###############################################################

# get list of all csv files 
# http://stackoverflow.com/questions/11433432/importing-multiple-csv-files-into-r
csvlist = list.files(pattern="*.csv")

# total initieren
total=NA

# loop alle dateien einlesen und in ein file klatschen 
for (i in 1:length(csvlist)) {
  total= rbind (total , read.csv(csvlist[i]))
}

#remove the first row ith just NA in it with was created wenn initilizing total
total = total[-1,]

###############################################################

# missing values durck NA ersetzen 
# für die Reaktopnszeiten
total$reactionStimOFF[total$keyValue==9999] <- NA
total$reactionStimON[total$keyValue==9999] <- NA

# und die eigentlichen keys
total$keyValue[total$keyValue==9999] <- NA

# hats funtioniert ?
total$keyValue==9999

# aggVp anlegen für alle daten die über de versuchspersonen aggregiert werden
aggVpvpNummer = unique(total$vpNummer)
aggVpvpCode = unique(total$vpCode)

# aggShapes
# agg

###############################################################
# Hypothese 2 (Reaktionszeit foveal = nonfoveal)
# Wahrnehmung von objekten kann entweder foveal oder nonfoveal geschehen. Da sich hier die Verarbeitungszeiten unterscheiden sollte die auch in diesem Experiment nachweisbar sein. Dementsprechen werden die Reaktionszeiten Reaktionszeiten unterscheiden sich zwischen der fovealen und den nonfovealen Bedingung

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





plot (total$reactionStimOFF)

OLDplotpar <- par(col)
par(OLDplotpar)
nVP= 4

plot ( total$blockIndex[complete.cases(total$keyValue)]  , total$reactionStimOFF [complete.cases(total$keyValue)&total$vpNummer==1], 'l', col = 'red')
lines (total$reactionStimOFF [complete.cases(total$keyValue)&total$vpNummer==2], 'l', col=blue)

par(pch=22, col="red") # plotting symbol and color
par(mfrow=c(2,4)) # all plots on one page 
opts= c('vp1', 'vp2' ,'vp3' ,'vp4')
for(i in 1:length(opts)){
  heading = paste(opts[i])
  plot(total$reactionStimOFF[total$vpNummer==i], 'n', main=heading)
  lines(total$reactionStimOFF[total$vpNummer==i])
}

for(i in 1:4){
plot (  total$reactionStimOFF[total$vpNummer==i], col ='white')
lines ( total$reactionStimOFF[total$vpNummer==i], col ='red')
}


lines ( total$reactionStimOFF[total$vpNummer==2], col='blue')
lines ( total$reactionStimOFF[total$vpNummer==3], col='green')
lines ( total$reactionStimOFF[total$vpNummer==4], col='black')

# generelle tastenverteilung
plot (total$keyValue)

# spezielle tastenverteilung
plot (total$blockBeschreibung , total$keyValue )
plot (total$keyValue [total$blockBeschreibung=='links_rechts'] )
plot (total$keyValue [total$blockBeschreibung=='rund_eckig'])
plot (total$keyValue [total$blockBeschreibung=='übung'])

mean (total$dauerBetween)
mean (total$dauerStim)


