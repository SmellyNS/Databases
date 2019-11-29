-- CLR on

EXEC sp_configure 'clr enabled', 1;  
RECONFIGURE;  
GO  


-- Scalar CLR

CREATE ASSEMBLY scalar FROM 'C:\Users\GTAO\git\Databases\lab04\cs\scalar.dll';  
GO  


CREATE FUNCTION CountIP() RETURNS INT   
AS EXTERNAL NAME scalar.T.ret;   
GO  
  
SELECT dbo.CountIP();  
GO  


drop function CountIP
drop assembly scalar



-- Agr CLR


CREATE ASSEMBLY Mult FROM 'C:\Users\GTAO\git\Databases\lab04\cs\Mult.dll';  
GO
CREATE AGGREGATE Mult (@input int) RETURNS int 
EXTERNAL NAME Mult.Mult;  


drop aggregate Mult
drop assembly Mult

CREATE TYPE MyTableType AS table (ItemValue int);  
go  

DECLARE @myTable AS MyTableType;  
  
INSERT INTO @myTable values(2),(3),(4);  
  
SELECT dbo.Mult(A.Sram) from (select Sram from S) as A;  
go  
select Sid from S where Sram = 0