DELIMITER $$

-- 1. Trigger: `trg_AtualizarEstoqueAposVenda`
-- Garante que o estoque de um produto seja reduzido automaticamente após a inserção de um item de venda.
-- Evento: AFTER INSERT na tabela Item_Venda
CREATE TRIGGER trg_AtualizarEstoqueAposVenda
AFTER INSERT ON Item_Venda
FOR EACH ROW
BEGIN
    UPDATE Estoque
    SET Quantidade = Quantidade - NEW.Quantidade
    WHERE idProduto = NEW.idProduto;
END $$

-- 2. Trigger: `trg_PrevenirEstoqueNegativo`
-- Impede que a quantidade em estoque de um produto se torne negativa.
-- Evento: BEFORE UPDATE na tabela Estoque (quando a quantidade é alterada)
CREATE TRIGGER trg_PrevenirEstoqueNegativo
BEFORE UPDATE ON Estoque
FOR EACH ROW
BEGIN
    IF NEW.Quantidade < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: A quantidade em estoque não pode ser negativa.';
    END IF;
END $$

-- 3. Trigger: `trg_RegistrarAlteracaoPrecoProduto`
-- Registra um log quando o preço de um produto é alterado.
-- Para esta trigger, assumimos uma tabela de log simples:
-- CREATE TABLE Log_Preco_Produto (
--     idLog INT AUTO_INCREMENT PRIMARY KEY,
--     idProduto INT,
--     Preco_Antigo DECIMAL(10,2),
--     Preco_Novo DECIMAL(10,2),
--     Data_Alteracao DATETIME DEFAULT NOW(),
--     Usuario VARCHAR(100) DEFAULT USER()
-- );
-- Evento: AFTER UPDATE na tabela Produto (quando o preço muda)
CREATE TRIGGER trg_RegistrarAlteracaoPrecoProduto
AFTER UPDATE ON Produto
FOR EACH ROW
BEGIN
    IF OLD.Preco <> NEW.Preco THEN
        INSERT INTO Log_Preco_Produto (idProduto, Preco_Antigo, Preco_Novo, Data_Alteracao, Usuario)
        VALUES (NEW.idProduto, OLD.Preco, NEW.Preco, NOW(), USER());
    END IF;
END $$

-- 4. Trigger: `trg_AtualizarValorTotalVenda`
-- Atualiza o Valor_Total na tabela Venda sempre que um item_venda é alterado (atualizado ou deletado).
-- Esta é crucial para manter a integridade do Valor_Total da Venda.
-- Evento: AFTER UPDATE e AFTER DELETE na tabela Item_Venda
CREATE TRIGGER trg_AtualizarValorTotalVenda_AU
AFTER UPDATE ON Item_Venda
FOR EACH ROW
BEGIN
    -- Atualiza o valor total da venda para o ID da venda antiga e da nova, caso o idVenda tenha mudado (raro, mas possível)
    UPDATE Venda
    SET Valor_Total = (SELECT COALESCE(SUM(Quantidade * Preco_Unitario), 0) FROM Item_Venda WHERE idVenda = NEW.idVenda)
    WHERE idVenda = NEW.idVenda;

    IF OLD.idVenda <> NEW.idVenda THEN -- Se o item mudou de venda (caso improvável)
        UPDATE Venda
        SET Valor_Total = (SELECT COALESCE(SUM(Quantidade * Preco_Unitario), 0) FROM Item_Venda WHERE idVenda = OLD.idVenda)
        WHERE idVenda = OLD.idVenda;
    END IF;
END $$

CREATE TRIGGER trg_AtualizarValorTotalVenda_AD
AFTER DELETE ON Item_Venda
FOR EACH ROW
BEGIN
    -- Atualiza o valor total da venda para o ID da venda do item deletado
    UPDATE Venda
    SET Valor_Total = (SELECT COALESCE(SUM(Quantidade * Preco_Unitario), 0) FROM Item_Venda WHERE idVenda = OLD.idVenda)
    WHERE idVenda = OLD.idVenda;
END $$

-- 5. Trigger: `trg_DefinirDataCadastroCliente`
-- Define automaticamente a Data_Cadastro para a data atual no momento da inserção de um novo cliente, se não for fornecida.
-- Evento: BEFORE INSERT na tabela Cliente
CREATE TRIGGER trg_DefinirDataCadastroCliente
BEFORE INSERT ON Cliente
FOR EACH ROW
BEGIN
    IF NEW.Data_Cadastro IS NULL THEN
        SET NEW.Data_Cadastro = CURDATE();
    END IF;
END $$

-- 6. Trigger: `trg_ValidarDataPromocao`
-- Impede que uma promoção seja criada ou atualizada com Data_Fim anterior à Data_Inicio.
-- Evento: BEFORE INSERT e BEFORE UPDATE na tabela Promocao
CREATE TRIGGER trg_ValidarDataPromocao_BI
BEFORE INSERT ON Promocao
FOR EACH ROW
BEGIN
    IF NEW.Data_Fim < NEW.Data_Inicio THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: Data_Fim da promoção não pode ser anterior à Data_Inicio.';
    END IF;
END $$

CREATE TRIGGER trg_ValidarDataPromocao_BU
BEFORE UPDATE ON Promocao
FOR EACH ROW
BEGIN
    IF NEW.Data_Fim < NEW.Data_Inicio THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: Data_Fim da promoção não pode ser anterior à Data_Inicio.';
    END IF;
END $$

DELIMITER ;
