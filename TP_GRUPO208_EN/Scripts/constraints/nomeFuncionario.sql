USE [gestaoEstufas]
GO

ALTER TABLE [dbo].[Funcionario]  WITH CHECK ADD  CONSTRAINT [CHK_NOME_FUNCIONARIO] CHECK  ((NOT [nome] like '%[^A-Za-z ]%'))
GO

ALTER TABLE [dbo].[Funcionario] CHECK CONSTRAINT [CHK_NOME_FUNCIONARIO]
GO

