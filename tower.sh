rm toaster_shiplist.json
cp tower.json toaster_shiplist.json
python KillReporter.py $1 $2 $3

# Entsorgen
rm /var/games/KillReporter/zkb.pyc        
rm /var/games/KillReporter/zkb.log        
rm /var/games/KillReporter/zkb_result.json
