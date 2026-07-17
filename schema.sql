-- E-Commerce BI Dashboard - PostgreSQL Schema

CREATE TABLE dim_data (
    id_data SERIAL PRIMARY KEY,
    data_completa DATE NOT NULL UNIQUE,
    ano INTEGER, mes INTEGER, trimestre INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dim_produto (
    id_produto SERIAL PRIMARY KEY,
    sku VARCHAR(50) UNIQUE, nome_produto VARCHAR(255),
    categoria VARCHAR(100), preco_custo DECIMAL(10,2),
    preco_tabela DECIMAL(10,2), ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE dim_marketplace (
    id_marketplace SERIAL PRIMARY KEY,
    nome_marketplace VARCHAR(100) UNIQUE,
    comissao_percentual DECIMAL(5,2), ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE dim_categoria (
    id_categoria SERIAL PRIMARY KEY,
    nome_categoria VARCHAR(100) UNIQUE,
    margem_esperada DECIMAL(5,2)
);

CREATE TABLE fato_vendas (
    id_venda SERIAL PRIMARY KEY,
    id_produto INTEGER REFERENCES dim_produto(id_produto),
    id_data INTEGER REFERENCES dim_data(id_data),
    id_marketplace INTEGER REFERENCES dim_marketplace(id_marketplace),
    id_categoria INTEGER REFERENCES dim_categoria(id_categoria),
    numero_pedido VARCHAR(50), quantidade INTEGER,
    preco_unitario DECIMAL(10,2), receita_liquida DECIMAL(12,2),
    custo_produto DECIMAL(12,2), lucro DECIMAL(12,2)
);

-- Views
CREATE VIEW vw_vendas_por_data AS
SELECT d.data_completa, COUNT(*) as qtd_pedidos,
       SUM(f.receita_liquida) as receita, SUM(f.lucro) as lucro
FROM fato_vendas f JOIN dim_data d ON f.id_data = d.id_data
GROUP BY d.data_completa;
