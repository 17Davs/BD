USE [gestaoEstufas]
GO

/****** Object:  Trigger [dbo].[trg_prevent_ProductUpdate]    Script Date: 06/06/2024 17:19:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [dbo].[trg_prevent_ProductUpdate]
ON [dbo].[Plantacao]
INSTEAD OF UPDATE
AS
BEGIN
    -- verificar se há tentativa de alteração do produtoID
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN deleted d
        ON i.seccaoID = d.seccaoID
           AND i.estufaID = d.estufaID
           AND i.produtoID <> d.produtoID
    )
    BEGIN
        RAISERROR('Atenção, não é permitido alterar o produto plantado.', 16, 1);
        RETURN;
    END

    -- atualizar
    UPDATE p
    SET 
        p.seccaoID = i.seccaoID,
        p.estufaID = i.estufaID,
        p.dataInicio = i.dataInicio,
        p.dataFim = i.dataFim,
        p.dataFimPrevista = i.dataFimPrevista,
        p.funcionarioID = i.funcionarioID,
        p.qtdSementes = i.qtdSementes
    FROM Plantacao p
    JOIN inserted i
    ON p.seccaoID = i.seccaoID
       AND p.estufaID = i.estufaID
       AND p.produtoID = i.produtoID;
END;
GO

ALTER TABLE [dbo].[Plantacao] ENABLE TRIGGER [trg_prevent_ProductUpdate]
GO

