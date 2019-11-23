--- Селект со сравнением

SELECT *
  FROM [dbSERVERS].[dbo].[S]
  WHERE Sram > 7
  ORDER BY Sram


--- BETWEEN

SELECT *
	FROM dbSERVERS.dbo.S
	WHERE Sram BETWEEN 4 AND 8

--- LIKE

SELECT *
	FROM dbSERVERS.dbo.U
	WHERE Uname LIKE '%Максим%'

--- IN с подзапросом

SELECT *
	FROM dbSERVERS.dbo.IPSU
	WHERE IPid IN
		(
			SELECT IPid
				FROM dbSERVERS.dbo.IP
				WHERE IPaddress LIKE '__.__.__.__'
		) 


--- EXISTS с подзапросом

SELECT *
	FROM dbSERVERS.dbo.S
	WHERE EXISTS
		(
			SELECT Sid
			FROM dbSERVERS.dbo.S
			WHERE Sgraphics LIKE '%GTX%'
		)


--- Предикат сравнения с квантором

SELECT *
	FROM dbSERVERS.dbo.S
	WHERE Sram >= ALL
		(
			SELECT Sram
				FROM dbSERVERS.dbo.S
				WHERE Sgraphics LIKE '%GTX580%'
		)



--- Агрегатные ф-ции в столбцах
SELECT AVG(TotalRam) AS 'Ram AVG'
	FROM 
		(
			SELECT Sid, SUM(Sram) AS TotalRam
			FROM dbSERVERS.dbo.S
			GROUP BY Sid
		)
	AS TotS

--- Скалярные подзапросы в столбцах

SELECT Sid, Sram, 
	(
		SELECT AVG(Sram)
		FROM dbSERVERS.dbo.S
	) AS RamAvg,
	(
		SELECT MIN(Sram)
		FROM dbSERVERS.dbo.S
	) AS MinRam,
	Sgraphics
	FROM dbSERVERS.dbo.S


--- Simple CASE


SELECT Sgraphics,
	CASE Sgraphics
		WHEN 'GTX1080Ti' THEN 'DABEST'
		WHEN 'GTX580' THEN '2weak'
		ELSE 'Common'
	END AS 'GraphQuality'
FROM dbSERVERS.dbo.S


-- Search CASE

SELECT Sgraphics,
	CASE
		WHEN Sgraphics LIKE '%Ti' THEN 'Titanka'
		WHEN Sgraphics LIKE '%Ti' AND Sram <> 4 THEN 'Bullshit'
		ELSE 'NotInteresting'
	END AS Stupidity
FROM dbSERVERS.dbo.S

-- New Local

SELECT Sid,
	(
		SELECT MAX(Sram)
		FROM dbSERVERS.dbo.S
	) AS RAM,
	(
		SELECT MAX(Sgraphics)
		FROM dbSERVERS.dbo.S
		WHERE Sgraphics <> 'GTX1080Ti'
	) AS GrCard
INTO #BestServers2
FROM dbSERVERS.dbo.S
GROUP BY Sid

SELECT * FROM #BestServers2


-- Коррелированные подзапросы в фром

SELECT *
	FROM dbSERVERS.dbo.S P JOIN
	(
		SELECT TOP 5 Sid, SUM(Sram) AS SS
		FROM dbSERVERS.dbo.S
		Group BY Sid
		ORDER BY SS DESC
	) AS OD ON OD.Sid = P.Sid



-- 3-влож

SELECT *
FROM dbSERVERS.dbo.S
WHERE Sid IN
	(
		SELECT Sid
		FROM dbSERVERS.dbo.IPSU
		WHERE Uid IN
			(
				SELECT Uid
				FROM dbSERVERS.dbo.U
				WHERE Uid IN
					(
						SELECT Uid
						FROM dbSERVERS.dbo.U
						WHERE Uname LIKE '%Максим%'
					) AND Uname LIKE '%А%'
			)
	)


--- group by - having

SELECT A.Sid,
		A.Sram,
		AVG(B.SS) AS AvgRam,
		A.Sgraphics
FROM dbSERVERS.dbo.S A JOIN
	(
		SELECT Sid, SUM(Sram) AS SS
		FROM dbSERVERS.dbo.S
		Group BY Sid
	) B ON B.Sid = A.Sid
GROUP BY A.Sid, A.Sram, A.Sgraphics


--- group by + having


SELECT Sid, AVG(Sram) AS 'AvgRam'
FROM dbSERVERS.dbo.S A
GROUP BY Sid
HAVING AVG(Sram) >
	(	
		SELECT AVG(Sram) AS AvgR
		From dbSERVERS.dbo.S
	)


--- just insert

INSERT dbSERVERS.dbo.IP (IPaddress, Status) VALUES ('192.168.0.1', 1)

--- big insert

INSERT dbSERVERS.dbo.S (Sram, Sgraphics)
SELECT 
(
	SELECT MAX(Sram)
	FROM dbSERVERS.dbo.S
	WHERE Sgraphics LIKE '%Ti%'
), Sgraphics
FROM dbSERVERS.dbo.S
WHERE Sram > 5

--- Update

UPDATE dbSERVERS.dbo.IP
SET IPaddress = '127.0.0.1'
WHERE IPid = 1

--- Update + запрос

UPDATE dbSERVERS.dbo.S
SET Sram = 
	(
		SELECT AVG(Sram)
		FROM dbSERVERS.dbo.S
	)
Where Sid = 1

--- DELETE

DELETE dbSERVERS.dbo.IPSU
WHERE scan = 'Botnet'

--- DELETE с подзапросом

DELETE dbSERVERS.dbo.IPSU
WHERE Sid IN
(
	SELECT A.Sid
	FROM
	(
		SELECT Sid
		FROM dbSERVERS.dbo.IPSU
		WHERE scan = 'Mining'
	) A
	JOIN
	(
		SELECT Sid
		FROM dbSERVERS.dbo.IPSU
		WHERE IPid BETWEEN 100 AND 300
	) B
	ON A.Sid = B.Sid
)

--- SELECT OTV

WITH CTE(a,b)
AS
(
	SELECT Sid, Sgraphics
	FROM dbSERVERS.dbo.S
	WHERE Sgraphics = 'GTX1080Ti'
)
SELECT a AS 'allrtx'
FROM CTE


--- Rec OTV

CREATE TABLE dbo.Example
(
	SomeID smallint NOT NULL,
	MoreID int NULL,
	SomeNumber int
	CONSTRAINT PK_SomeID PRIMARY KEY CLUSTERED (SomeID ASC)
);
GO

INSERT dbo.Example VALUES(6,2,355);
GO

WITH RecOTV(MoreID, SomeID, SomeNumber, Level)
AS
(
	SELECT e.MoreID, e.SomeID, e.SomeNumber, 0 AS Level
	FROM dbo.Example AS e
	WHERE MoreID IS NULL
	UNION ALL

	SELECT e.MoreID, e.SomeID, e.SomeNumber, Level + 1
	FROM dbo.Example AS e INNER JOIN RecOTV AS d ON e.MoreID = d.SomeID
	)

Select MoreID, SomeID, SomeNumber, level
FROM RecOTV;


--- OVER

SELECT A.Sid,
		A.Sram,
		A.Sgraphics,
		AVG(A.Sram) OVER(PARTITION BY A.Sid, A.Sgraphics) AS AvgRam,
		MIN(A.Sram) OVER(PARTITION BY A.Sid, A.Sgraphics) AS MinRam,
		MAX(A.Sram) OVER(PARTITION BY A.Sid, A.Sgraphics) AS MaxRam
FROM dbo.S A LEFT OUTER JOIN dbo.IPSU B ON B.Sid = A.Sid

--- ROW_NUMBER

create table #tmp (ID int, Ramtemp int, TempG nvarchar(50))
GO

insert #tmp (ID, Ramtemp, TempG)

select *
from dbo.S
go

select * from #tmp
order by ID
GO


select *
	from (
		SELECT ID, Ramtemp, TempG, 
		ROW_NUMBER() OVER
			(	
				PARTITION BY ID, Ramtemp, TempG
				ORDER BY ID
			) as uniqchk
		FROM #tmp
		) as A
WHERE A.uniqchk = 1
