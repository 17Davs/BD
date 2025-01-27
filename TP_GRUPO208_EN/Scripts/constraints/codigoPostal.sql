USE [gestaoEstufas]
GO

ALTER TABLE [dbo].[Estufa]  WITH CHECK ADD  CONSTRAINT [CHK_codigoPostal] CHECK  (([codigoPostal] like '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9]'))
GO

ALTER TABLE [dbo].[Estufa] CHECK CONSTRAINT [CHK_codigoPostal]
GO

