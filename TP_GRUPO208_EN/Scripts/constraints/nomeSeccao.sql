USE [gestaoEstufas]
GO

ALTER TABLE [dbo].[TipoSeccao]  WITH CHECK ADD  CONSTRAINT [CHK_NOME_SECCAO] CHECK  ((NOT [nome] like '%[^A-Za-z ]%'))
GO

ALTER TABLE [dbo].[TipoSeccao] CHECK CONSTRAINT [CHK_NOME_SECCAO]
GO

