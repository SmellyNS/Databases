USE [master]
GO
-- Если база данных [dbSERVERS] уже существует, уничтожаем ее
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'dbSERVERS')
DROP DATABASE [dbSERVERS]
GO
/****** Создаем базу данных [dbSERVERS] ******/
CREATE DATABASE [dbSERVERS]
GO
/****** Переходим в контекст созданной базы данных [dbSERVERS] ******/
USE [dbSERVERS]
GO
/****** Создаем таблицу адресов [IP] ******/
CREATE TABLE [dbo].[IP](
	[IPid] [int] IDENTITY(1,1) NOT NULL,
	[IPaddress] [varchar](16) NOT NULL,
	[Status] [int] NULL
)
GO
/****** Создаем таблицу оборудования [S] ******/
CREATE TABLE [dbo].[S](
	[Sid] [int] IDENTITY(1,1) NOT NULL,
	[Sram] [int] NULL,
	[Sgraphics] [varchar](20) NULL,
)
GO
CREATE TABLE [dbo].[U](
	[Uid] [int] IDENTITY(1,1) NOT NULL,
	[Uname] [varchar](50) NOT NULL
)
GO
CREATE TABLE [dbo].[IPSU](
	[IPid] [int] NOT NULL,
	[Sid] [int] NOT NULL,
	[Uid] [int] NOT NULL,
	[scan] [varchar](20) NULL
)
GO
