#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\n$($PSQL "TRUNCATE teams, games")"

echo -e "\n~~~~~ INSERT DATA IN TEAMS  TABLE~~~~~\n"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ -n $WINNER && $WINNER != winner || -n $OPPONENT && $OPPONENT != opponent ]]; # check if winner is not null
  then
    # echo the winner is $WINNER

    # check if team name is not in table before add it else continue

    # check if winner name exist in teams table

    echo -e "\n+-- Winner/Opponent : $($PSQL "SELECT name FROM teams WHERE name = '$WINNER'") / $($PSQL "SELECT name FROM teams WHERE name = '$OPPONENT'") --+"

    if [[ $($PSQL "SELECT name FROM teams WHERE name = '$WINNER'") ]]
    then
      echo '...'
    else
      # Insert into teams table team name
      INSERT_INTO_TEAMS="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
      if [[ $INSERT_INTO_TEAMS == "INSERT 0 1" ]]
      then
        echo -e "\n Insert into teams $WINNER"
      fi
    fi

    # check if opponent name exist in teams table

    if [[ $($PSQL "SELECT name FROM teams WHERE name = '$OPPONENT'") ]]
    then
      echo '...'
    else
      # Insert into teams table team name
      INSERT_INTO_TEAMS="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
      if [[ $INSERT_INTO_TEAMS == "INSERT 0 1" ]]
      then
        echo -e "\n Insert into teams $OPPONENT"
      fi
    fi
  fi
done

# insert data in games tables
echo -e "\n~~~~~ INSERT DATA IN GAMES TABLE ~~~~~\n"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

  # check if it's first query of data in games.csv file
  if [[ !($YEAR == year && $ROUND == round && $WINNER == winner && $OPPONENT == opponent && $WINNER_GOALS == winner_goals && $OPPONENT_GOALS == opponent_goals) ]]
  then
    # get winner_id and opponent_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

    #echo $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS
    #echo $WINNER_ID $OPPONENT_ID
    INSERT_INTO_GAMES="$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $WINNER_ID, $OPPONENT_ID)")"
    if [[ $INSERT_INTO_GAMES == "INSERT 0 1" ]]
    then
      echo Insert into games datas
    fi
  fi

done