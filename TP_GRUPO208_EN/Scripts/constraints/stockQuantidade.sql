USE [gestaoEstufas]
GO

ALTER TABLE [dbo].[ProdutoAuxiliar]  WITH CHECK ADD  CONSTRAINT [CHK_STOCK_QUANTIDADE] CHECK  (([qtdEmStock]>=(0)))
GO

ALTER TABLE [dbo].[ProdutoAuxiliar] CHECK CONSTRAINT [CHK_STOCK_QUANTIDADE]
GO

