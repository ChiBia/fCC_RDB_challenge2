#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# takes team names from games.csv, test if present in db and if not insert it
cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $year != 'year' ]]
  then
    team_id=$($PSQL "SELECT team_id from teams where name = '$winner' ")
    # if winner not found
    if [[ -z $team_id ]]
    then 
      insert_winner=$($PSQL "INSERT INTO teams(name) VALUES('$winner') ")      
    fi
    team_id=$($PSQL "SELECT team_id from teams where name = '$opponent' ")
    # if opponent not found
    if [[ -z $team_id ]]
    then 
      insert_opponent=$($PSQL "INSERT INTO teams(name) VALUES('$opponent') ")      
    fi
    
    # takes team names select team_id and insert line into table
    winner_id=$($PSQL "SELECT team_id from teams where name = '$winner' ")
    opponent_id=$($PSQL "SELECT team_id from teams where name = '$opponent' ")
    insert_game=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals) ")
  
  fi
done
