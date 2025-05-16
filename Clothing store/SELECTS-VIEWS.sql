-- -----------------------------------------------------
--Perguntas/Relatórios Importantes para uma Loja de Roupas
-- -----------------------------------------------------
--RELATÓRIOS DE VENDAS
--Total de vendas por período
SELECT 
    DATE(Data_Venda) AS Data, 
    SUM(Valor_Total) AS Total_Vendas
FROM Venda
WHERE Data_Venda BETWEEN '2024-01-01' AND '2024-03-31'  -- Exemplo de período
GROUP BY DATE(Data_Venda)
ORDER BY Data_Venda;

--Vendas por cliente
SELECT 
    c.Nome_Cliente, 
    SUM(v.Valor_Total) AS Total_Gasto
FROM Cliente c
JOIN Venda v ON c.idCliente = v.idCliente
GROUP BY c.Nome_Cliente
ORDER BY Total_Gasto DESC;

--Produtos mais vendidos
SELECT 
    p.Nome_Produto, 
    SUM(iv.Quantidade) AS Total_Vendido
FROM Produto p
JOIN Item_Venda iv ON p.idProduto = iv.idProduto
JOIN Venda v ON iv.idVenda = v.idVenda
WHERE v.Data_Venda BETWEEN '2024-01-01' AND '2024-03-31' -- Exemplo de período
GROUP BY p.Nome_Produto
ORDER BY Total_Vendido DESC
LIMIT 10;

--Vendas por funcionário
SELECT 
    f.Nome_Funcionario, 
    SUM(v.Valor_Total) AS Total_Vendas
FROM Funcionario f
JOIN Venda v ON f.idFuncionario = v.idFuncionario
GROUP BY f.Nome_Funcionario
ORDER BY Total_Vendas DESC;

--Ticket médio por venda
SELECT AVG(Valor_Total) AS Ticket_Medio FROM Venda;


-- -----------------------------------------------------
--RELATÓRIOS DE PRODUTOS
--Produtos por categoria
SELECT 
    cp.Nome_Categoria, 
    COUNT(p.idProduto) AS Total_Produtos
FROM Categoria_Produto cp
LEFT JOIN Produto p ON cp.idCategoria_Produto = p.idCategoria_Produto
GROUP BY cp.Nome_Categoria
ORDER BY Total_Produtos DESC;

--Produtos com estoque baixo
SELECT 
    p.Nome_Produto, 
    e.Quantidade
FROM Produto p
JOIN Estoque e ON p.idProduto = e.idProduto
WHERE e.Quantidade < 50;

--Produtos sem vendas nos últimos X dias
SELECT p.Nome_Produto
FROM Produto p
WHERE NOT EXISTS (
    SELECT 1
    FROM Item_Venda iv
    JOIN Venda v ON iv.idVenda = v.idVenda
    WHERE iv.idProduto = p.idProduto
    AND v.Data_Venda >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
);

--Produtos com maior e menor preço
SELECT Nome_Produto, Preco FROM Produto ORDER BY Preco DESC LIMIT 1;
SELECT Nome_Produto, Preco FROM Produto ORDER BY Preco ASC LIMIT 1;

--Produtos de um determinado fornecedor
SELECT p.Nome_Produto
FROM Produto p
JOIN Fornecedor f ON p.idFornecedor = f.idFornecedor
WHERE f.Nome_Fornecedor = 'Nome do Fornecedor';


-- -----------------------------------------------------
--RELATÓRIO DE CLIENTES
--Clientes por faixa de gasto
SELECT 
    CASE
        WHEN Total_Gasto < 100 THEN 'Menos de R$100'
        WHEN Total_Gasto BETWEEN 100 AND 500 THEN 'Entre R$100 e R$500'
        WHEN Total_Gasto > 500 THEN 'Mais de R$500'
    END AS Faixa_Gasto,
    COUNT(*) AS Total_Clientes
FROM (
    SELECT 
        c.Nome_Cliente, 
        SUM(v.Valor_Total) AS Total_Gasto
    FROM Cliente c
    JOIN Venda v ON c.idCliente = v.idCliente
    GROUP BY c.Nome_Cliente
) AS GastosPorCliente
GROUP BY Faixa_Gasto
ORDE BY Faixa_Gasto;

--Clientes que mais compram
SELECT 
    c.Nome_Cliente, 
    COUNT(v.idVenda) AS Total_Compras
FROM Cliente c
JOIN Venda v ON c.idCliente = v.idCliente
GROUP BY c.Nome_Cliente
ORDER BY Total_Compras DESC
LIMIT 10;

--Clientes que compraram em um determinado período
SELECT DISTINCT c.Nome_Cliente
FROM Cliente c
JOIN Venda v ON c.idCliente = v.idCliente
WHERE v.Data_Venda BETWEEN '2024-01-01' AND '2024-03-31';

--Informações de contato dos clientes
SELECT Nome_Cliente, Email, Telefone FROM Cliente;

--Número de clientes cadastrados por mês
SELECT 
    DATE_FORMAT(Data_Cadastro, '%Y-%m') AS Mes_Cadastro,
    COUNT(*) AS Total_Clientes
FROM Cliente
GROUP BY Mes_Cadastro
ORDER BY Mes_Cadastro;


-- -----------------------------------------------------
--RELATÓRIO DE ESTOQUE
--Valor total do estoque
SELECT SUM(e.Quantidade * p.Preco) AS Valor_Total_Estoque
FROM Estoque e
JOIN Produto p ON e.idProduto = p.idProduto;

--Produtos com maior e menor quantidade em estoque
SELECT p.Nome_Produto, e.Quantidade FROM Produto p JOIN Estoque e ON p.idProduto = e.idProduto ORDER BY e.Quantidade DESC LIMIT 1;
SELECT p.Nome_Produto, e.Quantidade FROM Produto p JOIN Estoque e ON p.idProduto = e.idProduto ORDER BY e.Quantidade ASC LIMIT 1;

--Estoque por categoria de produto
SELECT
    cp.Nome_Categoria,
    SUM(e.Quantidade * p.Preco) AS Valor_Total_Estoque
FROM Categoria_Produto cp
JOIN Produto p ON cp.idCategoria_Produto = p.idCategoria_Produto
JOIN Estoque e ON p.idProduto = e.idProduto
GROUP BY cp.Nome_Categoria
ORDER BY Valor_Total_Estoque DESC;


-- -----------------------------------------------------
--OUTROS RELATÓRIOS
--Promoções ativas
SELECT Nome_Promocao, Data_Inicio, Data_Fim, Desconto
FROM Promocao
WHERE Data_Inicio <= CURDATE() AND Data_Fim >= CURDATE();

--Total de vendas por forma de pagamento
SELECT
    Forma_Pagamento,
    COUNT(*) AS Total_Vendas,
    SUM(Valor_Total) AS Valor_Total
FROM Venda
GROUP BY Forma_Pagamento
ORDER BY Valor_Total DESC;



-- -----------------------------------------------------
--VIEWS
-- -----------------------------------------------------
-- 1. View para Total de vendas por período
CREATE VIEW vw_total_vendas_por_periodo AS
SELECT
    DATE(Data_Venda) AS Data,
    SUM(Valor_Total) AS Total_Vendas
FROM Venda
GROUP BY DATE(Data_Venda);

-- 2. View para Vendas por cliente
CREATE VIEW vw_vendas_por_cliente AS
SELECT
    c.Nome_Cliente,
    SUM(v.Valor_Total) AS Total_Gasto
FROM Cliente c
JOIN Venda v ON c.idCliente = v.idCliente
GROUP BY c.Nome_Cliente;

-- 3. View para Produtos mais vendidos
CREATE VIEW vw_produtos_mais_vendidos AS
SELECT
    p.Nome_Produto,
    SUM(iv.Quantidade) AS Total_Vendido
FROM Produto p
JOIN Item_Venda iv ON p.idProduto = iv.idProduto
JOIN Venda v ON iv.idVenda = v.idVenda
GROUP BY p.Nome_Produto;

-- 4. View para Vendas por funcionário
CREATE VIEW vw_vendas_por_funcionario AS
SELECT
    f.Nome_Funcionario,
    SUM(v.Valor_Total) AS Total_Vendas
FROM Funcionario f
JOIN Venda v ON f.idFuncionario = v.idFuncionario
GROUP BY f.Nome_Funcionario;

-- 5. View para Ticket médio por venda
CREATE VIEW vw_ticket_medio_venda AS
SELECT AVG(Valor_Total) AS Ticket_Medio FROM Venda;

-- 6. View para Produtos por categoria
CREATE VIEW vw_produtos_por_categoria AS
SELECT
    cp.Nome_Categoria,
    COUNT(p.idProduto) AS Total_Produtos
FROM Categoria_Produto cp
LEFT JOIN Produto p ON cp.idCategoria_Produto = p.idCategoria_Produto
GROUP BY cp.Nome_Categoria;

-- 7. View para Produtos com estoque baixo
CREATE VIEW vw_produtos_estoque_baixo AS
SELECT
    p.Nome_Produto,
    e.Quantidade
FROM Produto p
JOIN Estoque e ON p.idProduto = e.idProduto
WHERE e.Quantidade < 50;

-- 8. View para Produtos sem vendas nos últimos 30 dias
CREATE VIEW vw_produtos_sem_vendas_30dias AS
SELECT p.Nome_Produto
FROM Produto p
WHERE NOT EXISTS (
    SELECT 1
    FROM Item_Venda iv
    JOIN Venda v ON iv.idVenda = v.idVenda
    WHERE iv.idProduto = p.idProduto
    AND v.Data_Venda >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
);

-- 9. View para Produtos com maior preço
CREATE VIEW vw_produto_maior_preco AS
SELECT Nome_Produto, Preco FROM Produto ORDER BY Preco DESC LIMIT 1;

-- 10. View para Produtos com menor preço
CREATE VIEW vw_produto_menor_preco AS
SELECT Nome_Produto, Preco FROM Produto ORDER BY Preco ASC LIMIT 1;

-- 11. View para Estoque por categoria de produto
CREATE VIEW vw_estoque_por_categoria AS
    SELECT 
        cp.Nome_Categoria,
        SUM(e.Quantidade * p.Preco) AS Valor_Total_Estoque
    FROM Categoria_Produto cp
    JOIN Produto p ON cp.idCategoria_Produto = p.idCategoria_Produto
    JOIN Estoque e ON p.idProduto = e.idProduto
    GROUP BY cp.Nome_Categoria
    ORDER BY Valor_Total_Estoque DESC;
