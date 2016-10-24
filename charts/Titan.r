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

# Abfrage 23773
sql <- sprintf("
SELECT WEEK(kill_time) as datum, count(killID) as anzahl
FROM KR_participants PARTITION (p%s)
WHERE isVictim = 1
AND shipTypeID = 23773
AND YEAR(kill_time) = %s
AND WEEK(kill_time) != 0
AND WEEK(kill_time) != 53
#AND WEEK(kill_time) between 1 AND 6
GROUP BY WEEK(kill_time);", runyear, runyear)
rs <- dbSendQuery(con, sql)

# Ergebnisse laden und in interne Datenstruktur uebertragn
data <- fetch(rs,n=-1)   ## fetch all elements from the result set
dat23773 <- data.frame(
  anzahl <- data[1],
  datum <- data[2]
)

# Abfrage 3764
sql <- sprintf("
select *  
 from (
(SELECT 1 as datum, 0 as anzahl
FROM KR_participants PARTITION (p%s)
WHERE not exists (
SELECT 1
FROM KR_participants
WHERE isVictim = 1
AND shipTypeID = 3764
AND YEAR(kill_time) = %s
AND WEEK(kill_time) != 0
AND WEEK(kill_time) != 53
GROUP BY WEEK(kill_time)
) ) UNION
(SELECT WEEK(kill_time) as datum, count(killID) as anzahl
FROM KR_participants PARTITION (p%s)
WHERE isVictim = 1
AND shipTypeID = 3764
AND YEAR(kill_time) = %s
AND WEEK(kill_time) != 0
AND WEEK(kill_time) != 53
GROUP BY WEEK(kill_time)
)
) as CALDARI;", runyear, runyear, runyear, runyear)
rs <- dbSendQuery(con, sql)


# Ergebnisse laden und in interne Datenstruktur uebertragn
data <- fetch(rs,n=-1)   ## fetch all elements from the result set
dat3764 <- data.frame(
  anzahl <- data[1],
  datum <- data[2]
)

# Abfrage 11567
sql <- sprintf("
SELECT WEEK(kill_time) as datum, count(killID) as anzahl
FROM KR_participants PARTITION (p%s)
WHERE isVictim = 1
AND shipTypeID = 11567
AND YEAR(kill_time) = %s
AND WEEK(kill_time) != 0
AND WEEK(kill_time) != 53
#AND WEEK(kill_time) between 1 AND 6
GROUP BY WEEK(kill_time);", runyear, runyear)
rs <- dbSendQuery(con, sql)

# Ergebnisse laden und in interne Datenstruktur uebertragn
data <- fetch(rs,n=-1)   ## fetch all elements from the result set
dat11567 <- data.frame(
  anzahl <- data[1],
  datum <- data[2]
)

# Abfrage 671
sql <- sprintf("
SELECT WEEK(kill_time) as datum, count(killID) as anzahl
FROM KR_participants PARTITION (p%s)
WHERE isVictim = 1
AND shipTypeID = 671
AND YEAR(kill_time) = %s
AND WEEK(kill_time) != 0
AND WEEK(kill_time) != 53
#AND WEEK(kill_time) between 1 AND 6
GROUP BY WEEK(kill_time);", runyear, runyear)
rs <- dbSendQuery(con, sql)

# Ergebnisse laden und in interne Datenstruktur uebertragn
data <- fetch(rs,n=-1)   ## fetch all elements from the result set
dat671 <- data.frame(
  anzahl <- data[1],
  datum <- data[2]
)

cols <- c("Ragnarok"="red","Leviathan"="steelblue2","Avatar"="orange","Erebus"="aquamarine4")

graphtitle = paste("Titan ",runyear,sep="")

# Plotting all four into one
p <- ggplot() + 
  ggtitle(graphtitle) + 
  geom_line(data=dat23773, aes(x = datum, y = anzahl, colour="Ragnarok") ) + geom_point(data=dat23773, aes(x = datum, y = anzahl), size=1 ) +
  geom_line(data=dat3764, aes(x = datum, y = anzahl, colour="Leviathan") ) + geom_point(data=dat3764, aes(x = datum, y = anzahl), size=1 ) + 
  geom_line(data=dat11567, aes(x = datum, y = anzahl, colour="Avatar") ) + geom_point(data=dat11567, aes(x = datum, y = anzahl), size=1 ) + 
  geom_line(data=dat671, aes(x = datum, y = anzahl, colour="Erebus") ) + geom_point(data=dat671, aes(x = datum, y = anzahl), size=1 ) +
  # Setting the labels
  xlab("Week") +
  ylab("Losses") +
  scale_colour_manual(name="Titan",values=cols, guide = guide_legend(fill = NULL,colour = NULL) ) +
  theme( legend.position = "bottom") +
  theme_bw()

print (p)

# Now save the plot to a file
dateiname = paste("/var/games/KillReporter/EVEData/charts/","Titan_",runyear,".png",sep="")
ggsave(filename=dateiname, plot=p,width=8, height=4, dpi=100)
