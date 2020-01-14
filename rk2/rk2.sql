use master
go

create database rk2;
use rk2
go

create table drivers(
    Did int identity(1,1) not null,
    Dname varchar(50) not null,
    Dbirth date not null,
    Dexp int null,
    Dphone varchar(20) null,
	primary key (Did)
);


create table car(
    Cid int identity(1,1) not null,
    Cname varchar(50) not null,
    Cnum varchar(10) not null,
    Ccolor varchar(20) null,
	Did int references drivers(Did) 
);


create table race(
    Rid int identity(1,1) not null,
    Rdate date not null,
    Raddr1 varchar(50) not null,
    Raddr2 varchar(50) not null,
    Rcargo varchar(50) null,
	Did int references drivers(Did) 	
);
go

insert drivers values ('����', '01.01.1980', 1, '89154570400')
insert drivers values ('������', '02.01.1980', 2, '89154570401')
insert drivers values ('�������', '03.01.1980', 3, '89154570402')
insert drivers values ('�������', '04.01.1980', 4, '89154570403')
insert drivers values ('�������', '05.01.1980', 5, '89154570404')
insert drivers values ('���������', '06.01.1980', 6, '89154570405')
insert drivers values ('������', '07.01.1980', 7, '89154570406')
insert drivers values ('������', '08.01.1980', 8, '89154570407')
insert drivers values ('��', '09.01.1980', 90, '89154570408')
insert drivers values ('���������', '10.01.1980', 9, '89154570409')

insert car values ('Honda','V761MK','Red',1)
insert car values ('Chevrolet','V762MK','Red',2)
insert car values ('Toyota','V763MK','Red',3)
insert car values ('Dodge','V764MK','Blue',4)
insert car values ('Ford','V765MK','Blue',5)
insert car values ('Lamborghini','V766MK','Blue',6)
insert car values ('Opel','V767MK','Yellow',7)
insert car values ('Lada','V768MK','Yellow',8)
insert car values ('Citroen','V769MK','Yellow',9)
insert car values ('VAZ','V760MK','Cyan',10)

insert race values ('01.01.2019','� ���������','��� �������','������ ����',1)
insert race values ('02.01.2019','� ���������','��� �������','���������� ����',2)
insert race values ('03.01.2019','� ���������','��� ������','������� ����',3)
insert race values ('04.01.2019','� ���������','��� ���������','������� ����',4)
insert race values ('05.01.2019','� ���������','��� �����','���������� ����',5)
insert race values ('06.01.2019','� ��������','��� ������','������ ����',6)
insert race values ('07.01.2019','� ������������','�����','����� �������� �������',7)
insert race values ('08.01.2019','� ���������','��� ���������','���� ������� � �������',8)
insert race values ('09.01.2019','� �������������','�� ���������','���������� ����',9)
insert race values ('10.01.2019','�� ������','�� ��� �������','������� ����',10)

--2)

-- SELECT + CASE (������� �������� ������� � ����������� �� ������ ����������)

SELECT CASE Raddr2
		WHEN '�����' THEN '�������'
		WHEN '�� ��� �������' THEN '�� � �������'
		ELSE 'Common'
	END AS '��� �������'
FROM race

-- OVER (����� ������� ���� ������)


create table #tmp (ID int, Ccolor varchar(20))
GO

insert #tmp (ID, Ccolor)
select Cid,Ccolor
from car
go

DELETE #tmp
WHERE ID IN
(
	SELECT A.ID
	from (
		SELECT ID, Ccolor,
		ROW_NUMBER() OVER
			(	
				PARTITION BY Ccolor
				ORDER BY ID
			) as uniqchk
		FROM #tmp
		) as A
WHERE A.uniqchk <> 1

)

select * from #tmp




-- SELECT + GROUP BY + HAVING (������� ��� � ���� ���������, ���� ������� ������ ��������)

SELECT Dname, AVG(Dexp) AS 'AvgExp'
FROM drivers A
GROUP BY Dname
HAVING AVG(Dexp) >
	(	
		SELECT AVG(Dexp) AS AvgE
		From drivers
	)




--3) (BACKUP)
go

create procedure dbo.Backup_data(@date date) as 
begin 
if ((convert(DATETIME,(SELECT create_date 
FROM sys.databases where [name] = 'rk2'),21) < (@date))) 
begin
 
BACKUP DATABASE rk2 
TO DISK = 'C:\Users\Dmitry\git\Databases\rk2\backup' 
WITH FORMAT; 

end
end 


exec dbo.Backup_data '2019-12-30 09:13:36.390'
