# TrioBDD Project

> Academic project developed by a trio for the Database course in the Systems Analysis and Development (ADS) program – SENAC.

## 👥 Project Members

- Maíra Lourenço (GitHub: [@MairaLourencoDEV](https://github.com/MairaLourencoDEV))
- Manoel Olímpio (GitHub: [@Molimpion](https://github.com/Molimpion))
- Victoria Zambom (GitHub: [@VicZambom](https://github.com/VicZambom))

## 📚 Description

This project aims to create the schema of a relational database using MySQL. The proposal involves modeling tables with primary keys, foreign keys, constraints, and coherent relationships to represent a commercial system with sales, promotions, products, and users functionalities.

## 🗃️ Database Structure

The database contains the following main tables:

- `Categoria_Produto` (Product Category): Stores product categories (`idCategoria_Produto` (PK, AI), `Nome_Categoria` (UNIQUE)).
- `Fornecedor` (Supplier): Contains supplier information (`idFornecedor` (PK, AI), `Nome_Fornecedor`, `CNPJ` (UNIQUE), `Telefone_Fornecedor`, `Email`).
- `Produto` (Product): Product details (`idProduto` (PK, AI), `Nome_Produto`, `Preco` (Price), `idCategoria_Produto` (FK), `idFornecedor` (FK), `Status`).
- `Estoque` (Stock): Manages inventory (`idEstoque` (PK, AI), `Quantidade` (Quantity), `Data_Entrada` (Entry Date), `idProduto` (FK)).
- `Cliente` (Customer): Customer information (`idCliente` (PK, AI), `Nome_Cliente`, `CPF` (Brazilian ID), `Email` (NOT NULL), `Telefone` (Phone), `Endereco_Completo` (Full Address), `Data_Cadastro` (Registration Date)).
- `Funcionario` (Employee): Employee information (`idFuncionario` (PK, AI), `Nome_Funcionario`, `CPF` (Brazilian ID), `Email`, `Ativo` (Active)).
- `Venda` (Sale): Records sales (`idVenda` (PK, AI), `Data_Venda` (Sale Date), `Valor_Total` (Total Value), `idCliente` (FK), `idFuncionario` (FK), `Observacoes` (Observations)).
- `Item_Venda` (Sale Item): Details of items in each sale (`idItem_Venda` (PK, AI), `Quantidade` (Quantity), `Preco_Unitario` (Unit Price), `idProduto` (FK), `idVenda` (FK)).
- `Promocao` (Promotion): Information about promotions (`idPromocao` (PK, AI), `Nome_Promocao`, `Data_Inicio` (Start Date), `Data_Fim` (End Date), `Desconto` (Discount), `Ativo` (Active)).
- `Produto_Promocao` (Product_Promotion): Links products to promotions (`idProduto_Promocao` (PK, AI), `idProduto` (FK), `idPromocao` (FK), `idFornecedor` (FK)).

Each table uses primary keys (`PRIMARY KEY`), foreign keys (`FOREIGN KEY`) for relationships, `AUTO_INCREMENT` for IDs, and referential integrity via `ON DELETE` and `ON UPDATE`.

In addition to table creation, `ALTER TABLE` statements were used to add columns (`Status` in `Produto`, `Data_Cadastro` in `Cliente`, `Observacao`/`Observacoes` in `Venda`, `Ativo` in `Promocao` and `Funcionario`, `idFornecedor` in `Produto_Promocao`), modify data types (`Telefone` and `CNPJ`), rename columns (`Endereco` to `Endereco_Completo`, `telefone` to `Telefone_Fornecedor`), and remove columns (`Cargo` from `Funcionario`).

## 👓 Created Views

The following views were created to facilitate specific queries and analyses:

- `vw_total_vendas_por_periodo` (Total sales by period)
- `vw_vendas_por_cliente` (Sales by customer)
- `vw_produtos_mais_vendidos` (Best-selling products)
- `vw_vendas_por_funcionario` (Sales by employee)
- `vw_ticket_medio_venda` (Average sale ticket)
- `vw_produtos_por_categoria` (Products by category)
- `vw_produtos_estoque_baixo` (Low stock products)
- `vw_produtos_sem_vendas_30dias` (Products without sales in 30 days)
- `vw_produto_maior_preco` (Product with highest price)
- `vw_produto_menor_preco` (Product with lowest price)
- `vw_estoque_por_categoria` (Stock by category)

## 📊 Example Queries

The database allows for various analytical queries, such as:

- Listing the total sales per day.
- Checking the total spent by each customer.
- Identifying the top 10 best-selling products in a period.
- Calculating the average sales ticket.
- Listing products with stock below 50 units.
- And many others (see the SQL scripts for more `SELECT` examples).

## 🛠️ Technologies Used

- MySQL 8.x
- Workbench
- Git & GitHub

## 📄 SQL Scripts

The table creation scripts are available in the main folder of this repository. To execute them:

1. Create the database:
   ```sql
   CREATE DATABASE IF NOT EXISTS mydb;
   USE mydb;
