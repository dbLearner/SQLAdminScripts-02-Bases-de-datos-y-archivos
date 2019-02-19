ExecuteSql('Numeric', '-- Variable Declarations 
DECLARE @PreviousDate datetime 
DECLARE @Year VARCHAR(4) 
DECLARE @Month VARCHAR(2) 
DECLARE @MonthPre VARCHAR(2) 
DECLARE @Day VARCHAR(2) 
DECLARE @DayPre VARCHAR(2) 
DECLARE @FinalDate INT 
-- Initialize Variables 
SET @PreviousDate = DATEADD(dd, -1, GETDATE()) -- Last day 
SET @Year = DATEPART(yyyy, @PreviousDate)  
SELECT @MonthPre = CONVERT(VARCHAR(2), DATEPART(mm, @PreviousDate)) 
SELECT @Month = RIGHT(CONVERT(VARCHAR, (@MonthPre + 1000000000)),2) 
SELECT @DayPre = CONVERT(VARCHAR(2), DATEPART(dd, @PreviousDate)) 
SELECT @Day = RIGHT(CONVERT(VARCHAR, (@DayPre + 1000000000)),2) 
SET @FinalDate = CAST(@Year + @Month + @Day AS INT) 
-- Count failed jobs within last day
SELECT  COUNT(*) 
FROM     msdb.dbo.sysjobhistory h 
         INNER JOIN msdb.dbo.sysjobs j 
           ON h.job_id = j.job_id 
         INNER JOIN msdb.dbo.sysjobsteps s 
           ON j.job_id = s.job_id
         INNER JOIN ( SELECT job_id, max(instance_id) maxinstanceid 
   FROM msdb..sysjobhistory 
          WHERE run_status <> 1
   GROUP BY job_id) a ON h.job_id = a.job_id 
            AND h.instance_id = a.maxinstanceid 
WHERE    h.run_status = 0 -- Failure 
         AND h.run_date > @FinalDate')
