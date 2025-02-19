USE [gestaoEstufas]
GO
/****** Object:  Trigger [dbo].[trg_verificar_data_colheita]    Script Date: 06/06/2024 17:15:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[trg_verificar_data_colheita]
ON [dbo].[Colheita]
INSTEAD OF INSERT
AS
BEGIN
    -- verificar se há colheitas com data fora do intervalo válido da plantação
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Plantacao p ON i.plantacaoID = p.plantacaoID
        WHERE 
            i.dataColheita < p.dataInicio OR 
            (p.dataFim IS NOT NULL AND i.dataColheita > p.dataFim)
    )
    BEGIN
        -- erro se a condição não for satisfeita
        RAISERROR ('A data de colheita deve estar dentro do intervalo válido da plantação.', 16, 1)
        RETURN;
    END;
    -- caso a verificação passar, proceda com a inserção dos dados na tabela Colheita
    INSERT INTO Colheita (dataColheita, plantacaoID, funcionarioID, qtdColhida)
    SELECT dataColheita, plantacaoID, funcionarioID, qtdColhida
    FROM inserted;
END;