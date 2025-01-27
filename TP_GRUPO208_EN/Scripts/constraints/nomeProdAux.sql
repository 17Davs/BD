USE [gestaoEstufas]
GO

ALTER TABLE [dbo].[ProdutoAuxiliar]  WITH CHECK ADD  CONSTRAINT [CHK_NOME_PRODAUX] CHECK  ((NOT [nome] like '%[^A-Za-z]%'))
GO

ALTER TABLE [dbo].[ProdutoAuxiliar] CHECK CONSTRAINT [CHK_NOME_PRODAUX]
GO

