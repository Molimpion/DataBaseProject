-- -----------------------------------------------------
--Alterações nas estruturas das tabelas
-- -----------------------------------------------------
ALTER TABLE Produto
ADD COLUMN Status ENUM('Ativo', 'Inativo') DEFAULT 'Ativo';

ALTER TABLE Cliente
MODIFY COLUMN Telefone VARCHAR(20);

ALTER TABLE Cliente
ADD COLUMN Data_Cadastro DATE DEFAULT CURRENT_DATE;

ALTER TABLE Cliente
CHANGE COLUMN Endereco Endereco_Completo VARCHAR(200);

ALTER TABLE Funcionario
DROP COLUMN Cargo;

ALTER TABLE Venda
ADD COLUMN Observacao TEXT NULL;

ALTER TABLE Fornecedor
MODIFY COLUMN CNPJ CHAR(18);

ALTER TABLE Promocao
ADD COLUMN Ativo BOOLEAN DEFAULT TRUE;

ALTER TABLE Fornecedor
CHANGE COLUMN telefone Telefone_Fornecedor VARCHAR(15);

ALTER TABLE Cliente
MODIFY COLUMN Nome_Cliente VARCHAR(150);

ALTER TABLE Venda
ADD COLUMN Observacoes TEXT NULL;

ALTER TABLE Item_Venda
MODIFY COLUMN Preco_Unitario DECIMAL(12,2);

ALTER TABLE Funcionario
ADD COLUMN Ativo BOOLEAN DEFAULT TRUE;

ALTER TABLE Produto_Promocao
ADD COLUMN idFornecedor INT NULL,
ADD CONSTRAINT fk_ProdPromo_Fornecedor
FOREIGN KEY (idFornecedor) REFERENCES Fornecedor(idFornecedor);

ALTER TABLE Cliente
MODIFY COLUMN Email VARCHAR(100) NOT NULL;
