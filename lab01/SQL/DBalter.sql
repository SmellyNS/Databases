/****** Начинаем работать в контексте созданной базы данных [dbSERVERS] ******/
USE [dbSERVERS]
GO
/****** Изменяем определение таблицы поставщиков [IP] путем добавления ограничений
первичного ключа и ключа уникальности ******/
ALTER TABLE [dbo].[IP] ADD
CONSTRAINT [PK_IP] PRIMARY KEY ([IPid]),
CONSTRAINT [UK_IP] UNIQUE ([IPaddress])
GO
/****** Изменяем определение таблицы деталей [S] путем добавления ограничения
первичного ключа ******/
ALTER TABLE [dbo].[S] ADD
CONSTRAINT [PK_S] PRIMARY KEY ([Sid])
GO
/****** Изменяем определение таблицы проектов [U] путем добавления ограничений
ограничений первичного ключа и ключа уникальности ******/
ALTER TABLE [dbo].[U] ADD
CONSTRAINT [PK_U] PRIMARY KEY ([Uid]),
CONSTRAINT [UK_U] UNIQUE ([Uname])
GO
/****** Изменяем определение таблицы поставок [IPSU] путем добавления ограничений
первичного ключа и внешних ключей ******/
ALTER TABLE [dbo].[IPSU] ADD
CONSTRAINT [PK_SP] PRIMARY KEY ( [IPid], [Sid], [Uid] ),
CONSTRAINT [FK_SP_U] FOREIGN KEY([Uid]) REFERENCES [dbo].[U] ([Uid]) ,
CONSTRAINT [FK_SP_S] FOREIGN KEY([Sid]) REFERENCES [dbo].[S] ([Sid]) ,
CONSTRAINT [FK_SP_IP] FOREIGN KEY([IPid]) REFERENCES [dbo].[IP] ([IPid])
GO
/****** Изменяем определения таблиц [IP], [S] и [IPSU] путем добавления ограничений CHECK
******/
ALTER TABLE [dbo].[IP] ADD
CONSTRAINT [Status_chk] CHECK ([Status] BETWEEN 0 AND 1),
CONSTRAINT [IPaddress_chk] CHECK ([IPaddress] LIKE('[0-255].[0-255].[0-255].[0-255]'))
GO