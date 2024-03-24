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
