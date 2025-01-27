USE [gestaoEstufas]
GO

ALTER TABLE [dbo].[Funcionario]  WITH CHECK ADD  CONSTRAINT [CHK_telefone] CHECK  (([telefone] like '9[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
GO

ALTER TABLE [dbo].[Funcionario] CHECK CONSTRAINT [CHK_telefone]
GO

