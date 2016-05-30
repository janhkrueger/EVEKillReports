#!/bin/bash
#
# testpid.sh - demo script to show how to check if a script
# with the same name is currently running
#
# by Leo Eibler
# resources:
#    http://www.eibler.at
#    http://leo.sprossenwanne.at
#    http://www.nullpointer.at
#

#!/bin/bash
# check, if script is already running
SCRIPTNAME='basename $0'
LOCKFILENAME="/var/lock/KillReporter/`basename $0`"
if [ -z "$FLOCK_SET" ] ; then
exec env FLOCK_SET=1 flock -n "${LOCKFILENAME}" "$0" "$@"
fi

for i in {100..400}
do
  python loadKillMailsSingle.py
done

rm ${LOCKFILENAME}
