USE [gestaoEstufas]
GO

/****** Object:  StoredProcedure [dbo].[InserirColheita]    Script Date: 06/06/2024 17:25:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InserirColheita]
    @dataColheita DATE = NULL, 
	@plantacaoID INT,
    @funcionarioID INT, 
    @qtdColhida INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- verificar se o funcionário existe
    IF NOT EXISTS (SELECT 1 FROM Funcionario WHERE funcionarioID = @funcionarioID)
    BEGIN
        RAISERROR('O ID do funcionário especificado não existe.', 16, 1);
        RETURN;
    END

    -- verificar se a plantação existe
    IF NOT EXISTS (SELECT 1 FROM Plantacao WHERE plantacaoID = @plantacaoID)
    BEGIN
        RAISERROR('O ID da plantação especificado não existe.', 16, 1);
        RETURN;
    END

    BEGIN TRY
        -- caso a data não foi fornecida, utilizar a data atual
        IF @dataColheita IS NULL
            SET @dataColheita = GETDATE();

        -- inserir a colheita
        INSERT INTO Colheita (dataColheita, plantacaoID, funcionarioID, qtdColhida)
        VALUES (@dataColheita, @plantacaoID, @funcionarioID, @qtdColhida);
    END TRY
    BEGIN CATCH
        -- Lançar erros
        THROW;
    END CATCH
END;
GO

