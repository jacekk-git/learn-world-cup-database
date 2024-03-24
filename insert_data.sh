#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. 
# Use the PSQL variable above to query your database.
cat games.csv | cut -d"," -f3 > teams_dup.csv
cat games.csv | cut -d"," -f4 >> teams_dup.csv
sort -u teams_dup.csv | grep -v "winner" | grep -v "opponent" > teams.csv

rm -f teams_id.csv
#$($PSQL "TRUNCATE TABLE games, teams;")
$($PSQL "\copy teams(name) FROM 'teams.csv' DELIMITER ',' CSV;")
$($PSQL "\copy teams TO 'teams_id.csv' DELIMITER ',' CSV;")

rm -f games_new.csv
#python process_data.py 
python <<HEREDOC
import csv

teams = dict()
with open("teams_id.csv") as teams_file:
  csv_reader = csv.reader(teams_file, delimiter=',')
  for team in csv_reader:
    teams[team[1]] = team[0]

print(teams)

with open("games_new.csv", "w") as games_new:
  csv_writer = csv.writer(games_new)
  with open('games.csv') as games:
    csv_reader = csv.reader(games, delimiter=',')
    line_count = 0
    for row in csv_reader:
        if line_count > 0:
          row[2] = teams[row[2]]
          row[3] = teams[row[3]]
        csv_writer.writerow(row)
        line_count += 1
HEREDOC

$($PSQL "\copy games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) FROM 'games_new.csv' DELIMITER ',' CSV HEADER;")
