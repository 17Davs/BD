USE [gestaoEstufas]
GO

/****** Object:  Trigger [dbo].[trg_limitar_ProdutosPorSeccaoEstufa]    Script Date: 06/06/2024 17:19:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[trg_limitar_ProdutosPorSeccaoEstufa]
ON [dbo].[Plantacao]
INSTEAD OF INSERT
AS
BEGIN
    -- variável para contagem
    DECLARE @produtoCount INT, @newProdutoCount INT;

    -- verificar se o tipo do produto é equivalente ao nome do tipo da seção
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Produto p ON i.produtoID = p.produtoID
        JOIN TipoSeccao ts ON i.seccaoID = ts.seccaoID
        WHERE p.tipo <> ts.nome
    )
    BEGIN
        RAISERROR('Atenção, o tipo do produto não é equivalente ao nome do tipo da seção.', 16, 1);
        RETURN;
    END

    -- contar o número de produtos diferentes plantados na seção da estufa
    SELECT @produtoCount = COUNT(DISTINCT produtoID)
    FROM Plantacao
    WHERE seccaoID = (SELECT DISTINCT seccaoID FROM inserted)
      AND estufaID = (SELECT DISTINCT estufaID FROM inserted)
      AND (dataFim IS NULL OR dataFim >= (SELECT MIN(dataInicio) FROM inserted));

    -- contar o número de novos produtos diferentes a serem inseridos que não estão presentes na seção da estufa
    SELECT @newProdutoCount = COUNT(DISTINCT i.produtoID)
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1
        FROM Plantacao p
        WHERE i.seccaoID = p.seccaoID
          AND i.estufaID = p.estufaID
          AND i.produtoID = p.produtoID
          AND (p.dataFim IS NULL OR p.dataFim >= i.dataInicio)
    );

    -- verificar se a inserção dos novos produtos ultrapassa o limite de 10 produtos diferentes
    IF @produtoCount + @newProdutoCount > 10
    BEGIN
        RAISERROR('Atenção, esta secção da estufa não pode ter mais de 10 produtos diferentes plantados ao mesmo tempo.', 16, 1);
        RETURN;
    END

    -- Inserir todos os produtos
    INSERT INTO Plantacao (seccaoID, estufaID, produtoID, dataInicio, dataFim, dataFimPrevista, funcionarioID, qtdSementes)
    SELECT 
        i.seccaoID, 
        i.estufaID, 
        i.produtoID, 
        i.dataInicio, 
        i.dataFim, 
        COALESCE(i.dataFim, i.dataFimPrevista), 
        i.funcionarioID, 
        i.qtdSementes
    FROM inserted i;
END;
GO

ALTER TABLE [dbo].[Plantacao] ENABLE TRIGGER [trg_limitar_ProdutosPorSeccaoEstufa]
GO

