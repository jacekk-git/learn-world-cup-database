drop table if exists games;
drop table if exists teams;

create table teams(
  team_id SERIAL NOT NULL,
  name VARCHAR(255) NOT NULL UNIQUE,
  PRIMARY KEY (team_id)
);

create table games(
  game_id SERIAL NOT NULL,
  year INt NOT NULL,
  round VARCHAR(255) NOT NULL,
  winner_id INT NOT NULL,
  opponent_id INT NOT NULL,
  winner_goals INT NOT NULL,
  opponent_goals INT NOT NULL,
  PRIMARY KEY (game_id),
  CONSTRAINT fk_winner
    FOREIGN KEY (winner_id)
      REFERENCES teams(team_id),
  CONSTRAINT fk_opponent
    FOREIGN KEY (opponent_id)
      REFERENCES teams(team_id)
);