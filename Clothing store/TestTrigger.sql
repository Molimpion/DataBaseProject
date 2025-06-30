--tabela necessaria para salvar os registros da trigger
CREATE TABLE Log_Preco_Produto (
    idLog INT AUTO_INCREMENT PRIMARY KEY,
    idProduto INT,
    Preco_Antigo DECIMAL(10,2),
    Preco_Novo DECIMAL(10,2),
    Data_Alteracao DATETIME DEFAULT NOW(),
    Usuario VARCHAR(100) DEFAULT USER()
);

USE mydb;

-- --- TESTES DOS TRIGGERS ---

-- Preparação: Verifica estado inicial
SELECT '--- Estado Inicial ---' AS 'Status';
SELECT idProduto, Quantidade FROM Estoque WHERE idProduto = 1; -- Camiseta Básica
SELECT idVenda, Valor_Total FROM Venda WHERE idVenda = 1; -- Venda existente (se tiver)
SELECT idProduto, Preco FROM Produto WHERE idProduto = 1; -- Preço do produto
SELECT COUNT(*) FROM Log_Preco_Produto;
SELECT idCliente, Nome_Cliente, Data_Cadastro FROM Cliente ORDER BY idCliente DESC LIMIT 1;
SELECT idPromocao, Nome_Promocao, Data_Inicio, Data_Fim FROM Promocao WHERE idPromocao = 6; -- Use um ID de promoção que possa ser modificado/inserido para teste


-- 1. Teste do Trigger: `trg_AtualizarEstoqueAposVenda`
-- Este trigger é ativado ao inserir um Item_Venda.
SELECT '--- Teste: trg_AtualizarEstoqueAposVenda ---' AS 'Status';
-- Adiciona um novo item à Venda 1 (se a Venda 1 existir, se não, use um idVenda válido ou crie uma venda antes)
-- Assume que Venda 1 e Produto 1 existem.
-- Estoque do produto 1 deve diminuir.
INSERT INTO Item_Venda (Quantidade, Preco_Unitario, idProduto, idVenda)
VALUES (3, 35.00, 1, 1); -- Adicionando 3 Camisetas Básicas à Venda 1

SELECT idProduto, Quantidade FROM Estoque WHERE idProduto = 1; -- Verifica o estoque


-- 2. Teste do Trigger: `trg_PrevenirEstoqueNegativo`
-- Este trigger impede que o estoque se torne negativo.
SELECT '--- Teste: trg_PrevenirEstoqueNegativo ---' AS 'Status';
-- Tentativa de atualizar o estoque do Produto 1 para um valor negativo.
-- Isso deve gerar um erro.
-- USE APENAS PARA TESTE, POIS IRÁ CAUSAR UM ERRO E PARAR A EXECUÇÃO SE O CLIENTE SQL FOR CONFIGURADO PARA ISSO.
-- Para ver o erro, execute esta linha separadamente.
-- UPDATE Estoque SET Quantidade = -5 WHERE idProduto = 1;

-- Atualização válida (não negativa)
UPDATE Estoque SET Quantidade = 50 WHERE idProduto = 1;
SELECT idProduto, Quantidade FROM Estoque WHERE idProduto = 1;


-- 3. Teste do Trigger: `trg_RegistrarAlteracaoPrecoProduto`
-- Este trigger registra alterações de preço de produto em Log_Preco_Produto.
SELECT '--- Teste: trg_RegistrarAlteracaoPrecoProduto ---' AS 'Status';
-- Altera o preço do Produto 1.
UPDATE Produto SET Preco = 36.50 WHERE idProduto = 1;
SELECT idProduto, Preco FROM Produto WHERE idProduto = 1;
SELECT * FROM Log_Preco_Produto ORDER BY Data_Alteracao DESC LIMIT 1; -- Verifica o log


-- 4. Teste dos Triggers: `trg_AtualizarValorTotalVenda_AU` e `trg_AtualizarValorTotalVenda_AD`
-- Estes triggers atualizam o Valor_Total da Venda.
SELECT '--- Teste: trg_AtualizarValorTotalVenda ---' AS 'Status';
SELECT idVenda, Valor_Total FROM Venda WHERE idVenda = 1; -- Valor antes

-- 4.1 Teste AU (Atualização de Item_Venda):
-- Altera a quantidade de um item na Venda 1 (o item que acabamos de inserir, ou um existente).
-- O Valor_Total da Venda 1 deve ser atualizado automaticamente.
UPDATE Item_Venda
SET Quantidade = 5, Preco_Unitario = 30.00 -- Altera a quantidade e o preço unitário do último item inserido na venda 1
WHERE idVenda = 1 AND idProduto = 1 ORDER BY idItem_Venda DESC LIMIT 1;

SELECT idVenda, Valor_Total FROM Venda WHERE idVenda = 1; -- Valor após atualização

-- 4.2 Teste AD (Deleção de Item_Venda):
-- Deleta um item da Venda 1.
-- O Valor_Total da Venda 1 deve ser atualizado automaticamente.
DELETE FROM Item_Venda WHERE idVenda = 1 AND idProduto = 1 AND Quantidade = 5; -- Deleta o item que acabamos de alterar

SELECT idVenda, Valor_Total FROM Venda WHERE idVenda = 1; -- Valor após deleção


-- 5. Teste do Trigger: `trg_DefinirDataCadastroCliente`
-- Este trigger define a Data_Cadastro para novos clientes.
SELECT '--- Teste: trg_DefinirDataCadastroCliente ---' AS 'Status';
-- Insere um novo cliente sem especificar Data_Cadastro.
INSERT INTO Cliente (Nome_Cliente, CPF, Email, Telefone, Endereco_Completo)
VALUES ('Novo Cliente Teste Trigger', '111.111.111-13', 'trigger@cliente.com', '(11) 99999-0000', 'Rua da Trigger, 10');

SELECT idCliente, Nome_Cliente, Data_Cadastro FROM Cliente ORDER BY idCliente DESC LIMIT 1; -- Verifica a data de cadastro


-- 6. Teste dos Triggers: `trg_ValidarDataPromocao_BI` e `trg_ValidarDataPromocao_BU`
-- Estes triggers validam as datas de início e fim da promoção.
SELECT '--- Teste: trg_ValidarDataPromocao ---' AS 'Status';

-- 6.1 Teste BI (INSERT inválido):
-- Tentativa de inserir uma promoção com Data_Fim antes de Data_Inicio.
-- Isso deve gerar um erro.
-- USE APENAS PARA TESTE, POIS IRÁ CAUSAR UM ERRO.
-- INSERT INTO Promocao (Nome_Promocao, Data_Inicio, Data_Fim, Desconto, Ativo)
-- VALUES ('Promo Invalida', '2025-07-01', '2025-06-01', 0.10, TRUE);

-- Inserção válida:
INSERT INTO Promocao (Nome_Promocao, Data_Inicio, Data_Fim, Desconto, Ativo)
VALUES ('Promo Valida Teste', '2025-07-01', '2025-07-31', 0.05, TRUE);
SELECT idPromocao, Nome_Promocao, Data_Inicio, Data_Fim FROM Promocao ORDER BY idPromocao DESC LIMIT 1;

-- 6.2 Teste BU (UPDATE inválido):
-- Tenta atualizar uma promoção existente para ter Data_Fim antes de Data_Inicio.
-- Isso deve gerar um erro.
-- USE APENAS PARA TESTE, POIS IRÁ CAUSAR UM ERRO.
-- UPDATE Promocao SET Data_Fim = '2025-01-01' WHERE idPromocao = (SELECT idPromocao FROM Promocao ORDER BY idPromocao DESC LIMIT 1);

-- Atualização válida:
UPDATE Promocao SET Desconto = 0.07 WHERE idPromocao = (SELECT idPromocao FROM Promocao ORDER BY idPromocao DESC LIMIT 1);
SELECT idPromocao, Nome_Promocao, Desconto FROM Promocao ORDER BY idPromocao DESC LIMIT 1;
