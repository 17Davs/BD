USE [gestaoEstufas]
GO

/****** Object:  Trigger [dbo].[trg_atualizar_stock_ProdAux]    Script Date: 06/06/2024 17:20:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[trg_atualizar_stock_ProdAux]
ON [dbo].[plantacao_prodAux]
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- verificar se todos os plantacaoID existem
    IF EXISTS (
        SELECT 1 
        FROM inserted i
        LEFT JOIN Plantacao p ON i.plantacaoID = p.plantacaoID
        WHERE p.plantacaoID IS NULL
    )
    BEGIN
        RAISERROR('Uma ou mais plantacaoID especificadas não existem.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- verificar se todos os produtoAuxID existem
    IF EXISTS (
        SELECT 1 
        FROM inserted i
        LEFT JOIN ProdutoAuxiliar pa ON i.produtoAuxID = pa.produtoAuxID
        WHERE pa.produtoAuxID IS NULL
    )
    BEGIN
        RAISERROR('Uma ou mais produtoAuxID especificadas não existem.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- verificar se as quantidades são menores ou iguais ao stock disponível
    IF EXISTS (
        SELECT 1 
        FROM inserted i
        JOIN ProdutoAuxiliar pa ON i.produtoAuxID = pa.produtoAuxID
        WHERE i.quantidade > pa.qtdEmStock
    )
    BEGIN
        RAISERROR('Uma ou mais quantidades especificadas excedem o stock disponível.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- atualizar as quantidades em stock
    UPDATE pa
    SET pa.qtdEmStock = pa.qtdEmStock - i.quantidade
    FROM ProdutoAuxiliar pa
    JOIN inserted i ON pa.produtoAuxID = i.produtoAuxID;

    -- iserir em plantacao_prodAux
    INSERT INTO plantacao_prodAux (plantacaoID, produtoAuxID, quantidade)
    SELECT plantacaoID, produtoAuxID, quantidade
    FROM inserted;
END;
GO

ALTER TABLE [dbo].[plantacao_prodAux] ENABLE TRIGGER [trg_atualizar_stock_ProdAux]
GO

