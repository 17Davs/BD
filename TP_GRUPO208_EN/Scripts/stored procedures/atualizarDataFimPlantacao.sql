USE [gestaoEstufas]
GO

/****** Object:  StoredProcedure [dbo].[AtualizarDataFimPlantacao]    Script Date: 06/06/2024 17:24:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AtualizarDataFimPlantacao]
    @plantacaoID INT,
    @novaDataFim DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- verificar se a plantação existe
        IF NOT EXISTS (SELECT 1 FROM Plantacao WHERE plantacaoID = @plantacaoID)
        BEGIN
            RAISERROR('O ID da plantação especificado não existe.', 16, 1);
            RETURN;
        END

       --atualizar a dataFim e dataFimPrevista da plantação se a dataFim foi alterada
        UPDATE Plantacao
        SET 
            dataFim = @novaDataFim,
            dataFimPrevista = CASE WHEN dataFimPrevista <> @novaDataFim THEN @novaDataFim ELSE dataFimPrevista END
        WHERE plantacaoID = @plantacaoID;
    END TRY
    BEGIN CATCH
        -- verificar se é erro relacionado com a constraint de data codigo 547
        IF ERROR_NUMBER() = 547
        BEGIN
            RAISERROR('A nova data de fim viola as regras, ela deve ser posterior à data de início da plantação.', 16, 1);
        END
        ELSE
        BEGIN
            -- para outro erro, lançar a exceção original
            THROW;
        END
    END CATCH
END;
GO

