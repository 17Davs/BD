USE [gestaoEstufas]
GO

/****** Object:  StoredProcedure [dbo].[CriarSeccaoEstufa]    Script Date: 06/06/2024 17:24:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CriarSeccaoEstufa]
    @estufaID INT,
    @seccaoID INT,
    @area_m2 DECIMAL(10,2),
    @obs nvarchar(300) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- verificar se a estufa existe
    IF NOT EXISTS (SELECT 1 FROM Estufa WHERE estufaID = @estufaID)
    BEGIN
        RAISERROR('O ID da estufa especificada não existe.', 16, 1);
        RETURN;
    END

    -- verificar se a seccao existe
    IF NOT EXISTS (SELECT 1 FROM TipoSeccao WHERE seccaoID = @seccaoID)
    BEGIN
        RAISERROR('O ID da seccão especificada não existe.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        -- criar seccão na estufa
        INSERT INTO SeccaoEstufa(estufaID, seccaoID, area_m2, obs)
        VALUES (@estufaID, @seccaoID, @area_m2, @obs);
    END TRY
    BEGIN CATCH
        -- violação de constraint CHECK da area
        IF ERROR_NUMBER() = 547 
        BEGIN
            RAISERROR('A área em metros quadrados especificada deve ser um valor positivo.', 16, 1);
        END
        ELSE
        BEGIN
            THROW;
        END
    END CATCH
END;
GO

