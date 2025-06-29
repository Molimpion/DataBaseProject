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

-- 2. Função: ObterIdadeCliente
-- Retorna a idade de um cliente com base na sua data de nascimento.
-- Assume que a tabela Cliente possui uma coluna Data_Nascimento (se não tiver, este é um exemplo conceitual)
-- Se a coluna Data_Nascimento não existir, você pode adicionar:
-- ALTER TABLE Cliente ADD COLUMN Data_Nascimento DATE;
-- UPDATE Cliente SET Data_Nascimento = '1990-05-15' WHERE idCliente = 1; (Exemplo)
CREATE FUNCTION ObterIdadeCliente(p_idCliente INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_dataNascimento DATE;
    DECLARE v_idade INT;

    SELECT Data_Nascimento INTO v_dataNascimento
    FROM Cliente
    WHERE idCliente = p_idCliente;

    IF v_dataNascimento IS NULL THEN
        RETURN NULL; -- Ou 0, dependendo da regra de negócio para data de nascimento ausente
    END IF;

    SET v_idade = TIMESTAMPDIFF(YEAR, v_dataNascimento, CURDATE());

    RETURN v_idade;
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

-- 4. Função: CalcularDescontoPromocional
-- Retorna o preço de um produto após aplicar o desconto de uma promoção, se aplicável.
-- Retorna o preço original se não houver promoção ou o produto não estiver nela.
CREATE FUNCTION CalcularDescontoPromocional(p_idProduto INT, p_idPromocao INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_precoOriginal DECIMAL(10,2);
    DECLARE v_desconto DECIMAL(5,2);
    DECLARE v_precoComDesconto DECIMAL(10,2);
    DECLARE v_dataInicio DATE;
    DECLARE v_dataFim DATE;

    -- 1. Obtém o preço original do produto
    SELECT Preco INTO v_precoOriginal
    FROM Produto
    WHERE idProduto = p_idProduto;

    IF v_precoOriginal IS NULL THEN
        RETURN NULL; -- Produto não encontrado
    END IF;

    -- 2. Tenta obter o desconto e datas da promoção se o produto estiver nela e a promoção estiver ativa
    SELECT p.Desconto, p.Data_Inicio, p.Data_Fim
    INTO v_desconto, v_dataInicio, v_dataFim
    FROM Promocao p
    JOIN Produto_Promocao pp ON p.idPromocao = pp.idPromocao
    WHERE pp.idProduto = p_idProduto
    AND p.idPromocao = p_idPromocao
    AND p.Ativo = TRUE
    AND CURDATE() BETWEEN p.Data_Inicio AND p.Data_Fim;

    -- 3. Se um desconto válido for encontrado, aplica-o
    IF v_desconto IS NOT NULL THEN
        SET v_precoComDesconto = v_precoOriginal * (1 - v_desconto);
    ELSE
        SET v_precoComDesconto = v_precoOriginal; -- Nenhum desconto aplicável, retorna o preço original
    END IF;

    RETURN v_precoComDesconto;
END $$

-- 5. Função: ObterNomeClientePorCPF
-- Retorna o nome completo de um cliente dado o seu CPF.
CREATE FUNCTION ObterNomeClientePorCPF(p_cpf VARCHAR(14))
RETURNS VARCHAR(150)
READS SQL DATA
BEGIN
    DECLARE v_nomeCliente VARCHAR(150);
    SELECT Nome_Cliente INTO v_nomeCliente
    FROM Cliente
    WHERE CPF = p_cpf;

    IF v_nomeCliente IS NULL THEN
        RETURN 'Cliente não encontrado';
    END IF;

    RETURN v_nomeCliente;
END $$

-- 6. Função: ContarVendasPorFuncionarioNoMes
-- Retorna o número de vendas realizadas por um funcionário em um determinado mês e ano.
CREATE FUNCTION ContarVendasPorFuncionarioNoMes(p_idFuncionario INT, p_mes INT, p_ano INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_totalVendas INT;

    SELECT COUNT(idVenda)
    INTO v_totalVendas
    FROM Venda
    WHERE idFuncionario = p_idFuncionario
    AND MONTH(Data_Venda) = p_mes
    AND YEAR(Data_Venda) = p_ano;

    RETURN v_totalVendas;
END $$

DELIMITER ;
