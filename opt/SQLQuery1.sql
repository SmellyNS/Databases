use master
go

if exists (select name from sys.databases where name = N'optional')
drop database optional
go

create database optional
go

use optional
go

create table person (
	pid int identity(1,1) not null,
	pname varchar(32) not null,
	primary key (pid)
)

create table atype (
	atid int identity(1,1) not null,
	ades varchar(32) not null,
	primary key (atid)
)

create table pabsent (
	paid int identity(1,1) not null,
	pid int references person (pid),
	adate date not null,
	atid int references atype (atid),
	primary key (paid)
)

-----------------------------------------------

insert person values ('Ваня')
insert person values ('Егор')
insert person values ('Катя')
insert person values ('Данил')
insert person values ('Дмитрий')
insert person values ('Яна')

insert atype values ('план отпуск')
insert atype values ('декрет')
insert atype values ('болезнь')
insert atype values ('без ув п')

insert pabsent values (1,'25.06.2012',1)
insert pabsent values (1,'26.06.2012',1)
insert pabsent values (1,'27.06.2012',1)
insert pabsent values (1,'28.06.2012',1)
insert pabsent values (2,'27.06.2012',3)
insert pabsent values (2,'28.06.2012',4)
insert pabsent values (3,'10.06.2012',2)
insert pabsent values (3,'11.06.2012',2)
insert pabsent values (3,'12.06.2012',2)
insert pabsent values (3,'13.06.2012',2)

--------------------------------------------------

select * from pabsent order by adate, pid