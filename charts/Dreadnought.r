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

# Abfrage 19722
sql <- sprintf("
SELECT WEEK(kill_time) as datum, count(killID) as anzahl
FROM KR_participants
WHERE isVictim = 1
AND shipTypeID = 19722
AND YEAR(kill_time) = %s
AND WEEK(kill_time) != 0
AND WEEK(kill_time) != 53
#AND WEEK(kill_time) between 1 AND 6
GROUP BY WEEK(kill_time);", runyear)
rs <- dbSendQuery(con, sql)

# Ergebnisse laden und in interne Datenstruktur uebertragn
data <- fetch(rs,n=-1)   ## fetch all elements from the result set
dat19722 <- data.frame(
  anzahl <- data[1],
  datum <- data[2]
)

# Abfrage 19726
sql <- sprintf("
SELECT WEEK(kill_time) as datum, count(killID) as anzahl
FROM KR_participants
WHERE isVictim = 1
AND shipTypeID = 19726
AND YEAR(kill_time) = %s
AND WEEK(kill_time) != 0
AND WEEK(kill_time) != 53
#AND WEEK(kill_time) between 1 AND 6
GROUP BY WEEK(kill_time);", runyear)
rs <- dbSendQuery(con, sql)


# Ergebnisse laden und in interne Datenstruktur uebertragn
data <- fetch(rs,n=-1)   ## fetch all elements from the result set
dat19726 <- data.frame(
  anzahl <- data[1],
  datum <- data[2]
)

# Abfrage 19720
sql <- sprintf("
SELECT WEEK(kill_time) as datum, count(killID) as anzahl
FROM KR_participants
WHERE isVictim = 1
AND shipTypeID = 19720
AND YEAR(kill_time) = %s
AND WEEK(kill_time) != 0
AND WEEK(kill_time) != 53
#AND WEEK(kill_time) between 1 AND 6
GROUP BY WEEK(kill_time);", runyear)
rs <- dbSendQuery(con, sql)

# Ergebnisse laden und in interne Datenstruktur uebertragn
data <- fetch(rs,n=-1)   ## fetch all elements from the result set
dat19720 <- data.frame(
  anzahl <- data[1],
  datum <- data[2]
)

# Abfrage 19724
sql <- sprintf("
SELECT WEEK(kill_time) as datum, count(killID) as anzahl
FROM KR_participants
WHERE isVictim = 1
AND shipTypeID = 19724
AND YEAR(kill_time) = %s
AND WEEK(kill_time) != 0
AND WEEK(kill_time) != 53
#AND WEEK(kill_time) between 1 AND 6
GROUP BY WEEK(kill_time);", runyear)
rs <- dbSendQuery(con, sql)


# Ergebnisse laden und in interne Datenstruktur uebertragn
data <- fetch(rs,n=-1)   ## fetch all elements from the result set
dat19724 <- data.frame(
  anzahl <- data[1],
  datum <- data[2]
)


cols <- c("Naglfar"="red","Phoenix"="steelblue2","Revelation"="orange","Moros"="aquamarine4")

graphtitle = paste("Dreadnought ",runyear,sep="")

# Plotting all four into one
p <- ggplot() + 
  ggtitle(graphtitle) + 
  geom_line(data=dat19722, aes(x = datum, y = anzahl, colour="Naglfar") ) + geom_point(data=dat19722, aes(x = datum, y = anzahl), size=1 ) +
  geom_line(data=dat19726, aes(x = datum, y = anzahl, colour="Phoenix") ) + geom_point(data=dat19726, aes(x = datum, y = anzahl), size=1 ) + 
  geom_line(data=dat19720, aes(x = datum, y = anzahl, colour="Revelation") ) + geom_point(data=dat19720, aes(x = datum, y = anzahl), size=1 ) + 
  geom_line(data=dat19724, aes(x = datum, y = anzahl, colour="Moros") ) + geom_point(data=dat19724, aes(x = datum, y = anzahl), size=1 ) +
  # Setting the labels
  xlab("Week") +
  ylab("Losses") +
  scale_colour_manual(name="Dreadnought",values=cols, guide = guide_legend(fill = NULL,colour = NULL) ) +
  theme( legend.position = "bottom") +
  theme_bw()

print (p)

# Now save the plot to a file
dateiname = paste("/var/games/KillReporter/EVEData/charts/","Dreadnought_",runyear,".png",sep="")
ggsave(filename=dateiname, plot=p,width=8, height=4, dpi=100)
