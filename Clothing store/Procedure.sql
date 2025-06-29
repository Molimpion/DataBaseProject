DELIMITER $$

-- 1. Procedure para Registrar Nova Venda Completa (Simplificada para um ÚNICO produto por chamada)
-- Esta procedure registra uma nova venda, adiciona UM item da venda e atualiza o estoque do produto vendido.
CREATE PROCEDURE RegistrarNovaVendaCompleta(
    IN p_idCliente INT,
    IN p_idFuncionario INT,
    IN p_DataVenda DATE,
    IN p_Observacao TEXT,
    IN p_idProduto INT,         -- ID do produto
    IN p_quantidade INT,        -- Quantidade deste produto
    IN p_precoUnitario DECIMAL(10,2) -- Preço unitário deste produto
)
BEGIN
    DECLARE v_idVenda INT;
    DECLARE v_estoqueAtual INT;
    DECLARE v_valorTotalVenda DECIMAL(10,2);

    -- Inicia a transação
    START TRANSACTION;

    -- 1. Insere a nova venda com o valor inicial do item (será atualizado)
    INSERT INTO Venda (Data_Venda, Valor_Total, idCliente, idFuncionario, Observacoes)
    VALUES (p_DataVenda, (p_quantidade * p_precoUnitario), p_idCliente, p_idFuncionario, p_Observacao);

    SET v_idVenda = LAST_INSERT_ID();

    -- 2. Insere o item da venda
    INSERT INTO Item_Venda (Quantidade, Preco_Unitario, idProduto, idVenda)
    VALUES (p_quantidade, p_precoUnitario, p_idProduto, v_idVenda);

    -- 3. Obtém a quantidade atual do produto em estoque
    SELECT Quantidade INTO v_estoqueAtual
    FROM Estoque
    WHERE idProduto = p_idProduto;

    -- 4. Atualiza o estoque do produto (diminuindo a quantidade vendida)
    UPDATE Estoque
    SET Quantidade = v_estoqueAtual - p_quantidade
    WHERE idProduto = p_idProduto;

    -- 5. Atualiza o valor total da venda na tabela Venda
    -- (Para uma venda "completa" com vários itens, você chamaria esta procedure para cada item e precisaria de uma lógica de soma externa,
    -- ou aprimorar para uma procedure que adiciona item a uma venda *já existente* e atualiza o total dessa venda.)
    -- Neste formato simplificado, o Valor_Total da Venda é o valor do ÚNICO item inserido por esta chamada.
    SET v_valorTotalVenda = (p_quantidade * p_precoUnitario); -- Calcula o valor total para este item

    UPDATE Venda
    SET Valor_Total = v_valorTotalVenda
    WHERE idVenda = v_idVenda;

    -- Confirma a transação
    COMMIT;

END $$

-- 2. Procedure para Gerenciar Promoções de Produtos (Adicionar/Remover/Atualizar)
-- Esta procedure permite adicionar um produto a uma promoção, remover ou atualizar o desconto.
CREATE PROCEDURE GerenciarPromocaoProduto(
    IN p_idProduto INT,
    IN p_idPromocao INT,
    IN p_acao VARCHAR(10), -- 'ADICIONAR', 'REMOVER', 'ATUALIZAR'
    IN p_novoDesconto DECIMAL(5,2) -- Apenas para 'ATUALIZAR'
)
BEGIN
    DECLARE v_existe INT;

    -- 1. Verifica se a promoção e o produto existem (opcional, mas boa prática)
    SELECT COUNT(*) INTO v_existe FROM Promocao WHERE idPromocao = p_idPromocao;
    IF v_existe = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Promoção não encontrada.';
    END IF;

    SELECT COUNT(*) INTO v_existe FROM Produto WHERE idProduto = p_idProduto;
    IF v_existe = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Produto não encontrado.';
    END IF;

    IF p_acao = 'ADICIONAR' THEN
        -- 2. Adiciona o produto à promoção se ainda não estiver lá
        INSERT IGNORE INTO Produto_Promocao (idProduto, idPromocao)
        VALUES (p_idProduto, p_idPromocao);
        SELECT 'Produto adicionado à promoção com sucesso (se já não existia).' AS Mensagem;

    ELSEIF p_acao = 'REMOVER' THEN
        -- 3. Remove o produto da promoção
        DELETE FROM Produto_Promocao
        WHERE idProduto = p_idProduto AND idPromocao = p_idPromocao;
        SELECT 'Produto removido da promoção com sucesso (se existia).' AS Mensagem;

    ELSEIF p_acao = 'ATUALIZAR' THEN
        -- 4. Atualiza o desconto da promoção (na tabela Promocao)
        UPDATE Promocao
        SET Desconto = p_novoDesconto
        WHERE idPromocao = p_idPromocao;
        SELECT 'Desconto da promoção atualizado com sucesso.' AS Mensagem;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ação inválida. Use ADICIONAR, REMOVER ou ATUALIZAR.';
    END IF;

    -- 5. Consulta o status atual da promoção (para ADICIONAR/ATUALIZAR)
    SELECT Nome_Promocao, Data_Inicio, Data_Fim, Desconto, Ativo
    FROM Promocao
    WHERE idPromocao = p_idPromocao;

END $$

-- 3. Procedure para Atualizar Status de Produtos e Fornecedores
-- Altera o status de um produto (Ativo/Inativo) e o status do fornecedor principal do produto.
CREATE PROCEDURE AtualizarStatusProdutoFornecedor(
    IN p_idProduto INT,
    IN p_statusProduto ENUM('Ativo', 'Inativo')
)
BEGIN
    DECLARE v_idFornecedor INT;

    -- Inicia a transação
    START TRANSACTION;

    -- 1. Obtém o idFornecedor do produto
    SELECT idFornecedor INTO v_idFornecedor
    FROM Produto
    WHERE idProduto = p_idProduto;

    -- 2. Atualiza o status do produto
    UPDATE Produto
    SET Status = p_statusProduto
    WHERE idProduto = p_idProduto;

    -- 3. Verifica se o fornecedor existe e exibe uma mensagem
    -- Nota: A tabela Fornecedor do seu esquema original não tem uma coluna 'Ativo'.
    -- Para uma funcionalidade completa aqui, essa coluna precisaria ser adicionada.
    IF v_idFornecedor IS NOT NULL THEN
        SELECT CONCAT('Status do produto atualizado para ', p_statusProduto, '. Fornecedor associado (ID: ', v_idFornecedor, ') não tem status controlável diretamente por esta procedure.') AS Mensagem;
    END IF;

    -- 4. Registra a ação de atualização de produto
    -- (Este é um exemplo de comando SQL distinto. Para um log real, você precisaria de uma tabela de log.)
    -- SELECT 'Ação de atualização de status do produto registrada.' AS LogStatus;

    -- 5. Seleciona os dados atualizados do produto para confirmação
    SELECT Nome_Produto, Status, idFornecedor
    FROM Produto
    WHERE idProduto = p_idProduto;

    -- Confirma a transação
    COMMIT;

END $$

-- 4. Procedure para Gerar Relatório de Vendas Detalhado por Período e Funcionário
-- Gera um relatório detalhado de vendas incluindo informações do cliente e do produto.
CREATE PROCEDURE GerarRelatorioVendasDetalhado(
    IN p_DataInicio DATE,
    IN p_DataFim DATE,
    IN p_idFuncionario INT
)
BEGIN
    -- 1. Seleciona informações detalhadas da venda
    SELECT
        v.idVenda,
        v.Data_Venda,
        v.Valor_Total,
        c.Nome_Cliente,
        f.Nome_Funcionario,
        iv.Quantidade AS Quantidade_Vendida,
        iv.Preco_Unitario,
        p.Nome_Produto,
        p.Preco AS Preco_Produto_Cadastro
    FROM Venda v
    JOIN Cliente c ON v.idCliente = c.idCliente
    JOIN Funcionario f ON v.idFuncionario = f.idFuncionario
    JOIN Item_Venda iv ON v.idVenda = iv.idVenda
    JOIN Produto p ON iv.idProduto = p.idProduto
    WHERE v.Data_Venda BETWEEN p_DataInicio AND p_DataFim
    AND (p_idFuncionario IS NULL OR f.idFuncionario = p_idFuncionario)
    ORDER BY v.Data_Venda, v.idVenda;

    -- 2. Calcula o total de vendas para o período/funcionário
    SELECT SUM(Valor_Total) AS Total_Vendas_Periodo
    FROM Venda
    WHERE Data_Venda BETWEEN p_DataInicio AND p_DataFim
    AND (p_idFuncionario IS NULL OR idFuncionario = p_idFuncionario);

    -- 3. Conta o número de vendas realizadas
    SELECT COUNT(DISTINCT idVenda) AS Numero_Total_Vendas
    FROM Venda
    WHERE Data_Venda BETWEEN p_DataInicio AND p_DataFim
    AND (p_idFuncionario IS NULL OR idFuncionario = p_idFuncionario);

    -- 4. Identifica o produto mais vendido nesse período/funcionário
    SELECT p.Nome_Produto, SUM(iv.Quantidade) AS Total_Quantidade_Vendida
    FROM Venda v
    JOIN Item_Venda iv ON v.idVenda = iv.idVenda
    JOIN Produto p ON iv.idProduto = p.idProduto
    WHERE v.Data_Venda BETWEEN p_DataInicio AND p_DataFim
    AND (p_idFuncionario IS NULL OR v.idFuncionario = p_idFuncionario)
    GROUP BY p.Nome_Produto
    ORDER BY Total_Quantidade_Vendida DESC
    LIMIT 1;

END $$

-- 5. Procedure para Gerenciar Cadastro de Clientes (Adicionar/Atualizar/Excluir)
-- Permite adicionar, atualizar ou excluir informações de clientes.
CREATE PROCEDURE GerenciarCadastroCliente(
    IN p_acao VARCHAR(10), -- 'ADICIONAR', 'ATUALIZAR', 'EXCLUIR'
    IN p_idCliente INT, -- Necessário para ATUALIZAR/EXCLUIR
    IN p_nomeCliente VARCHAR(150),
    IN p_cpf VARCHAR(14),
    IN p_email VARCHAR(100),
    IN p_telefone VARCHAR(20),
    IN p_enderecoCompleto VARCHAR(200)
)
BEGIN
    IF p_acao = 'ADICIONAR' THEN
        -- 1. Adiciona um novo cliente
        INSERT INTO Cliente (Nome_Cliente, CPF, Email, Telefone, Endereco_Completo, Data_Cadastro)
        VALUES (p_nomeCliente, p_cpf, p_email, p_telefone, p_enderecoCompleto, CURDATE());
        SELECT 'Cliente adicionado com sucesso.' AS Mensagem, LAST_INSERT_ID() AS idNovoCliente;

    ELSEIF p_acao = 'ATUALIZAR' THEN
        -- 2. Atualiza informações de um cliente existente
        UPDATE Cliente
        SET
            Nome_Cliente = p_nomeCliente,
            CPF = p_cpf,
            Email = p_email,
            Telefone = p_telefone,
            Endereco_Completo = p_enderecoCompleto
        WHERE idCliente = p_idCliente;
        SELECT 'Cliente atualizado com sucesso.' AS Mensagem, p_idCliente AS idClienteAtualizado;

        -- 3. Verifica se a atualização afetou alguma linha
        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nenhum cliente encontrado com o ID fornecido para atualização.';
        END IF;

    ELSEIF p_acao = 'EXCLUIR' THEN
        -- 4. Exclui um cliente (e vendas associadas devido a CASCADE em algumas FKs se aplicável, ou via DELETE manual)
        -- Nota: Cuidado com a integridade referencial. Vendas e outros registros podem ter FKs para Cliente.
        -- Para o seu schema, a FK de Venda para Cliente é ON DELETE RESTRICT, então seria necessário deletar vendas primeiro.
        DELETE FROM Cliente
        WHERE idCliente = p_idCliente;
        SELECT 'Cliente excluído com sucesso.' AS Mensagem, p_idCliente AS idClienteExcluido;

        -- 5. Verifica se a exclusão afetou alguma linha
        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nenhum cliente encontrado com o ID fornecido para exclusão.';
        END IF;

    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ação inválida. Use ADICIONAR, ATUALIZAR ou EXCLUIR.';
    END IF;

    -- 6. Seleciona o registro do cliente após a operação (se ADICIONAR/ATUALIZAR)
    IF p_acao IN ('ADICIONAR', 'ATUALIZAR') THEN
        SELECT * FROM Cliente WHERE idCliente = IF(p_acao = 'ADICIONAR', LAST_INSERT_ID(), p_idCliente);
    END IF;

END $$

-- 6. Procedure para Auditoria de Estoque
-- Registra ajustes de estoque e, se necessário, alerta sobre baixo estoque.
CREATE PROCEDURE AuditoriaEstoque(
    IN p_idProduto INT,
    IN p_ajusteQuantidade INT, -- Quantidade a adicionar (positiva) ou remover (negativa)
    IN p_motivo VARCHAR(255),
    IN p_limiteAlerta INT -- Limite para acionar o alerta de baixo estoque
)
BEGIN
    DECLARE v_quantidadeAtual INT;
    DECLARE v_novaQuantidade INT;

    -- Inicia a transação
    START TRANSACTION;

    -- 1. Obtém a quantidade atual do produto em estoque
    SELECT Quantidade INTO v_quantidadeAtual
    FROM Estoque
    WHERE idProduto = p_idProduto;

    -- Verifica se o produto existe no estoque
    IF v_quantidadeAtual IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Produto não encontrado no estoque.';
    END IF;

    -- 2. Calcula a nova quantidade
    SET v_novaQuantidade = v_quantidadeAtual + p_ajusteQuantidade;

    -- Garante que a quantidade não seja negativa
    IF v_novaQuantidade < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ajuste resultaria em quantidade negativa em estoque.';
    END IF;

    -- 3. Atualiza a quantidade em estoque
    UPDATE Estoque
    SET Quantidade = v_novaQuantidade, Data_Entrada = CURDATE() -- Atualiza a data de entrada para o ajuste
    WHERE idProduto = p_idProduto;

    -- 4. Registra uma mensagem de sucesso ou alerta.
    IF v_novaQuantidade < p_limiteAlerta THEN
        SELECT CONCAT('ALERTA: O produto ', (SELECT Nome_Produto FROM Produto WHERE idProduto = p_idProduto), ' está com estoque baixo: ', v_novaQuantidade, ' unidades.') AS Alerta_Estoque;
    ELSE
        SELECT 'Ajuste de estoque realizado com sucesso.' AS Mensagem;
    END IF;

    -- 5. Seleciona os dados atualizados do estoque para verificação
    SELECT p.Nome_Produto, e.Quantidade FROM Produto p JOIN Estoque e ON p.idProduto = e.idProduto WHERE p.idProduto = p_idProduto;

    -- Confirma a transação
    COMMIT;

END $$

DELIMITER ;
