DROP TABLE game_sales;

CREATE TABLE game_sales (
  game VARCHAR(100) PRIMARY KEY,
  platform VARCHAR(64),
  publisher VARCHAR(64),
  developer VARCHAR(64),
  games_sold NUMERIC(5, 2),
  year INT
);

DROP TABLE reviews;

CREATE TABLE reviews (
    game VARCHAR(100) PRIMARY KEY,
    critic_score NUMERIC(4, 2),   
    user_score NUMERIC(4, 2)
);

DROP TABLE top_critic_years;

CREATE TABLE top_critic_years (
    year INT PRIMARY KEY,
    avg_critic_score NUMERIC(4, 2)  
);

DROP TABLE top_critic_years_more_than_four_games;

CREATE TABLE top_critic_years_more_than_four_games (
    year INT PRIMARY KEY,
    num_games INT,
    avg_critic_score NUMERIC(4, 2)  
);

DROP TABLE top_user_years_more_than_four_games;

CREATE TABLE top_user_years_more_than_four_games (
    year INT PRIMARY KEY,
    num_games INT,
    avg_user_score NUMERIC(4, 2)  
);

\copy game_sales FROM 'game_sales.csv' DELIMITER ',' CSV HEADER;
\copy reviews FROM 'game_reviews.csv' DELIMITER ',' CSV HEADER;
\copy top_critic_years FROM 'top_critic_scores.csv' DELIMITER ',' CSV HEADER;
\copy top_critic_years_more_than_four_games FROM 'top_critic_scores_more_than_four_games.csv' DELIMITER ',' CSV HEADER;
\copy top_user_years_more_than_four_games FROM 'top_user_scores_more_than_four_games.csv' DELIMITER ',' CSV HEADER;



SELECT COUNT(game_sales.name)
FROM game_sales LEFT JOIN [dbo].[game_reviews]
ON game_sales.name = [dbo].[game_reviews].name
WHERE [dbo].[game_reviews].critic_score is null and [dbo].[game_reviews].user_score is null 


SELECT year , ROUND(AVG(critic_score) , 2) AS avg_critic_score
FROM game_sales join [dbo].[game_reviews]
on game_sales.name = [dbo].[game_reviews].name
GROUP BY  year
ORDER BY avg_critic_score DESC
