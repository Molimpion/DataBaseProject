-------------------------------------------------------
--inserts de dados
-------------------------------------------------------
INSERT INTO Categoria_Produto (Nome_Categoria) VALUES
('Camisetas'),
('Calças'),
('Saias'),
('Vestidos'),
('Acessórios'),
('Blusas'),
('Shorts'),
('Macacões'),
('Casacos'),
('Bolsas');

INSERT INTO Fornecedor (Nome_Fornecedor, CNPJ, telefone, Email) VALUES
('EstiloModa', '12.345.678/0001-90', '(11) 98765-4321', 'contato@estilomoda.com.br'),
('FashionWear', '23.456.789/0001-80', '(21) 97890-1234', 'vendas@fashionwear.com.br'),
('Elegance', '34.567.890/0001-70', '(41) 96543-2109', 'pedidos@elegance.com.br'),
('ModaChic', '45.678.901/0001-60', '(31) 95432-1098', 'atendimento@modachic.com.br'),
('BestFashion', '56.789.012/0001-50', '(51) 94321-0987', 'comercial@bestfashion.com.br'),
('TopStyle', '67.890.123/0001-40', '(27) 91122-3344', 'info@topstyle.com.br'),
('TrendyLook', '78.901.234/0001-30', '(19) 92233-4455', 'sac@trendylook.com.br'),
('GlamourModas', '89.012.345/0001-20', '(81) 93344-5566', 'vendasweb@glamourmodas.com.br'),
('SempreBella', '90.123.456/0001-10', '(92) 94455-6677', 'faleconosco@semprebella.com.br'),
('ChicUrbano', '01.234.567/0001-09', '(62) 95566-7788', 'clientes@chicurbano.com.br');

INSERT INTO Produto (Nome_Produto, Preco, idCategoria_Produto, idFornecedor) VALUES
('Camiseta Básica', 29.99, 1, 1),
('Calça Jeans Skinny', 89.99, 2, 2),
('Saia Midi Floral', 59.99, 3, 3),
('Vestido Longo Estampado', 129.99, 4, 4),
('Colar Pedras', 49.99, 5, 5),
('Blusa de Tricô', 69.99, 6, 6),
('Shorts Jeans', 49.99, 7, 7),
('Macacão Pantacourt', 119.99, 8, 8),
('Casaco de Lã', 149.99, 9, 9),
('Bolsa Tiracolo', 79.99, 10, 10);

INSERT INTO Estoque (Quantidade, Data_Entrada, idProduto) VALUES
(150, '2025-01-10', 1),
(250, '2025-01-15', 2),
(200, '2025-01-20', 3),
(75, '2025-02-01', 4),
(50, '2025-02-05', 5),
(180, '2025-02-10', 6),
(220, '2025-02-15', 7),
(300, '2025-02-20', 8),
(90, '2025-03-01', 9),
(60, '2025-03-05', 10);

INSERT INTO Cliente (Nome_Cliente, CPF, Email, Telefone, Endereco) VALUES
('João Silva', '123.456.789-00', 'joao.silva@email.com', '(11) 91234-5678', 'Rua A, 100, Centro'),
('Maria Souza', '234.567.890-11', 'maria.souza@email.com', '(21) 92345-6789', 'Avenida B, 200, Copacabana'),
('Pedro Almeida', '345.678.901-22', 'pedro.almeida@email.com', '(41) 93456-7890', 'Rua C, 300, Batel'),
('Ana Oliveira', '456.789.012-33', 'ana.oliveira@email.com', '(31) 94567-8901', 'Avenida D, 400, Savassi'),
('Carlos Pereira', '567.890.123-44', 'carlos.pereira@email.com', '(51) 95678-9012', 'Rua E, 500, Moinhos de Vento'),
('Mariana Gomes', '678.901.234-55', 'mariana.gomes@email.com', '(81) 96789-0123', 'Rua F, 600, Boa Viagem'),
('Lucas Santos', '789.012.345-66', 'lucas.santos@email.com', '(27) 97890-1234', 'Avenida G, 700, Praia da Costa'),
('Fernanda Costa', '890.123.456-77', 'fernanda.costa@email.com', '(19) 98901-2345', 'Rua H, 800, Cambuí'),
('Gabriel Rocha', '901.234.567-88', 'gabriel.rocha@email.com', '(92) 99012-3456', 'Avenida I, 900, Adrianópolis'),
('Isabela Martins', '012.345.678-99', 'isabela.martins@email.com', '(62) 90123-4567', 'Rua J, 1000, Setor Oeste');

INSERT INTO Funcionario (Nome_Funcionario, CPF, Cargo, Email) VALUES
('Roberto Carlos', '678.901.234-55', 'Gerente', 'roberto.carlos@email.com'),
('Fernanda Lima', '789.012.345-66', 'Vendedor', 'fernanda.lima@email.com'),
('Ricardo Pereira', '890.123.456-77', 'Vendedor', 'ricardo.pereira@email.com'),
('Juliana Alves', '901.234.567-88', 'Caixa', 'juliana.alves@email.com'),
('Bruno Gagliasso', '012.345.678-99', 'Estoquista', 'bruno.gagliasso@email.com'),
('Camila Pitanga', '123.098.765-44', 'Vendedor', 'camila.pitanga@email.com'),
('Wagner Moura', '234.109.876-33', 'Caixa', 'wagner.moura@email.com'),
('Taís Araújo', '345.210.987-22', 'Estoquista', 'tais.araujo@email.com'),
('Lázaro Ramos', '456.321.098-11', 'Vendedor', 'lazaro.ramos@email.com'),
('Paola Oliveira', '567.432.109-00', 'Gerente', 'paola.oliveira@email.com');

INSERT INTO Venda (Data_Venda, Valor_Total, idCliente, idFuncionario) VALUES
('2025-03-01', 1300.00, 1, 1),
('2025-03-05', 100.00, 2, 2),
('2025-03-10', 75.00, 3, 3),
('2025-03-15', 50.00, 4, 4),
('2025-03-20', 1500.00, 5, 1),
('2025-03-22', 2600.00, 6, 2),
('2025-03-25', 140.00, 7, 3),
('2025-03-28', 20.00, 8, 4),
('2025-04-01', 40.00, 9, 5),
('2025-04-03', 800.00, 10, 6);

INSERT INTO Item_Venda (Quantidade, Preco_Unitario, idProduto, idVenda) VALUES
(2, 29.99, 1, 1),
(1, 89.99, 2, 1),
(1, 59.99, 3, 2),
(3, 129.99, 4, 3),
(2, 49.99, 5, 4),
(1, 69.99, 6, 5),
(2, 49.99, 7, 6),
(1, 119.99, 8, 7),
(1, 149.99, 9, 8),
(3, 79.99, 10, 9);

INSERT INTO Promocao (Nome_Promocao, Data_Inicio, Data_Fim, Desconto) VALUES
('Liquidação Verão', '2025-01-01', '2025-01-31', 0.10),
('Semana da Moda', '2025-03-15', '2025-03-21', 0.05),
('Black Friday', '2025-11-29', '2025-11-29', 0.20),
('Natal Fashion', '2025-12-20', '2025-12-25', 0.15),
('Dia do Estilo', '2025-04-23', '2025-04-23', 0.10);

INSERT INTO Produto_Promocao (idProduto, idPromocao) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 5),
(5, 4),
(6, 1),
(7, 1),
(8, 2),
(9, 5),
(10, 4);
