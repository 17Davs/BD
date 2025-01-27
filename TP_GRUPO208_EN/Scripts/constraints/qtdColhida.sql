USE [gestaoEstufas]
GO

ALTER TABLE [dbo].[Colheita]  WITH CHECK ADD  CONSTRAINT [CHK_QTD_COLHIDA] CHECK  (([qtdColhida]>(0)))
GO

ALTER TABLE [dbo].[Colheita] CHECK CONSTRAINT [CHK_QTD_COLHIDA]
GO


