USE [gestaoEstufas]
GO

ALTER TABLE [dbo].[Produto]  WITH CHECK ADD  CONSTRAINT [CHK_NOME_PROD] CHECK  ((NOT [nome] like '%[^A-Za-z]%'))
GO

ALTER TABLE [dbo].[Produto] CHECK CONSTRAINT [CHK_NOME_PROD]
GO

