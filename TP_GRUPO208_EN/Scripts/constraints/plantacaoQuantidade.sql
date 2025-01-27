USE [gestaoEstufas]
GO

ALTER TABLE [dbo].[plantacao_prodAux]  WITH CHECK ADD CHECK  (([quantidade]>(0)))
GO

