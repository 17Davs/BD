USE [gestaoEstufas]
GO

/****** Object:  StoredProcedure [dbo].[InserirPlantacao]    Script Date: 06/06/2024 17:25:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InserirPlantacao]
    @estufaID INT,
    @seccaoID INT,
    @produtoID INT,
    @dataInicio DATE = NULL,
    @dataFimPrevista DATE = NULL,
    @funcionarioID INT,
    @qtdSementes INT
AS
BEGIN
    SET NOCOUNT ON;

    -- verificar se o funcionário existe
    IF NOT EXISTS (SELECT 1 FROM Funcionario WHERE funcionarioID = @funcionarioID)
    BEGIN
        RAISERROR('O ID do funcionário especificado não existe.', 16, 1);
        RETURN;
    END

    -- verificar se o produto existe
    IF NOT EXISTS (SELECT 1 FROM Produto WHERE produtoID = @produtoID)
    BEGIN
        RAISERROR('O ID do produto especificado não existe.', 16, 1);
        RETURN;
    END

    -- verificar se a seccao na estufa existe
    IF NOT EXISTS (SELECT 1 FROM SeccaoEstufa WHERE seccaoID = @seccaoID AND estufaID = @estufaID)
    BEGIN
        RAISERROR('O ID da seccão na estufa especificado não existe.', 16, 1);
        RETURN;
    END

    -- caso a data de início não foi fornecida, utilizar a data atual
    IF @dataInicio IS NULL
        SET @dataInicio = GETDATE();

    -- caso a data de fim prevista não foi fornecida, definir um mês após a data de início
    IF @dataFimPrevista IS NULL
        SET @dataFimPrevista = DATEADD(MONTH, 1, @dataInicio);

    BEGIN TRY
        -- Inserir a plantação
        INSERT INTO Plantacao (estufaID, seccaoID, produtoID, dataInicio, dataFimPrevista, funcionarioID, qtdSementes)
        VALUES (@estufaID, @seccaoID, @produtoID, @dataInicio, @dataFimPrevista, @funcionarioID, @qtdSementes);
    END TRY
    BEGIN CATCH
        -- violação de constraint CHECK das datas
        IF ERROR_NUMBER() = 547 
        BEGIN
            RAISERROR('A dataFimPrevista deve ser maior que dataInicio', 16, 1);
        END
        ELSE
        BEGIN
            THROW;
        END
    END CATCH
END;
GO

