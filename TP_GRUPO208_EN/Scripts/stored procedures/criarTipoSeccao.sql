USE [gestaoEstufas]
GO

/****** Object:  StoredProcedure [dbo].[CriarTipoSeccao]    Script Date: 06/06/2024 17:24:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[CriarTipoSeccao]
    @nome NVARCHAR(100), 
    @descricao NVARCHAR(150)
AS
BEGIN
    SET NOCOUNT ON;
	
    BEGIN TRY
        INSERT INTO TipoSeccao (nome, descricao)
        VALUES (@nome, @descricao);
    END TRY
    BEGIN CATCH
        -- Se houve uma violação da clausula UNIQUE do nome
        IF ERROR_NUMBER() = 2627 
        BEGIN
            RAISERROR('O nome de seccão especificado já existe.', 16, 1);
        END
        ELSE
        BEGIN
            -- throw erro original 
            THROW;
        END
    END CATCH
END;
GO

