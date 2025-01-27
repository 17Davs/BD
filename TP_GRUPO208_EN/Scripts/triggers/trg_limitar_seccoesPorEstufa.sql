USE [gestaoEstufas]
GO

/****** Object:  Trigger [dbo].[trg_limitar_SeccoesPorEstufa]    Script Date: 06/06/2024 17:23:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[trg_limitar_SeccoesPorEstufa]
ON [dbo].[SeccaoEstufa]
INSTEAD OF INSERT
AS 
BEGIN
       -- verificar se todos os estufaID existem em Estufa
    IF EXISTS (
        SELECT 1
        FROM inserted i
        LEFT JOIN Estufa e ON i.estufaID = e.estufaID
        WHERE e.estufaID IS NULL
    )
    BEGIN
        RAISERROR('Um ou mais estufaID especificados não existem em Estufa.', 16, 1);
        RETURN;
    END

   -- Verificar se a estufa já atingiu o número máximo de seções
    IF (SELECT COUNT(*) FROM SeccaoEstufa WHERE estufaID IN (SELECT estufaID FROM inserted)) >= 3
    BEGIN
        RAISERROR('Atenção, esta estufa já tem o número máximo de seções.', 16, 1);
        RETURN;
    END

	 -- verificar se todos os seccaoID existem em TipoSeccao
    IF EXISTS (
        SELECT 1
        FROM inserted i
        LEFT JOIN TipoSeccao t ON i.seccaoID = t.seccaoID
        WHERE t.seccaoID IS NULL
    )
    BEGIN
        RAISERROR('Um ou mais seccaoID especificados não existem em TipoSeccao.', 16, 1);
        RETURN;
    END


    -- Inserir na tabela SeccaoEstufa se a condição for satisfeita
    INSERT INTO SeccaoEstufa (seccaoID, estufaID, area_m2, obs)
    SELECT seccaoID, estufaID, area_m2, obs
    FROM inserted;
END;
GO

ALTER TABLE [dbo].[SeccaoEstufa] ENABLE TRIGGER [trg_limitar_SeccoesPorEstufa]
GO

