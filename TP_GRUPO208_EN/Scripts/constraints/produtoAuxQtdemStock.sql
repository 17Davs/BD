USE [gestaoEstufas]
GO

ALTER TABLE [dbo].[ProdutoAuxiliar] ADD  CONSTRAINT [DF_ProdutoAuxiliar_QuantidadeEmStock]  DEFAULT ((0)) FOR [qtdEmStock]
GO

