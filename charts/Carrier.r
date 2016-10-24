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

# Aufbau der Datenbankverbindung
con <- dbConnect(MySQL(),
                 user=config$db$user, password=config$db$pass,
                 dbname=config$db$name, host=config$db$host)
# Finally: Bei Beenden die Verbindung automatisch schliessen
on.exit(dbDisconnect(con))

# Abfrage 24483
sql <- sprintf("
SELECT WEEK(kill_time) as datum, count(killID) as anzahl
FROM KR_participants PARTITION (p%s)
WHERE isVictim = 1
AND shipTypeID = 24483
AND YEAR(kill_time) = %s
AND WEEK(kill_time) != 0
AND WEEK(kill_time) != 53
#AND WEEK(kill_time) between 1 AND 6
GROUP BY WEEK(kill_time);", runyear, runyear)
rs <- dbSendQuery(con, sql)

# Ergebnisse laden und in interne Datenstruktur uebertragn
data <- fetch(rs,n=-1)   ## fetch all elements from the result set
dat24483 <- data.frame(
  anzahl <- data[1],
  datum <- data[2]
)

# Abfrage 23915
sql <- sprintf("
SELECT WEEK(kill_time) as datum, count(killID) as anzahl
FROM KR_participants PARTITION (p%s)
WHERE isVictim = 1
AND shipTypeID = 23915
AND YEAR(kill_time) = %s
AND WEEK(kill_time) != 0
AND WEEK(kill_time) != 53
#AND WEEK(kill_time) between 1 AND 6
GROUP BY WEEK(kill_time);", runyear, runyear)
rs <- dbSendQuery(con, sql)


# Ergebnisse laden und in interne Datenstruktur uebertragn
data <- fetch(rs,n=-1)   ## fetch all elements from the result set
dat23915 <- data.frame(
  anzahl <- data[1],
  datum <- data[2]
)
# Abfrage 23757
sql <- sprintf("
SELECT WEEK(kill_time) as datum, count(killID) as anzahl
FROM KR_participants PARTITION (p%s)
WHERE isVictim = 1
AND shipTypeID = 23757
AND YEAR(kill_time) = %s
AND WEEK(kill_time) != 0
AND WEEK(kill_time) != 53
#AND WEEK(kill_time) between 1 AND 6
GROUP BY WEEK(kill_time);", runyear, runyear)
rs <- dbSendQuery(con, sql)

# Ergebnisse laden und in interne Datenstruktur uebertragn
data <- fetch(rs,n=-1)   ## fetch all elements from the result set
dat23757 <- data.frame(
  anzahl <- data[1],
  datum <- data[2]
)

# Abfrage 23911
sql <- sprintf("
SELECT WEEK(kill_time) as datum, count(killID) as anzahl
FROM KR_participants PARTITION (p%s)
WHERE isVictim = 1
AND shipTypeID = 23911
AND YEAR(kill_time) = %s
AND WEEK(kill_time) != 0
AND WEEK(kill_time) != 53
#AND WEEK(kill_time) between 1 AND 6
GROUP BY WEEK(kill_time);", runyear, runyear)
rs <- dbSendQuery(con, sql)


# Ergebnisse laden und in interne Datenstruktur uebertragn
data <- fetch(rs,n=-1)   ## fetch all elements from the result set
dat23911 <- data.frame(
  anzahl <- data[1],
  datum <- data[2]
)


cols <- c("Nidhoggur"="red","Chimera"="steelblue2","Archon"="orange","Thanatos"="aquamarine4")

graphtitle = paste("Carrier ",runyear,sep="")

# Plotting all four into one
p <- ggplot() + 
  ggtitle(graphtitle) + 
  geom_line(data=dat24483, aes(x = datum, y = anzahl, colour="Nidhoggur") ) + geom_point(data=dat24483, aes(x = datum, y = anzahl), size=1 ) +
  geom_line(data=dat23915, aes(x = datum, y = anzahl, colour="Chimera") ) + geom_point(data=dat23915, aes(x = datum, y = anzahl), size=1 ) + 
  geom_line(data=dat23757, aes(x = datum, y = anzahl, colour="Archon") ) + geom_point(data=dat23757, aes(x = datum, y = anzahl), size=1 ) + 
  geom_line(data=dat23911, aes(x = datum, y = anzahl, colour="Thanatos") ) + geom_point(data=dat23911, aes(x = datum, y = anzahl), size=1 ) +
  # Setting the labels
  xlab("Week") +
  ylab("Losses") +
  scale_colour_manual(name="Carrier",values=cols, guide = guide_legend(fill = NULL,colour = NULL) ) +
  theme( legend.position = "bottom") +
  theme_bw()

print (p)

# Now save the plot to a file
dateiname = paste("/var/games/KillReporter/EVEData/charts/","Carrier_",runyear,".png",sep="")
ggsave(filename=dateiname, plot=p,width=8, height=4, dpi=100)
