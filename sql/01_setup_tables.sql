-- 1. Setup do Cenário (Tabelas Simplificadas)
IF OBJECT_ID('dbo.Estoque', 'U') IS NOT NULL DROP TABLE dbo.Estoque;
CREATE TABLE Estoque (
    ProdutoID INT PRIMARY KEY,
    Nome VARCHAR(100),
    QuantidadeAtual INT,
    UltimaAtualizacao DATETIME DEFAULT GETDATE()
);

IF OBJECT_ID('dbo.Vendas', 'U') IS NOT NULL DROP TABLE dbo.Vendas;
CREATE TABLE Vendas (
    VendaID INT PRIMARY KEY IDENTITY,
    ProdutoID INT,
    QuantidadeVendida INT,
    DataVenda DATETIME DEFAULT GETDATE()
);

-- Tabela para armazenar as inconsistências encontradas (O "Log" do Auditor)
IF OBJECT_ID('dbo.Auditoria_Divergencias', 'U') IS NOT NULL DROP TABLE dbo.Auditoria_Divergencias;
CREATE TABLE Auditoria_Divergencias (
    LogID INT PRIMARY KEY IDENTITY,
    DataAnalise DATETIME DEFAULT GETDATE(),
    TipoDivergencia VARCHAR(50),
    Descricao VARCHAR(255),
    DetalhesJson NVARCHAR(MAX) -- Armazenar dados técnicos para debug
);
GO
