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
 
SELECT dbo.Mult(A.Sram) from (select TOP(5) Sram from S) as A;  

drop aggregate Mult
drop assembly Mult
go

-- Table CLR

CREATE ASSEMBLY interval FROM 'C:\Users\GTAO\git\Databases\lab04\cs\table.dll';  
GO

create function dbo.interval(@a int)
returns table (ID int)
as
external name interval.[pow2.TableValuedFunction].GenerateInterval
go

select * from dbo.interval(20)

drop function interval
drop assembly interval



-- proc CLR

CREATE ASSEMBLY sumramproc FROM 'C:\Users\GTAO\git\Databases\lab04\cs\proc.dll';  
GO

CREATE PROCEDURE RamSum (@sum int OUTPUT)  
AS EXTERNAL NAME sumramproc.StoredProcedures.RamSum
Go

declare @rets int
exec RamSum @rets output
select @rets


-- trigger CLR


CREATE ASSEMBLY sometrigger FROM 'C:\Users\GTAO\git\Databases\lab04\cs\trigger.dll';  
GO


create trigger think on U instead of delete as
EXTERNAL NAME sometrigger.CLRTriggers.DropTableTrigger
go


delete from U where Uid = 1

select * from U where Uid = 1


drop trigger think
drop assembly sometrigger



-- type CLR

CREATE ASSEMBLY point FROM 'C:\Users\GTAO\git\Databases\lab04\cs\type.dll';  
GO

CREATE TYPE Point   
EXTERNAL NAME point.[Point];  




-- type test
CREATE TABLE dbo.Points 
( 
  id INT IDENTITY(1,1) NOT NULL, 
  point Point NULL 
);
GO

INSERT INTO dbo.Points(point) 
VALUES('0,0'),
	  ('1,1'),
	  ('1,5'),
	  ('5,6')
GO

select point.ToString() from Points