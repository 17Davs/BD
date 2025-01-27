USE [gestaoEstufas]
GO

ALTER TABLE [dbo].[SeccaoEstufa]  WITH CHECK ADD  CONSTRAINT [CHK_AREA] CHECK  (([area_m2]>(0)))
GO

ALTER TABLE [dbo].[SeccaoEstufa] CHECK CONSTRAINT [CHK_AREA]
GO

