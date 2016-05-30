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
library(lubridate)

# Laden der externen Konfigurationsdatei
config = yaml.load_file("KillReports.yaml")

# Aufbau der Datenbankverbindung
con <- dbConnect(MySQL(),
                 user=config$db$user, password=config$db$pass,
                 dbname=config$db$name, host=config$db$host)
# Finally: Bei Beenden die Verbindung automatisch schliessen
on.exit(dbDisconnect(con))


# Letzten Monat ermitteln
jetzt <- currentDate<-Sys.Date()
jetzt <- as.Date(format( jetzt , "%Y-%m-01"))
letzterMonat <- as.Date( jetzt ) - months(1)

jahr = strtoi(format( letzterMonat , "%Y"))
monat = strtoi(format( letzterMonat , "%m"))

# Abfrage 24483
query <- paste ("SELECT WEEK(kill_time) as datum, count(killID) as anzahl
FROM KR_participants
WHERE isVictim = 1
AND shipTypeID = 24483
AND YEAR(kill_time) = ", jahr, "
AND MONTH(kill_time) = ", monat, "
AND WEEK(kill_time) != 0
AND WEEK(kill_time) != 53
GROUP BY WEEK(kill_time)
")
rs <- dbSendQuery(con, query)
# Ergebnisse laden und in interne Datenstruktur uebertragn
data <- fetch(rs,n=-1)   ## fetch all elements from the result set
dat24483 <- data.frame(
  anzahl <- data[1],
  datum <- data[2]
)

# Abfrage 23915
query <- paste ("SELECT WEEK(kill_time) as datum, count(killID) as anzahl
FROM KR_participants
WHERE isVictim = 1
AND shipTypeID = 23915
AND YEAR(kill_time) = ", jahr, "
AND MONTH(kill_time) = ", monat, "
AND WEEK(kill_time) != 0
AND WEEK(kill_time) != 53
GROUP BY WEEK(kill_time)
")
rs <- dbSendQuery(con, query)

# Ergebnisse laden und in interne Datenstruktur uebertragn
data <- fetch(rs,n=-1)   ## fetch all elements from the result set
dat23915 <- data.frame(
  anzahl <- data[1],
  datum <- data[2]
)

# Abfrage 23757
query <- paste ("SELECT WEEK(kill_time) as datum, count(killID) as anzahl
FROM KR_participants
WHERE isVictim = 1
AND shipTypeID = 23757
AND YEAR(kill_time) = ", jahr, "
AND MONTH(kill_time) = ", monat, "
AND WEEK(kill_time) != 0
AND WEEK(kill_time) != 53
GROUP BY WEEK(kill_time)
")
rs <- dbSendQuery(con, query)

# Ergebnisse laden und in interne Datenstruktur uebertragn
data <- fetch(rs,n=-1)   ## fetch all elements from the result set
dat23757 <- data.frame(
  anzahl <- data[1],
  datum <- data[2]
)

# Abfrage 23911
query <- paste ("SELECT WEEK(kill_time) as datum, count(killID) as anzahl
FROM KR_participants
WHERE isVictim = 1
AND shipTypeID = 23911
AND YEAR(kill_time) = ", jahr, "
AND MONTH(kill_time) = ", monat, "
AND WEEK(kill_time) != 0
AND WEEK(kill_time) != 53
GROUP BY WEEK(kill_time)
")
rs <- dbSendQuery(con, query)

# Ergebnisse laden und in interne Datenstruktur uebertragn
data <- fetch(rs,n=-1)   ## fetch all elements from the result set
dat23911 <- data.frame(
  anzahl <- data[1],
  datum <- data[2]
)


cols <- c("Nidhoggur"="red","Chimera"="blue","Archon"="orange","Thanatos"="green")

# Plotting all four into one
p <- ggplot() + 
  ggtitle("Carrier Last Month") + 
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
ggsave(filename="EVEData/charts/CarrierLastMonth.png", plot=p,width=8, height=4, dpi=100)
