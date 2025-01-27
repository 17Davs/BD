USE [gestaoEstufas]
GO

/****** Object:  StoredProcedure [dbo].[CriarEstufa]    Script Date: 06/06/2024 17:24:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[CriarEstufa]
    @nome NVARCHAR(100), 
    @rua NVARCHAR(150),
	@cidade NVARCHAR(100),
	@codigoPostal varchar(8)
AS
BEGIN
    SET NOCOUNT ON;
	
    BEGIN TRY
        INSERT INTO Estufa (nome, rua, cidade, codigoPostal)
        VALUES (@nome, @rua, @cidade, @codigoPostal);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorNumber INT = ERROR_NUMBER();

        IF @ErrorNumber = 2627 
        BEGIN
            -- violação de restrição UNIQUE
            RAISERROR('O endereço especificado já existe.', 16, 1);
        END
        ELSE IF @ErrorNumber = 547 
        BEGIN
            -- violação de restrição CHECK
            RAISERROR('A rua não pode ser vazia e o código postal deve estar no formato 1234-567.', 16, 1);
        END
        ELSE
        BEGIN
            THROW;
        END
    END CATCH
END;
GO

