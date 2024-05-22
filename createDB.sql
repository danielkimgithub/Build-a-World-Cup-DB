-- create database
CREATE DATABASE worldcup;

-- connect to database
\c worldcup;

-- create table 'game' to store the games information
CREATE TABLE games (
    game_id serial PRIMARY KEY,
    year integer NOT NULL,
    round varchar(40) NOT NULL,
    winner_id integer NOT NULL,
    opponent_id integer NOT NULL,
    winner_goals integer NOT NULL,
    opponent_goals integer NOT NULL
);

-- create table 'teams' to store the teams information includes winners and opponents
CREATE TABLE teams (
    team_id serial PRIMARY KEY,
    name varchar(40) NOT NULL
);

-- add unique constraint on team names
ALTER TABLE teams
    ADD UNIQUE (name);

-- add foreign keys
ALTER TABLE games
    ADD FOREIGN KEY (opponent_id) 
	REFERENCES teams(team_id);

ALTER TABLE games
    ADD FOREIGN KEY (winner_id) 
	REFERENCES teams(team_id);

-- inserted data by running the script insert_data.sh
