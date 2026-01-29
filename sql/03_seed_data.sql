-- 3. Inserção de Dados (Seed Data)

-- Limpar dados anteriores (Opcional, para testes repetidos)
TRUNCATE TABLE Vendas;
DELETE FROM Estoque;
TRUNCATE TABLE Auditoria_Divergencias;

-- Inserir Estoque (Produtos Legítimos)
INSERT INTO Estoque (ProdutoID, Nome, QuantidadeAtual)
VALUES 
(101, 'Smartphone Galaxy S23', 50),
(102, 'Notebook Dell XPS', 20),
(103, 'Fone Bluetooth Sony', 100);

-- Inserir Vendas Válidas (Produtos existem)
INSERT INTO Vendas (ProdutoID, QuantidadeVendida)
VALUES 
(101, 1), -- Venda correta
(103, 2); -- Venda correta

-- Inserir Vendas "Fantasmas" (Produtos que NÃO existem no Estoque)
-- Estes devem ser detectados pela Procedure
INSERT INTO Vendas (ProdutoID, QuantidadeVendida)
VALUES 
(999, 1), -- ERRO: Produto 999 não existe
(888, 5); -- ERRO: Produto 888 não existe

SELECT 'Dados inseridos com sucesso. Agora execute a Procedure sp_Auditoria_Integridade_Vendas.' AS Info;
