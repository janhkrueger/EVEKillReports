#!/bin/bash

# Select Startyear and calculate the current year
START=2015
JETZT="$(date "+%Y")"

# Now generate all charts from startyear to current year
for ((i=$START;i<=$JETZT;i++));
do
   ./$i.sh
done

## Und nun alles in GDrive hochladen
../gdrivesync.sh
