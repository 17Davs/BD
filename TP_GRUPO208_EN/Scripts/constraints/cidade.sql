USE [gestaoEstufas]
GO

ALTER TABLE [dbo].[Estufa]  WITH CHECK ADD  CONSTRAINT [CHK_CIDADE_ESTUFA] CHECK  ((NOT [cidade] like '%[^A-Za-z ]%'))
GO

ALTER TABLE [dbo].[Estufa] CHECK CONSTRAINT [CHK_CIDADE_ESTUFA]
GO

