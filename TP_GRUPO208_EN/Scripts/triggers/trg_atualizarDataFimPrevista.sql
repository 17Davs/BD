USE [gestaoEstufas]
GO

/****** Object:  Trigger [dbo].[trg_atualizar_DataFimPrevista]    Script Date: 06/06/2024 17:19:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[trg_atualizar_DataFimPrevista]
ON [dbo].[Plantacao]
AFTER UPDATE
AS
BEGIN
    -- verificar se dataFim foi atualizada
    IF UPDATE(dataFim)
    BEGIN
        -- atualizar dataFimPrevista para o valor de dataFim onde dataFim foi alterada
        UPDATE Plantacao
        SET dataFimPrevista = i.dataFim
        FROM Plantacao p
        JOIN inserted i ON p.plantacaoID = i.plantacaoID
        WHERE p.dataFim != i.dataFimPrevista; 
    END
END;
GO

ALTER TABLE [dbo].[Plantacao] ENABLE TRIGGER [trg_atualizar_DataFimPrevista]
GO

