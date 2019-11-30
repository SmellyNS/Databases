/* 
==================================================
					FUNCTIONS
==================================================
*/

-- A1 Scalar func

IF OBJECT_ID(N'dbo.CountIPbyS', N'FN') IS NOT NULL
    DROP FUNCTION dbo.CountIPbyS;
GO

create function dbo.CountIPbyS (@SID int)
returns int as

begin
	declare @ret int;
	select @ret = count(*) from dbo.IP
	where IPid in
		(
			select IPid from dbo.IPSU
			where Sid = @SID
		)
	return @ret;
end;
go

select dbo.CountIPbyS(4)

-- A2 Table func

IF OBJECT_ID(N'dbo.GetIPbyS', N'FN') IS NOT NULL
    DROP FUNCTION dbo.GetIPbyS;
GO

create function dbo.GetIPbyS (@SID int)
returns table as
	return
		(
			select * from dbo.IP
			where IPid in
				(
					select IPid from dbo.IPSU
					where Sid = @SID
				)
		)
go

select * from dbo.GetIPbyS(3)


-- A3 multioperator table func

IF OBJECT_ID (N'dbo.UsersIP', N'FN') IS NOT NULL
    DROP FUNCTION dbo.UsersIP
GO

create function dbo.UsersIP()
returns @ret Table
(
	Un varchar(50),
	IPad varchar(16)
)
as
begin
	Insert into @ret
		select Uname, IPaddress
		from U
		join IPSU on U.Uid = IPSU.Uid
		join IP on IP.IPid = IPSU.IPid
return
end
GO

select * from dbo.UsersIP()


-- A4 recursion



IF OBJECT_ID(N'dbo.fib', N'FN') IS NOT NULL
    DROP FUNCTION dbo.fib;
GO

create function dbo.fib (@n int)
returns int as

begin
	if @n in (1,2)
		return 1
	return dbo.fib(@n-1) + dbo.fib(@n-2)
end
go

select dbo.fib(10)


/*
=====================================================
					PROCEDURES
=====================================================
*/

-- B1 std proc

if OBJECT_ID (N'dbo.getusers', 'P') is not null
drop procedure dbo.getusers go

create procedure getusers as begin select * from U end go

exec getusers go

-- B2 recurs proc

if OBJECT_ID (N'dbo.factorial', 'P') is not null
drop procedure dbo.factorial
go

create procedure dbo.factorial (@i int, @n float output)  
as
begin 
  if @n is null
    select @n = 1;

  if @i = 1 
    return;

  set @n = @n * @i;
  set @i = @i - 1;

  exec factorial @i, @n output
end
go

declare 
  @f float
begin
  exec factorial 5, @f output
  select @f
end


-- B3 curs

if OBJECT_ID (N'dbo.getusersnames', 'P') is not null
drop procedure dbo.getusersnames
go

create procedure getusersnames as begin
	declare c cursor for select Uname from U
	declare @name nvarchar(50)
	open c

	declare @i int
	set @i = 0

	while (@i < 10)
	begin
		fetch next from c into @name
		print @name
		set @i = @i + 1
	end

	close c
	deallocate c

	print @name
end
go

exec getusersnames
go

-- B4 Metadata

if OBJECT_ID (N'dbo.checkExistingTables', 'P') IS NOT NULL
    drop procedure dbo.checkExistingTables
go

create procedure checkExistingTables as begin
	select name, create_date, modify_date from sys.tables
end
go

exec checkExistingTables
go

/*
=================================================================
							TRIGGERS
=================================================================
*/


-- C1 AFTER

create table History 
(
    Id int identity primary key,
    Uid int NOT NULL,
    Uname nvarchar(50) NOT NULL
);
go

create trigger newuser on U after insert as
insert into History (Uid, Uname)
select Uid, 'Новый пользователь: ' + Uname
from inserted

insert into U(Uname) values ('приколямба')

select * from History

-- C2 INSTEAD OF
go

create trigger think on U instead of delete as
print 'Не удаляй, подумай! Потом же опять придется заполнять'

select * from U where Uid = 1

delete from U where Uid = 1




-- Additional INSTEAD OF
go

create trigger Change on U after update as
	begin
		insert into History (Uid, Uname)
		select Uid, 'Новый пользователь: ' + Uname
		from inserted

		insert into History (Uid, Uname)
		select Uid, 'Удаленный пользователь: ' + Uname
		from deleted
	end


UPDATE U SET Uname = 'mama mia' WHERE Uid = 1
select * from History