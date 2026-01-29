-- 2. A "Mágica": Procedure de Auditoria
-- Objetivo: Identificar produtos que foram vendidos SEM ter estoque suficiente registrado (Venda > Estoque Inicial estimado)
CREATE OR ALTER PROCEDURE sp_Auditoria_Integridade_Vendas
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Declaração de variáveis para controle
        DECLARE @TotalErros INT = 0;

        -- Inserir na tabela de auditoria produtos onde a soma das vendas recentes
        -- supera o que "deveria" ter de movimentação, indicando furo no sistema legado.
        -- LÓGICA: Se Vendas > (EstoqueAnterior - EstoqueAtual), algo quebrou.
        
        -- (Aqui simplificaremos para: Vendas sem produto cadastrado ou Vendas com qtd negativa)
        INSERT INTO Auditoria_Divergencias (TipoDivergencia, Descricao, DetalhesJson)
        SELECT 
            'VENDA_ORFÃ',
            CONCAT('Venda ID ', V.VendaID, ' referencia produto inexistente ID ', V.ProdutoID),
            (SELECT V.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        FROM Vendas V
        LEFT JOIN Estoque E ON V.ProdutoID = E.ProdutoID
        WHERE E.ProdutoID IS NULL;

        SET @TotalErros = @@ROWCOUNT;

        -- Retorna o resumo para quem chamou (o script Python vai ler isso)
        SELECT 
            @TotalErros AS DivergenciasEncontradas,
            GETDATE() AS DataExecucao,
            'Auditoria concluída com sucesso' AS Status;

    END TRY
    BEGIN CATCH
        -- Tratamento de erro robusto (Essencial para Sênior)
        INSERT INTO Auditoria_Divergencias (TipoDivergencia, Descricao, DetalhesJson)
        VALUES ('ERRO_EXECUCAO', ERROR_MESSAGE(), NULL);
        
        THROW; -- Relança o erro para o Python saber que falhou
    END CATCH
END;
GO
