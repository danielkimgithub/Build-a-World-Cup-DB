#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

#empty the rows in the tables of the database so we can rerun the script
echo $($PSQL "truncate games, teams";)

# view the games.csv file using cat and apply a while loop to read row by row
cat games.csv | while IFS=',' read year round winner opponent winner_goals opponent_goals
do
  # INSERT DATA FOR TEAMS TABLE

  # GET WINNER TEAM NAME
  #exclude first row, containing column names
  if [[ $winner != "winner" ]]
  then
    # get team name
    win_team=$($PSQL "select name from teams where name='$winner';")

    #if team name is not found in the table, we need to include the new team to the table
    if [[ -z $win_team ]]
    then
      #insert new team into teams table
      insert_win_team=$($PSQL "insert into teams(name) values('$winner');")
      if [[ $insert_win_team = 'INSERT 0 1' ]]
      then
        #print confirmation that team was inserted
        echo Inserted into teams table $winner
      fi
    fi
  fi
  
  # GET OPPONENT TEAM NAME
  #exclude first row, containing column names
  if [[ $opponent != "opponent" ]]
  then
    # get team name
    opp_team=$($PSQL "select name from teams where name='$opponent';")

    #if team name is not found in the table, we need to include the new team to the table
    if [[ -z $opp_team ]]
    then
      #insert new team into teams table
      insert_opp_team=$($PSQL "insert into teams(name) values('$opponent')")
      if [[ $insert_opp_team = 'INSERT 0 1' ]]
      then
        #print confirmation that team was inserted
        echo Inserted into teams table $opponent
      fi
    fi
  fi
  
  # INSERT DATA INTO GAMES TABLE 
  if [[ $year != 'year' ]]
  then
    # GET WINNER_ID
    winner_id=$($PSQL "select team_id from teams where name='$winner';")

    # GET OPPONENT_ID
    opponent_id=$($PSQL "select team_id from teams where name='$opponent';")

    # insert new game information into games table
    insert_info=$($PSQL "insert into games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) values($year, '$round', $winner_goals, $opponent_goals, $winner_id, $opponent_id);")
    if [[ $insert_info = 'INSERT 0 1' ]]
    then
      #print confirmation that team was inserted
      echo New game recorded: $winner_id vs. $opponent_id Score: $winner_goals: $opponent_goals
    fi
  fi
done
