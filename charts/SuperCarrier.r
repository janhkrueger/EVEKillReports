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

# Abfrage 22852
sql <- sprintf("
SELECT WEEK(kill_time) as datum, count(killID) as anzahl
FROM KR_participants
WHERE isVictim = 1
AND shipTypeID = 22852
AND YEAR(kill_time) = %s
AND WEEK(kill_time) != 0
AND WEEK(kill_time) != 53
#AND WEEK(kill_time) between 1 AND 6
GROUP BY WEEK(kill_time);", runyear)
rs <- dbSendQuery(con, sql)

# Ergebnisse laden und in interne Datenstruktur uebertragn
data <- fetch(rs,n=-1)   ## fetch all elements from the result set
dat22852 <- data.frame(
  datum <- data[2],
  anzahl <- data[1]
)
# print (dat22852)

# Abfrage 23917
sql <- sprintf("
SELECT WEEK(kill_time) as datum, count(killID) as anzahl
FROM KR_participants
WHERE isVictim = 1
AND shipTypeID = 23917
AND YEAR(kill_time) = %s
AND WEEK(kill_time) != 0
AND WEEK(kill_time) != 53
#AND WEEK(kill_time) between 1 AND 6
GROUP BY WEEK(kill_time);", runyear)
rs <- dbSendQuery(con, sql)


# Ergebnisse laden und in interne Datenstruktur uebertragn
data <- fetch(rs,n=-1)   ## fetch all elements from the result set
dat23917 <- data.frame(
  anzahl <- data[1],
  datum <- data[2]
)
#print (dat23917)

# Abfrage 23919
sql <- sprintf("
SELECT WEEK(kill_time) as datum, count(killID) as anzahl
FROM KR_participants
WHERE isVictim = 1
AND shipTypeID = 23919
AND YEAR(kill_time) = %s
AND WEEK(kill_time) != 0
AND WEEK(kill_time) != 53
#AND WEEK(kill_time) between 1 AND 6
GROUP BY WEEK(kill_time);", runyear)
rs <- dbSendQuery(con, sql)

# Ergebnisse laden und in interne Datenstruktur uebertragn
data <- fetch(rs,n=-1)   ## fetch all elements from the result set
dat23919 <- data.frame(
  anzahl <- data[1],
  datum <- data[2]
)

# Abfrage 23913
sql <- sprintf("
SELECT WEEK(kill_time) as datum, count(killID) as anzahl
FROM KR_participants
WHERE isVictim = 1
AND shipTypeID = 23913
AND YEAR(kill_time) = %s
AND WEEK(kill_time) != 0
AND WEEK(kill_time) != 53
#AND WEEK(kill_time) between 1 AND 6
GROUP BY WEEK(kill_time);", runyear)
rs <- dbSendQuery(con, sql)


# Ergebnisse laden und in interne Datenstruktur uebertragn
data <- fetch(rs,n=-1)   ## fetch all elements from the result set
dat23913 <- data.frame(
  anzahl <- data[1],
  datum <- data[2]
)

cols <- c("Hel"="red","Wyvern"="steelblue2","Aeon"="orange","Nyx"="aquamarine4")

graphtitle = paste("SuperCarrier ",runyear,sep="")

# Plotting all four into one
p <- ggplot() + 
  ggtitle(graphtitle) + 
  geom_line(data=dat22852, aes(x = datum, y = anzahl, colour="Hel") ) + geom_point(data=dat22852, aes(x = datum, y = anzahl), size=1 ) +
  geom_line(data=dat23917, aes(x = datum, y = anzahl, colour="Wyvern") ) + geom_point(data=dat23917, aes(x = datum, y = anzahl), size=1 ) + 
  geom_line(data=dat23919, aes(x = datum, y = anzahl, colour="Aeon") ) + geom_point(data=dat23919, aes(x = datum, y = anzahl), size=1 ) + 
  geom_line(data=dat23913, aes(x = datum, y = anzahl, colour="Nyx") ) + geom_point(data=dat23913, aes(x = datum, y = anzahl), size=1 ) +
  # Setting the labels
  xlab("Week") +
  ylab("Losses") +
  scale_colour_manual(name="SuperCarrier",values=cols, guide = guide_legend(fill = NULL,colour = NULL) ) +
  theme( legend.position = "bottom") +
  theme_bw()

print (p)

# Now save the plot to a file
dateiname = paste("/var/games/KillReporter/EVEData/charts/","Supercarrier_",runyear,".png",sep="")
ggsave(filename=dateiname, plot=p,width=8, height=4, dpi=100)
