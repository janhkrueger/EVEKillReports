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

emptyframe = data.frame(datum = numeric(0), anzahl = numeric(0));
newrow = data.frame(datum=1, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=2, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=3, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=4, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=5, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=6, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=7, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=8, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=9, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=10, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=11, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=12, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=13, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=14, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=15, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=16, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=17, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=18, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=19, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=20, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=21, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=22, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=23, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=24, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=25, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=26, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=27, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=28, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=29, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=30, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=31, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=32, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=33, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=34, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=35, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=36, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=37, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=38, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=39, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=40, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=41, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=42, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=43, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=44, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=45, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=46, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=47, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=48, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=49, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=50, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=51, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)
newrow = data.frame(datum=52, anzahl=0)
emptyframe <- rbind(emptyframe, newrow)

# print (emptyframe)


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

dat22852 <- merge(emptyframe, dat22852, all = TRUE)

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
dat23917 <- merge(emptyframe, dat23917, all = TRUE)

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
dat23919 <- merge(emptyframe, dat23919, all = TRUE)

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
dat23913 <- merge(emptyframe, dat23913, all = TRUE)

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
dateiname = paste("EVEData/charts/","Supercarrier_",runyear,".png",sep="")
ggsave(filename=dateiname, plot=p,width=8, height=4, dpi=100)
