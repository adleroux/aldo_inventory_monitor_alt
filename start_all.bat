@echo off

echo Starting Rails server...
start rails server


echo Starting websocketd...
start bin/websocketd --port=8080 ruby lib/inventory_loading_random.rb

echo All services started.
pause
