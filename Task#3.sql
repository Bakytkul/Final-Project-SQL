-- 3.1 Группировка клиентов по возрастным группам с шагом в 10 лет
WITH AgeGroups AS (
    SELECT
        C.ID_client,
        CASE 
            WHEN C.Age IS NULL THEN 'Unknown'
            WHEN C.Age BETWEEN 0 AND 9 THEN '0-9'
            WHEN C.Age BETWEEN 10 AND 19 THEN '10-19'
            WHEN C.Age BETWEEN 20 AND 29 THEN '20-29'
            WHEN C.Age BETWEEN 30 AND 39 THEN '30-39'
            WHEN C.Age BETWEEN 40 AND 49 THEN '40-49'
            WHEN C.Age BETWEEN 50 AND 59 THEN '50-59'
            ELSE '60+'
        END AS AgeGroup
    FROM Customers C
),

-- 3.2 Группировка по кварталам
QuarterlyStats AS (
    SELECT 
        DATE_FORMAT(T.Data_new, '%Y-%Q') AS Quarter,
        AG.AgeGroup,
        SUM(T.Sum_payment) AS TotalSum,
        COUNT(T.ID_check) AS TotalTransactions
    FROM Transactions T
    JOIN AgeGroups AG ON T.ID_client = AG.ID_client
    WHERE T.Data_new BETWEEN '2015-06-01' AND '2016-06-01'
    GROUP BY Quarter, AG.AgeGroup
)

-- 3.3 Выводим данные по возрастным группам и кварталам
SELECT 
    QS.Quarter,
    QS.AgeGroup,
    QS.TotalSum,
    QS.TotalTransactions,
    (QS.TotalSum / (SELECT SUM(Sum_payment) 
                    FROM Transactions 
                    WHERE Data_new BETWEEN '2015-06-01' AND '2016-06-01')) * 100 AS SumSharePercentage,
    (QS.TotalTransactions / (SELECT COUNT(ID_check) 
                             FROM Transactions 
                             WHERE Data_new BETWEEN '2015-06-01' AND '2016-06-01')) * 100 AS TransactionsSharePercentage
FROM QuarterlyStats QS;
