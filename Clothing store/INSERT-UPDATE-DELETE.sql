-- SQL: DML - UPDATE

UPDATE Cliente
SET Email = 'joao.silva.novo@email.com'
WHERE Nome_Cliente = 'João Silva';

UPDATE Fornecedor
SET telefone = '(11) 99887-7654'
WHERE Nome_Fornecedor = 'EstiloModa';

UPDATE Produto
SET Preco = 34.99
WHERE Nome_Produto = 'Camiseta Básica';

UPDATE Estoque
SET Quantidade = 150
WHERE idProduto = 1;

UPDATE Funcionario
SET Cargo = 'Gerente de Vendas'
WHERE Nome_Funcionario = 'Fernanda Lima';

UPDATE Venda
SET Valor_Total = 1400.00
WHERE idVenda = 1;

UPDATE Item_Venda
SET Preco_Unitario = 34.99
WHERE idProduto = 1
  AND idVenda = 1;

UPDATE Promocao
SET Data_Fim = '2024-02-15'
WHERE Nome_Promocao = 'Liquidação Verão';

UPDATE Categoria_Produto
SET Nome_Categoria = 'Camisas'
WHERE Nome_Categoria = 'Camisetas';

-- SQL: DML - DELETE

DELETE FROM Cliente
WHERE Nome_Cliente = 'Carlos Pereira';

DELETE FROM Fornecedor
WHERE Nome_Fornecedor = 'BestFashion';

DELETE FROM Produto
WHERE Nome_Produto = 'Brinco Argola';

DELETE FROM Estoque
WHERE idProduto = 10;

DELETE FROM Funcionario
WHERE Nome_Funcionario = 'Bruno Gagliasso';

DELETE FROM Venda
WHERE idVenda = 10;

DELETE FROM Item_Venda
WHERE idProduto = 10
  AND idVenda = 10;

DELETE FROM Promocao
WHERE Nome_Promocao = 'Dia do Estilo';

DELETE FROM Produto_Promocao
WHERE idProduto = 10
  AND idPromocao = 4;

DELETE FROM Categoria_Produto
WHERE Nome_Categoria = 'Acessórios';

DELETE FROM Venda
WHERE Data_Venda < '2024-03-01';

DELETE FROM Produto
WHERE idProduto NOT IN (SELECT DISTINCT idProduto FROM Estoque);
