################################################################################
##                               03 bereinigung                               ##
################################################################################
#  History
#  2014-12-14 mg  first commited version
################################################################################
#  TODO
#  [x] <300ms
#  [x] 2.5 sd
#  [x] remove vp fails 
#  [x] remove technical fails
################################################################################
rm(list = ls())

load("shapes1data.Rda")

# librarys #####################################################################
# install.packages('psych')
# install.packages('ez')
# install.packages('lattice')
library(lattice) # histogramm
library(psych)   # describe
library(ez)      # anova ??????


# erste modifkationen und rauswerfen von VP die quatsch gemacht haben###########

# die vp 1-4 fliegen aus da die buttonbox quatsch aufgezeihnet hat
bob$reactionStimON[bob$vpNummer==1] <- NA
bob$reactionStimON[bob$vpNummer==2] <- NA
bob$reactionStimON[bob$vpNummer==3] <- NA
bob$reactionStimON[bob$vpNummer==4] <- NA


# vp 23 hat links-recht und eckig_rund vertauscht zu haben
# https://stackoverflow.com/questions/11810605/replace-contents-of-factor-column-in-r-dataframe
# alt 2 links_rechts 3 eckig_rund
# neu 2 eckig_rund   3 links_rechs
levels(bob$blockBeschreibung) <- c(levels(bob$blockBeschreibung), 'dummy1' , 'dummy2')
bob$blockBeschreibung[bob$vpNummer==23 & bob$blockBeschreibung=='links_rechts'] <- 'dummy1'
bob$blockBeschreibung[bob$vpNummer==23 & bob$blockBeschreibung=='eckig_rund']   <- 'dummy2'
bob$blockBeschreibung[bob$vpNummer==23 & bob$blockBeschreibung=='dummy1']       <- 'eckig_rund'
bob$blockBeschreibung[bob$vpNummer==23 & bob$blockBeschreibung=='dummy2']       <- 'links_rechts'

bob$blockBeschreibung<- factor(bob$blockBeschreibung) #  unnütze faktoren rasuwerfen
levels(bob$blockBeschreibung)

# reaktionen schneller als 300 ms rauswerfen (mail von CCC)
#das sollte schon ehr passieren aber da vp 1-4 negative reaktionszeiten haben muss dieser test erst jetzt durchgeführt werden damit die ratings nicht verloren gehen (bob_rating) da diese verwndet werden können
bob$keyValue       [bob$reactionStimON<0.300]<- NA
bob$reactionStimOFF[bob$reactionStimON<0.300]<- NA
bob$reactionStimON [bob$reactionStimON<0.300]<- NA
bob$reactionStimON
# ratings und reaktionszeiten bereinigen #######################################
# reaktionen mit mehr oder weniger als 2.5 sd rauswerfen (mail von CCC)

vpn = unique(bob$vpNummer)
for (i in vpn){
  blocklist = unique(bob$blockBeschreibung_harmonized)
  for (j in blocklist){
    m= mean(bob$reactionStimON[bob$vpNummer==i & bob$blockBeschreibung_harmonized==j], na.rm='true')
    s= sd  (bob$reactionStimON[bob$vpNummer==i & bob$blockBeschreibung_harmonized==j], na.rm='true')
    high = m + s*2.5
    low  = m - s*2.5
    bob$keyValue            [bob$vpNummer==i & bob$blockBeschreibung_harmonized==j & bob$reactionStimON> high] <- NA
    bob$keyValue            [bob$vpNummer==i & bob$blockBeschreibung_harmonized==j & bob$reactionStimON< low ] <- NA
    bob$keyValue_harmonized [bob$vpNummer==i & bob$blockBeschreibung_harmonized==j & bob$reactionStimON> high] <- NA
    bob$keyValue_harmonized [bob$vpNummer==i & bob$blockBeschreibung_harmonized==j & bob$reactionStimON< low ] <- NA
    bob$reactionStimOFF     [bob$vpNummer==i & bob$blockBeschreibung_harmonized==j & bob$reactionStimON> high] <- NA
    bob$reactionStimOFF     [bob$vpNummer==i & bob$blockBeschreibung_harmonized==j & bob$reactionStimON< low ] <- NA
    bob$reactionStimON      [bob$vpNummer==i & bob$blockBeschreibung_harmonized==j & bob$reactionStimON> high] <- NA
    bob$reactionStimON      [bob$vpNummer==i & bob$blockBeschreibung_harmonized==j & bob$reactionStimON< low ] <- NA
  }
}

describe(bob$reactionStimON)
summary(bob$reactionStimON)
# vpn = unique(bob$vpNummer)
# for (i in vpn){
#   m= mean(bob$reactionStimON[bob$vpNummer==i], na.rm='true')
#   s= sd  (bob$reactionStimON[bob$vpNummer==i], na.rm='true')
#   high = m + s*2.5
#   low  = m - s*2.5
#   bob$keyValue            [bob$vpNummer==i & bob$reactionStimON> high] <- NA
#   bob$keyValue            [bob$vpNummer==i & bob$reactionStimON< low ] <- NA
#   bob$keyValue_harmonized [bob$vpNummer==i & bob$reactionStimON> high] <- NA
#   bob$keyValue_harmonized [bob$vpNummer==i & bob$reactionStimON< low ] <- NA
#   bob$reactionStimOFF     [bob$vpNummer==i & bob$reactionStimON> high] <- NA
#   bob$reactionStimOFF     [bob$vpNummer==i & bob$reactionStimON< low ] <- NA
#   bob$reactionStimON      [bob$vpNummer==i & bob$reactionStimON> high] <- NA
#   bob$reactionStimON      [bob$vpNummer==i & bob$reactionStimON< low ] <- NA
# }

# vp 23 hat im 3 block nicht die ausrichtung gerated sondern wo der stimulus erschein
bob$keyValue[bob$vpNummer==23 & bob$blockBeschreibung=='links_rechts'] <- NA

summary(bob)
describe(bob)

# speichern als Rdata ##########################################################

write.csv          (bob, file = "shapes1data_clean.csv")
save               (bob, file = "shapes1data_clean.Rda")
foreign:::write.dta(bob, file = "shapes1data_clean.dta") # kann spss auch importiern

# sessionInfo speichern ########################################################
# https://stackoverflow.com/questions/21967254/how-to-write-a-reader-friendly-sessioninfo-to-text-file
writeLines(capture.output(sessionInfo()), "sessionInfo_R03.txt")
# end ##########################################################################