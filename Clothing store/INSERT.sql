-- -----------------------------------------------------
--inserts de dados
-- -----------------------------------------------------
INSERT INTO Categoria_Produto (Nome_Categoria) VALUES
('Camisetas'),
('Calças'),
('Saias'),
('Vestidos'),
('Acessórios');

INSERT INTO Fornecedor (Nome_Fornecedor, CNPJ, telefone, Email) VALUES
('EstiloModa', '12.345.678/0001-90', '(11) 98765-4321', 'contato@estilomoda.com.br'),
('FashionWear', '23.456.789/0001-80', '(21) 97890-1234', 'vendas@fashionwear.com.br'),
('Elegance', '34.567.890/0001-70', '(41) 96543-2109', 'pedidos@elegance.com.br'),
('ModaChic', '45.678.901/0001-60', '(31) 95432-1098', 'atendimento@modachic.com.br'),
('BestFashion', '56.789.012/0001-50', '(51) 94321-0987', 'comercial@bestfashion.com.br');

INSERT INTO Produto (Nome_Produto, Preco, idCategoria_Produto, idFornecedor) VALUES
('Camiseta Básica', 29.99, 1, 1),
('Calça Jeans Skinny', 89.99, 2, 2),
('Saia Midi Floral', 59.99, 3, 3),
('Vestido Longo Estampado', 129.99, 4, 4),
('Colar Pedras', 49.99, 5, 5),
('Camiseta Listrada', 39.99, 1, 1),
('Calça Sarja', 79.99, 2, 2),
('Saia Lápis', 69.99, 3, 3),
('Vestido Curto', 99.99, 4, 4),
('Brinco Argola', 29.99, 5, 5);

INSERT INTO Estoque (Quantidade, Data_Entrada, idProduto) VALUES
(100, '2024-01-10', 1),
(200, '2024-01-15', 2),
(150, '2024-01-20', 3),
(50, '2024-02-01', 4),
(30, '2024-02-05', 5),
(120, '2024-02-10', 6),
(180, '2024-02-15', 7),
(250, '2024-02-20', 8),
(60, '2024-03-01', 9),
(40, '2024-03-05', 10);

INSERT INTO Cliente (Nome_Cliente, CPF, Email, Telefone, Endereco) VALUES
('João Silva', '123.456.789-00', 'joao.silva@email.com', '(11) 91234-5678', 'Rua A, 100, Centro'),
('Maria Souza', '234.567.890-11', 'maria.souza@email.com', '(21) 92345-6789', 'Avenida B, 200, Copacabana'),
('Pedro Almeida', '345.678.901-22', 'pedro.almeida@email.com', '(41) 93456-7890', 'Rua C, 300, Batel'),
('Ana Oliveira', '456.789.012-33', 'ana.oliveira@email.com', '(31) 94567-8901', 'Avenida D, 400, Savassi'),
('Carlos Pereira', '567.890.123-44', 'carlos.pereira@email.com', '(51) 95678-9012', 'Rua E, 500, Moinhos de Vento');

INSERT INTO Funcionario (Nome_Funcionario, CPF, Cargo, Email) VALUES
('Roberto Carlos', '678.901.234-55', 'Gerente', 'roberto.carlos@email.com'),
('Fernanda Lima', '789.012.345-66', 'Vendedor', 'fernanda.lima@email.com'),
('Ricardo Pereira', '890.123.456-77', 'Vendedor', 'ricardo.pereira@email.com'),
('Juliana Alves', '901.234.567-88', 'Caixa', 'juliana.alves@email.com'),
('Bruno Gagliasso', '012.345.678-99', 'Estoquista', 'bruno.gagliasso@email.com');

INSERT INTO Venda (Data_Venda, Valor_Total, idCliente, idFuncionario) VALUES
('2024-03-01', 1300.00, 1, 1),
('2024-03-05', 100.00, 2, 2),
('2024-03-10', 75.00, 3, 3),
('2024-03-15', 50.00, 4, 4),
('2024-03-20', 1500.00, 5, 1),
('2024-03-22', 2600.00, 1, 2),
('2024-03-25', 140.00, 2, 3),
('2024-03-28', 20.00, 3, 4),
('2024-04-01', 40.00, 4, 1),
('2024-04-03', 800.00, 5, 2);

INSERT INTO Item_Venda (Quantidade, Preco_Unitario, idProduto, idVenda) VALUES
(1, 29.99, 1, 1),
(1, 89.99, 2, 2),
(1, 59.99, 3, 3),
(1, 129.99, 4, 4),
(1, 49.99, 5, 5),
(2, 29.99, 6, 6),
(1, 39.99, 6, 6),
(2, 79.99, 7, 7),
(4, 69.99, 8, 8),
(1, 99.99, 9, 9),
(1, 29.99, 10, 10);

INSERT INTO Promocao (Nome_Promocao, Data_Inicio, Data_Fim, Desconto) VALUES
('Liquidação Verão', '2024-01-01', '2024-01-31', 0.10),
('Semana da Moda', '2024-03-15', '2024-03-21', 0.05),
('Black Friday', '2024-11-29', '2024-11-29', 0.20),
('Natal Fashion', '2024-12-20', '2024-12-25', 0.15),
('Dia do Estilo', '2024-04-23', '2024-04-23', 0.10);

INSERT INTO Produto_Promocao (idProduto, idPromocao) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 5),
(5, 4),
(6,1),
(7,1),
(8,2),
(9,5),
(10,4);
