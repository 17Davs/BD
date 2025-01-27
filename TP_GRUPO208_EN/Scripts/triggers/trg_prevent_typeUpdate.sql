USE [gestaoEstufas]
GO

/****** Object:  Trigger [dbo].[trg_preventTypeUpdate]    Script Date: 06/06/2024 17:21:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[trg_preventTypeUpdate]
ON [dbo].[Produto]
AFTER UPDATE
AS
BEGIN
    BEGIN TRANSACTION;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN deleted d
        ON i.produtoID = d.produtoID
        WHERE i.tipo <> d.tipo
    )
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM inserted i
            JOIN plantacao p
            ON i.produtoID = p.produtoID
            JOIN tiposeccao s
            ON p.seccaoID = s.seccaoID
            WHERE i.tipo <> s.nome
        )
        BEGIN
            RAISERROR('Atenção, não é permitido alterar o tipo do produto plantado.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        UPDATE p
        SET
            p.nome = i.nome,
            p.tipo = i.tipo
        FROM Produto p
        JOIN inserted i
        ON p.produtoID = i.produtoID;
    END;

    COMMIT TRANSACTION;
END;
GO

ALTER TABLE [dbo].[Produto] ENABLE TRIGGER [trg_preventTypeUpdate]
GO

