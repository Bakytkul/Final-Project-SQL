-- 2.1 Средняя сумма чека, количество операций и клиентов по месяцам
WITH MonthlyStats AS (
    SELECT 
        DATE_FORMAT(T.Data_new, '%Y-%m') AS YearMonth,
        AVG(T.Sum_payment) AS AvgCheckMonth,
        COUNT(T.ID_check) AS TransactionsCount,
        COUNT(DISTINCT T.ID_client) AS ClientsCount,
        SUM(T.Sum_payment) AS TotalSumMonth
    FROM Transactions T
    WHERE T.Data_new BETWEEN '2015-06-01' AND '2016-06-01'
    GROUP BY YearMonth
),

-- 2.2 Общая сумма операций и количество за год
YearlyStats AS (
    SELECT 
        SUM(T.Sum_payment) AS TotalYearSum,
        COUNT(T.ID_check) AS TotalYearTransactions
    FROM Transactions T
    WHERE T.Data_new BETWEEN '2015-06-01' AND '2016-06-01'
)

-- 2.3 Выводим информацию по месяцам
SELECT 
    MS.YearMonth,
    MS.AvgCheckMonth,
    MS.TransactionsCount,
    MS.ClientsCount,
    (MS.TransactionsCount / YS.TotalYearTransactions) * 100 AS TransactionSharePercentage,
    (MS.TotalSumMonth / YS.TotalYearSum) * 100 AS SumSharePercentage
FROM MonthlyStats MS
CROSS JOIN YearlyStats YS;

-- 2.4 Соотношение полов (M/F/NA) и их доли затрат по месяцам
SELECT 
    DATE_FORMAT(T.Data_new, '%Y-%m') AS YearMonth,
    C.Gender,
    COUNT(T.ID_check) AS TransactionCount,
    SUM(T.Sum_payment) AS TotalSumGender,
    (SUM(T.Sum_payment) / (SELECT SUM(Sum_payment) 
                           FROM Transactions T 
                           WHERE T.Data_new BETWEEN '2015-06-01' AND '2016-06-01')) * 100 AS GenderSpendShare
FROM Transactions T
JOIN Customers C ON T.ID_client = C.ID_client
WHERE T.Data_new BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY YearMonth, C.Gender;
