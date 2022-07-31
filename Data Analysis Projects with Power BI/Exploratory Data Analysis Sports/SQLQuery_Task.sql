--Find Num of Win for each team 
select winner , count(*) as count 
from matches
--where season between 2012 and 2019
group by winner
order by count desc;


--Find Num of player of match for each player 
select player_of_match , count(*) as count 
from matches
--where season between 2012 and 2019
group by player_of_match
order by  count desc ;


--find sum of Total_run for each taem
select batting_team as team_name, sum(total_runs) as total_runs
from deliveries
group by batting_team
order by sum(total_runs) desc;







