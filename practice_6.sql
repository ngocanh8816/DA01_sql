-- CÂU 1:
SELECT
COUNT(*)
FROM
(
SELECT 
company_id,
COUNT(job_id) AS NUMBER_OF_JOBS
FROM job_listings
GROUP BY company_id, title, description
HAVING COUNT(job_id) > 1
) COUNT_JOB

--CÂU 2:

--CÂU 3:
SELECT
COUNT(*)
FROM
(
SELECT
policy_holder_id,
COUNT(case_id) COUNT_CALL
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id) >= 3
) COUNT_CALL

--CÂU 4:
SELECT
A.page_id
FROM pages A
LEFT JOIN page_likes B ON A.page_id = B.page_id
WHERE B.page_id IS NULL
ORDER BY A.page_id

--CÂU 5:
























