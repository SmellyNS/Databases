use dbSERVERS
go



-- FIRST --

declare @temp nvarchar(4000)
set @temp =
(SELECT IPid AS [FK.IPid], Sid AS [FK.Sid], Uid AS [FK.Uid],
       scan AS scan
FROM IPSU
FOR JSON PATH, ROOT('ServersUsingInfo'))

select @temp



-- SECOND --

declare @temp2 nvarchar(4000)
set @temp2 = (
SELECT * FROM OPENROWSET(BULK N'C:\Users\Dmitry\git\Databases\lab05\data.json', SINGLE_CLOB) AS Contents
)
select @temp2


SELECT *
FROM OPENJSON(@temp2, N'$.Something')
WITH (
    firstch      VARCHAR(200)    N'$.firstparent.hischild',
    firstdate        DATETIME        N'$.firstparent.date',
    secondch    VARCHAR(200)    N'$.secondparent.hischild',
    seconddate    DATETIME        N'$.secondparent.date'
)
