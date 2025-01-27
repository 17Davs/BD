USE [gestaoEstufas]
GO

/****** Object:  StoredProcedure [dbo].[IncrementarQtdEmStock]    Script Date: 06/06/2024 17:24:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IncrementarQtdEmStock]
    @prodAuxID INT = NULL, 
    @nome NVARCHAR(100) = NULL, 
    @incremento INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- verificar se pelo menos um dos parâmetros foi fornecido
        IF @prodAuxID IS NULL AND @nome IS NULL
        BEGIN
            RAISERROR('Por favor, forneça um prodAuxID ou um nome.', 16, 1);
            RETURN;
        END

        -- incrementar no stock com base no prodAuxID se fornecido
        IF @prodAuxID IS NOT NULL
        BEGIN
            IF EXISTS (SELECT 1 FROM ProdutoAuxiliar WHERE produtoAuxID = @prodAuxID)
            BEGIN
                UPDATE ProdutoAuxiliar
                SET qtdEmStock = qtdEmStock + @incremento
                WHERE produtoAuxID = @prodAuxID;
            END
            ELSE
            BEGIN
                RAISERROR('O produto auxiliar com o prodAuxID especificado não existe.', 16, 1);
            END
        END
        ELSE
        BEGIN
            -- Incrementa o estoque com base no nome se fornecido
            IF EXISTS (SELECT 1 FROM ProdutoAuxiliar WHERE nome = @nome)
            BEGIN
                UPDATE ProdutoAuxiliar
                SET qtdEmStock = qtdEmStock + @incremento
                WHERE nome = @nome;
            END
            ELSE
            BEGIN
                RAISERROR('O produto auxiliar com o nome especificado não existe.', 16, 1);
            END
        END
    END TRY
    BEGIN CATCH
        -- Trata outros erros
        THROW;
    END CATCH
END;
GO

