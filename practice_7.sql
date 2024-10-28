--EX1:
WITH CTE_A AS
(
SELECT
EXTRACT(YEAR FROM transaction_date) AS YEAR,
product_id,
SUM(spend) AS CURR_YEAR_SPEND
FROM user_transactions
GROUP BY EXTRACT(YEAR FROM transaction_date), product_id
)
SELECT *,
LAG(CURR_YEAR_SPEND) OVER (PARTITION BY product_id ORDER BY YEAR) AS PREV_YEAR_SPEND,
ROUND((CURR_YEAR_SPEND-LAG(CURR_YEAR_SPEND) OVER (PARTITION BY product_id ORDER BY YEAR))/LAG(CURR_YEAR_SPEND) OVER (PARTITION BY product_id ORDER BY YEAR)*100,2) AS YOY_RATE
FROM CTE_A

--EX2:
SELECT
DISTINCT(card_name),
FIRST_VALUE(issued_amount) OVER (PARTITION BY card_name ORDER BY issue_year, issue_month) AS issued_amount
FROM monthly_cards_issued
ORDER BY FIRST_VALUE(issued_amount) OVER (PARTITION BY card_name ORDER BY issue_year, issue_month) DESC

--EX3:
--CÁCH 1:
WITH CTE_A AS
(
SELECT *,
ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_date) AS STT
FROM transactions
)
SELECT
user_id, spend, transaction_date
FROM CTE_A
WHERE STT = 3

--CÁCH 2:
WITH CTE_A AS
(
SELECT *,
LEAD(transaction_date,2) OVER (PARTITION BY user_id ORDER BY transaction_date) AS third_date,
LEAD(spend,2) OVER (PARTITION BY user_id ORDER BY transaction_date) AS third_spend
FROM transactions
),

CTE_B AS
(
SELECT
user_id,
third_spend AS spend,
third_date AS transaction_date,
FIRST_VALUE(third_spend) OVER (PARTITION BY user_id)
FROM CTE_A
)

SELECT
user_id, spend, transaction_date
FROM CTE_B
WHERE spend = first_value

--EX4:
WITH CTE_A AS
(
SELECT
transaction_date,
user_id,
COUNT(product_id) AS purchase_count
FROM user_transactions
GROUP BY transaction_date, user_id
),
CTE_B AS
(
SELECT*,
ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_date DESC) AS STT
FROM CTE_A
)
SELECT
transaction_date,
user_id,
purchase_count
FROM CTE_B
WHERE STT = 1
ORDER BY transaction_date, user_id

--EX5:
SELECT
user_id,
tweet_date,
ROUND(AVG(tweet_count) OVER (PARTITION BY user_id ORDER BY tweet_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS rolling_avg_3d
FROM tweets

--EX6:
WITH CTE_A AS
(
SELECT
merchant_id,
credit_card_id,
amount,
transaction_timestamp,
LAG(transaction_timestamp) OVER (PARTITION BY merchant_id, credit_card_id, amount ORDER BY transaction_timestamp) AS PREV_TRANS_TIME,
EXTRACT(MINUTES FROM transaction_timestamp - LAG(transaction_timestamp) OVER (PARTITION BY merchant_id, credit_card_id, amount ORDER BY transaction_timestamp)) AS DIFF
FROM transactions
)
SELECT
COUNT(*) AS payment_count
FROM CTE_A
WHERE DIFF < 10

--EX7:
WITH CTE_A AS
(
SELECT
category, product,
SUM(spend) AS total_spend,
RANK() OVER (PARTITION BY category ORDER BY SUM(spend) DESC) AS RANKING
FROM product_spend 
WHERE EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY category, product
)
SELECT
category, product, total_spend
FROM CTE_A
WHERE RANKING IN (1,2)

--EX8:
WITH CTE_A AS
(
SELECT
artist_name,
COUNT(rank) OVER (PARTITION BY artist_name) AS COUNT_APPEARANCE
FROM artists A 
JOIN songs AS B ON A.artist_id = B.artist_id
JOIN global_song_rank C ON B.song_id = C.song_id
),
CTE_B AS
(
SELECT *,
DENSE_RANK() OVER (ORDER BY count_appearance DESC) AS artist_rank
FROM CTE_A
),
CTE_C AS
(
SELECT artist_name, artist_rank
FROM CTE_B
WHERE artist_rank <= 5
ORDER BY artist_name
)
SELECT DISTINCT(artist_name, artist_rank)
FROM CTE_C
