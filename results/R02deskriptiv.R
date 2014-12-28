################################################################################
##                               02 deskriptiv                                ##
################################################################################
# history
# 2014-12-23 histogramm output
################################################################################
#  TODO
#  [ ] descriptiv stuff bevore the data gets cleaned in 03
#  [X] histograms to get a sense of the data and compare eckig_rund <-> links_rechts
################################################################################

rm(list = ls())

load("shapes1data.Rda")

# librarys #####################################################################
library(lattice) # histogramm
library(psych)   # describe


# wer sind meine versuchspersonen ?




# päsentationszeiten deskiptiv #################################################
# Tabelle in der DA

f.n_mean_sd <- function(describe_output){
  c(describe_output[2],describe_output[3], describe_output[4])
}

f.n_mean_sd( describe(bob$dauerBetween) )
f.n_mean_sd( describe(bob$dauerFix)     )
f.n_mean_sd( describe(bob$dauerPre)     )
f.n_mean_sd( describe(bob$dauerStim)    )
f.n_mean_sd( describe(bob$dauerAfter)   )
f.n_mean_sd( describe(bob$dauerRating)  )



# histogramme ausgeben block 1 und 2 im vergleich ##############################
# http://thebiobucket.blogspot.de/2011/08/comparing-two-distributions.html#more
vpn = unique(bob$vpNummer)

f.hist <- function(code){
  
  testvp=subset(bob, bob$vpNummer==code)
  testvp$blockBeschreibung <- factor(testvp$blockBeschreibung)
  testvp$vpCode            <- factor(testvp$vpCode)
  
  #chi
  m <- table(testvp$blockBeschreibung, testvp$keyValue)
  CHI    <- chisq.test (testvp$blockBeschreibung,
                        testvp$keyValue)
  #  CHIsim <- chisq.test(m,simulate.p.value = TRUE)
  
  P    = as.character(format(CHI$p.value,scientific = TRUE))
  PN   = paste('\n', as.character(format(CHI$p.value,scientific = FALSE)) )
  CODE = as.character(unique(testvp$vpCode))
  NUMB = as.character(unique(testvp$vpNummer))
  firstrow = paste(NUMB ,CODE  ,P)
  secondrow= paste(PN)
  title = paste(firstrow,secondrow )
  
  histogram(~ keyValue|blockBeschreibung, 
            data   = testvp, 
            col    = "gray60", 
            layout = c(1, 2),
            xlab   = list("rating"),
            ylab   = list("sum"),
            scales = list(y = list(alternating = F)),
            main   = title 
           )
}

for (i in vpn) {
  nam = (paste("hist",i,".png",sep="") )
  png(filename=nam)
  plots<-f.hist(i)
  print(plots)
  dev.off()
}

# hist harm ####################################################################
f.hist_harm <- function(code){
  
  testvp=subset(bob, bob$vpNummer==code)
  testvp$blockBeschreibung_harmonized <- factor(testvp$blockBeschreibung_harmonized)
  testvp$vpCode            <- factor(testvp$vpCode)
  
  #chi
  m <- table(testvp$blockBeschreibung_harmonized, testvp$keyValue)
  CHI    <- chisq.test (testvp$blockBeschreibung_harmonized,
                        testvp$keyValue_harmonized)
  #  CHIsim <- chisq.test(m,simulate.p.value = TRUE)
  
  P    = as.character(format(CHI$p.value,scientific = TRUE))
  PN   = paste('\n', as.character(format(CHI$p.value,scientific = FALSE)) )
  CODE = as.character(unique(testvp$vpCode))
  NUMB = as.character(unique(testvp$vpNummer))
  firstrow = paste(NUMB ,CODE  ,P)
  secondrow= paste(PN)
  title = paste(firstrow,secondrow )
  
  histogram(~ keyValue_harmonized|blockBeschreibung_harmonized, 
            data   = testvp, 
            col    = "gray60", 
            layout = c(1, 2),
            xlab   = list("rating"),
            ylab   = list("sum"),
            scales = list(y = list(alternating = F)),
            main   = title 
           )
}

for (i in vpn) {
  nam = (paste("hist_harm",i,".png",sep="") )
  png(filename=nam)
  plots<-f.hist_harm(i)
  print(plots)
  dev.off()
}
# sessionInfo speichern ########################################################
# https://stackoverflow.com/questions/21967254/how-to-write-a-reader-friendly-sessioninfo-to-text-file
writeLines(capture.output(sessionInfo()), "sessionInfo_R03.txt")

# end ##########################################################################