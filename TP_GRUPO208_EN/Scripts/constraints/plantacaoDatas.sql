USE [gestaoEstufas]
GO

ALTER TABLE [dbo].[Plantacao]  WITH CHECK ADD  CONSTRAINT [CHK_Plantacao_Datas] CHECK  (([dataFimPrevista]>[dataInicio] AND ([dataFim] IS NULL OR [dataFim]>[dataInicio])))
GO

ALTER TABLE [dbo].[Plantacao] CHECK CONSTRAINT [CHK_Plantacao_Datas]
GO

