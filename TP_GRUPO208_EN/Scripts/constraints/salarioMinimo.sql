USE [gestaoEstufas]
GO

ALTER TABLE [dbo].[Funcionario]  WITH CHECK ADD  CONSTRAINT [CHK_SALARIO_MINIMO] CHECK  (([salario]>(500)))
GO

ALTER TABLE [dbo].[Funcionario] CHECK CONSTRAINT [CHK_SALARIO_MINIMO]
GO

