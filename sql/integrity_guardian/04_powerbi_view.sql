-- 4. View para Power BI (Camada de Apresentação)
-- Objetivo: Facilitar o consumo pelo Power BI, tratando tipos de dados e parsind JSON se necessário.

CREATE OR ALTER VIEW vw_Dashboard_Auditoria_Vendas
AS
SELECT 
    LogID,
    DataAnalise,
    -- Facilita filtros de data no Power BI
    CAST(DataAnalise AS DATE) AS DataAnalise_Dia,
    DATEPART(HOUR, DataAnalise) AS HoraAnalise,
    TipoDivergencia,
    Descricao,
    -- Extraindo dados do JSON para colunas tipadas (Demonstra domínio de SQL Moderno)
    -- Se o JSON for NULL (erro de execução), retorna NULL sem quebrar
    CAST(JSON_VALUE(DetalhesJson, '$.ProdutoID') AS INT) AS ProdutoID_Fantasma,
    CAST(JSON_VALUE(DetalhesJson, '$.VendaID') AS INT) AS VendaID,
    CAST(JSON_VALUE(DetalhesJson, '$.QuantidadeVendida') AS INT) AS QtdTentativaVenda
    
FROM Auditoria_Divergencias;
GO
