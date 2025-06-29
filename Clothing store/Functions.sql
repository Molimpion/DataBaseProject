DELIMITER $$

-- 1. Função: CalcularValorTotalVendaPorId
-- Retorna o valor total de uma venda específica, somando o valor de todos os seus itens.
CREATE FUNCTION CalcularValorTotalVendaPorId(p_idVenda INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2);
    SELECT SUM(Quantidade * Preco_Unitario)
    INTO v_total
    FROM Item_Venda
    WHERE idVenda = p_idVenda;

    -- Se a venda não tiver itens ou não existir, retorna 0
    IF v_total IS NULL THEN
        SET v_total = 0;
    END IF;

    RETURN v_total;
END $$

-- 2. Função: ObterQuantidadeProdutosPorCategoria
-- Retorna o número total de produtos em uma categoria específica.
CREATE FUNCTION ObterQuantidadeProdutosPorCategoria(p_idCategoria INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_quantidade INT;
    SELECT COUNT(idProduto)
    INTO v_quantidade
    FROM Produto
    WHERE idCategoria = p_idCategoria;

    RETURN v_quantidade;
END $$

-- 3. Função: VerificarEstoqueDisponivel
-- Retorna a quantidade disponível de um produto em estoque.
CREATE FUNCTION VerificarEstoqueDisponivel(p_idProduto INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_quantidade INT;
    SELECT Quantidade
    INTO v_quantidade
    FROM Estoque
    WHERE idProduto = p_idProduto;

    -- Se o produto não estiver no estoque, retorna 0
    IF v_quantidade IS NULL THEN
        SET v_quantidade = 0;
    END IF;

    RETURN v_quantidade;
END $$

-- 4. Função: ObterPrecoMedioCategoria
-- Retorna o preço médio dos produtos em uma categoria específica.
CREATE FUNCTION ObterPrecoMedioCategoria(p_idCategoria INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_precoMedio DECIMAL(10,2);
    SELECT AVG(Preco)
    INTO v_precoMedio
    FROM Produto
    WHERE idCategoria = p_idCategoria;

    IF v_precoMedio IS NULL THEN
        SET v_precoMedio = 0.00;
    END IF;

    RETURN v_precoMedio;
END $$

-- 5. Função: ObterNomeFuncionarioPorId
-- Retorna o nome completo de um funcionário dado o seu ID.
CREATE FUNCTION ObterNomeFuncionarioPorId(p_idFuncionario INT)
RETURNS VARCHAR(150)
READS SQL DATA
BEGIN
    DECLARE v_nomeFuncionario VARCHAR(150);
    SELECT Nome_Funcionario INTO v_nomeFuncionario
    FROM Funcionario
    WHERE idFuncionario = p_idFuncionario;

    IF v_nomeFuncionario IS NULL THEN
        RETURN 'Funcionário não encontrado';
    END IF;

    RETURN v_nomeFuncionario;
END $$

-- 6. Função: ContarItensVendidosPorProduto
-- Retorna o total de um produto específico vendido em todas as vendas.
CREATE FUNCTION ContarItensVendidosPorProduto(p_idProduto INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_totalVendido INT;
    SELECT SUM(Quantidade)
    INTO v_totalVendido
    FROM Item_Venda
    WHERE idProduto = p_idProduto;

    IF v_totalVendido IS NULL THEN
        SET v_totalVendido = 0;
    END IF;

    RETURN v_totalVendido;
END $$

DELIMITER ;
