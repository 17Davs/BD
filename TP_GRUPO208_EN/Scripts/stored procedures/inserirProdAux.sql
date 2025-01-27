USE [gestaoEstufas]
GO

/****** Object:  StoredProcedure [dbo].[InserirProdutoAuxiliar]    Script Date: 06/06/2024 17:25:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[InserirProdutoAuxiliar]
    @nome NVARCHAR(100), 
    @funcionalidade NVARCHAR(150), 
    @qtdEmStock INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO ProdutoAuxiliar (nome, funcionalidade, qtdEmStock)
        VALUES (@nome, @funcionalidade, @qtdEmStock);
    END TRY
    BEGIN CATCH
        -- Se houve uma violação da clausula UNIQUE do nome
        IF ERROR_NUMBER() = 2627 
        BEGIN
            RAISERROR('O nome do produto auxiliar já existe. Por favor, insira um nome único.', 16, 1);
        END
        ELSE
        BEGIN
            -- throw erro original 
            THROW;
        END
    END CATCH
END;
GO

