#!/usr/bin/env Rscript

# Einbinden der Packages
library(methods)
library(grid)
library(quadprog)
library(proto)
library(DBI)
library(RMySQL)
library(ggplot2)
library(reshape2)
library(directlabels)
library(yaml)
library(gridExtra)

trim <- function (x) gsub("^\\s+|\\s+$", "", x)

# Laden der externen Konfigurationsdatei
config = yaml.load_file("KillReports.yaml")

args <- commandArgs(trailingOnly = TRUE)	
runyear = args[1]
runyear <- trim(runyear)

minmatarName = args[2]
minmatarID = args[3]

# Aufbau der Datenbankverbindung
con <- dbConnect(MySQL(),
                 user=config$db$user, password=config$db$pass,
                 dbname=config$db$name, host=config$db$host)
# Finally: Bei Beenden die Verbindung automatisch schliessen
on.exit(dbDisconnect(con))


getKills <- function(runyear, shipID) {
  sql <- sprintf("
  SELECT WEEK(kill_time) as datum, count(killID) as anzahl
  FROM KR_participants PARTITION (p%s)
  WHERE isVictim = 1
  AND shipTypeID = %s
  AND YEAR(kill_time) = %s
  AND WEEK(kill_time) != 0
  AND WEEK(kill_time) != 53
  #AND WEEK(kill_time) between 1 AND 6
  GROUP BY WEEK(kill_time);", runyear, shipID, runyear)
  rs <- dbSendQuery(con, sql)

  # Ergebnisse laden und in interne Datenstruktur uebertragn
  data <- fetch(rs,n=-1)   ## fetch all elements from the result set
  dattemp <- data.frame(
    anzahl <- data[1],
    datum <- data[2]
  )
return(dattemp) 
}

# Abfrage Minmatar
# Den neuen Namen zusammensetzen und Variable zuweisen
tempname = paste("dat", minmatarID, sep = "")
assign(tempname, getKills(runyear, minmatarID)  )

cols <- c( "Rorqual"="orange")

graphtitle = paste("Capital Industrial Ships ",runyear,sep="")

# Plotting all four into one
p <- ggplot() + 
  ggtitle(graphtitle) + 
  geom_line(data=dat28352, aes(x = datum, y = anzahl, colour=minmatarName) ) + geom_point(data=dat28352, aes(x = datum, y = anzahl), size=1 ) +
  # Setting the labels
  xlab("Week") +
  ylab("Losses") +
  scale_colour_manual(name="Capital Industrial Ships",values=cols, guide = guide_legend(fill = NULL,colour = NULL) ) +
  theme( legend.position = "bottom") +
  theme_bw()

print (p)

# Now save the plot to a file
dateiname = paste("/var/games/KillReporter/EVEData/charts/","CapitalIndustrialShips_",runyear,".png",sep="")
ggsave(filename=dateiname, plot=p,width=8, height=4, dpi=100)
