BULK INSERT [dbSERVERS].[dbo].[IP]
FROM 'C:\Users\Dmitry\git\Databases\lab02\Data\ip.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = '\t', ROWTERMINATOR =
'\n', CHECK_CONSTRAINTS);
GO
BULK INSERT [dbSERVERS].[dbo].[S]
FROM 'C:\Users\Dmitry\git\Databases\lab02\Data\servers.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = '\t', ROWTERMINATOR =
'\n', CHECK_CONSTRAINTS);
GO
BULK INSERT [dbSERVERS].[dbo].[U]
FROM 'C:\Users\Dmitry\git\Databases\lab02\Data\users.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = '\t', ROWTERMINATOR =
'\n', CHECK_CONSTRAINTS);
GO
BULK INSERT [dbSERVERS].[dbo].[IPSU]
FROM 'C:\Users\Dmitry\git\Databases\lab02\Data\reg.txt'
WITH (CODEPAGE = 'ACP', DATAFILETYPE = 'char', FIELDTERMINATOR = '\t', ROWTERMINATOR =
'\n');
GO



SELECT * FROM dbSERVERS.dbo.U