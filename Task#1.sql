SELECT * FROM Final_Project_SQL.Transactions;
SELECT COUNT(*) 
FROM Transactions;


-- 1.1 Создаем список месяцев в заданном периоде
WITH AllMonths AS (
    SELECT DATE_FORMAT('2015-06-01' + INTERVAL m MONTH, '%Y-%m') AS YearMonth
    FROM (SELECT 0 AS m UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL 
                 SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL 
                 SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL 
                 SELECT 9 UNION ALL SELECT 10 UNION ALL SELECT 11) AS months
),

-- 1.2 Группируем транзакции клиентов по месяцам
ClientMonthlyTransactions AS (
    SELECT
        T.ID_client,
        DATE_FORMAT(T.Data_new, '%Y-%m') AS YearMonth,  
        AVG(T.Sum_payment) AS AvgCheckMonth,             
        COUNT(T.ID_check) AS TransactionsCount
    FROM Transactions T
    WHERE T.Data_new BETWEEN '2015-06-01' AND '2016-06-01'
    GROUP BY T.ID_client, YearMonth
),

-- 1.3 Проверяем наличие непрерывной истории (12 месяцев) для каждого клиента
ClientContinuousHistory AS (
    SELECT 
        CM.ID_client,
        COUNT(DISTINCT CM.YearMonth) AS MonthsWithTransactions,
        AVG(CM.AvgCheckMonth) AS AvgCheckPeriod,
        SUM(CM.TransactionsCount) AS TotalTransactions
    FROM ClientMonthlyTransactions CM
    RIGHT JOIN AllMonths AM ON CM.YearMonth = AM.YearMonth
    GROUP BY CM.ID_client
    HAVING MonthsWithTransactions = 12  -- Только клиенты с транзакциями в каждом месяце
)

-- 1.4 Выводим информацию о клиентах с непрерывной историей
SELECT 
    C.ID_client,
    C.Total_amount,
    C.Gender,
    C.Age,
    C.Count_city,
    C.Response_communcation,
    C.Communication_3month,
    C.Tenure,
    CH.AvgCheckPeriod, 
    CH.TotalTransactions
FROM ClientContinuousHistory CH
JOIN Customers C ON CH.ID_client = C.ID_client;
