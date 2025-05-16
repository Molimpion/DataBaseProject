# DataBaseProject

# TrioBDD Project

> Projeto acadêmico desenvolvido em trio para a disciplina de Banco de Dados no curso de Análise e Desenvolvimento de Sistemas (ADS) – SENAC.

## 👥 Integrantes do Projeto

- Maíra Lourenço (GitHub: [@MairaLourencoDEV](https://github.com/MairaLourencoDEV))
- Manoel Olímpio (GitHub: [@Molimpion](https://github.com/Molimpion))
- Victoria Zambom (GitHub: [@VicZambom](https://github.com/VicZambom))

## 📚 Descrição

Este projeto tem como objetivo a criação do esquema de um banco de dados relacional utilizando MySQL. A proposta envolve modelar tabelas com chaves primárias, estrangeiras, constraints e relacionamentos coerentes para representar um sistema comercial com funcionalidades de vendas, promoções, produtos e usuários.

## 🗃️ Estrutura do Banco de Dados

O banco de dados contém as seguintes tabelas principais:

- `Categoria_Produto`: Armazena as categorias dos produtos (`idCategoria_Produto` (PK, AI), `Nome_Categoria` (UNIQUE)).
- `Fornecedor`: Contém informações dos fornecedores (`idFornecedor` (PK, AI), `Nome_Fornecedor`, `CNPJ` (UNIQUE), `Telefone_Fornecedor`, `Email`).
- `Produto`: Detalhes dos produtos (`idProduto` (PK, AI), `Nome_Produto`, `Preco`, `idCategoria_Produto` (FK), `idFornecedor` (FK), `Status`).
- `Estoque`: Gerencia o estoque (`idEstoque` (PK, AI), `Quantidade`, `Data_Entrada`, `idProduto` (FK)).
- `Cliente`: Informações dos clientes (`idCliente` (PK, AI), `Nome_Cliente`, `CPF` (UNIQUE), `Email` (NOT NULL), `Telefone`, `Endereco_Completo`, `Data_Cadastro`).
- `Funcionario`: Informações dos funcionários (`idFuncionario` (PK, AI), `Nome_Funcionario`, `CPF` (UNIQUE), `Email`, `Ativo`).
- `Venda`: Registra as vendas (`idVenda` (PK, AI), `Data_Venda`, `Valor_Total`, `idCliente` (FK), `idFuncionario` (FK), `Observacoes`).
- `Item_Venda`: Detalhes dos itens de cada venda (`idItem_Venda` (PK, AI), `Quantidade`, `Preco_Unitario`, `idProduto` (FK), `idVenda` (FK)).
- `Promocao`: Informações sobre as promoções (`idPromocao` (PK, AI), `Nome_Promocao`, `Data_Inicio`, `Data_Fim`, `Desconto`, `Ativo`).
- `Produto_Promocao`: Liga produtos a promoções (`idProduto_Promocao` (PK, AI), `idProduto` (FK), `idPromocao` (FK), `idFornecedor` (FK)).

Cada tabela utiliza chaves primárias (`PRIMARY KEY`), chaves estrangeiras (`FOREIGN KEY`) para relacionamentos, `AUTO_INCREMENT` para IDs e integridade referencial com `ON DELETE` e `ON UPDATE`.

Além da criação das tabelas, foram utilizadas instruções `ALTER TABLE` para adicionar colunas (`Status` em `Produto`, `Data_Cadastro` em `Cliente`, `Observacao`/`Observacoes` em `Venda`, `Ativo` em `Promocao` e `Funcionario`, `idFornecedor` em `Produto_Promocao`), modificar tipos de dados (`Telefone` e `CNPJ`), renomear colunas (`Endereco` para `Endereco_Completo`, `telefone` para `Telefone_Fornecedor`), e remover colunas (`Cargo` de `Funcionario`).

## 👓 Views Criadas

Foram criadas as seguintes views para facilitar consultas e análises específicas:

- `vw_total_vendas_por_periodo`
- `vw_vendas_por_cliente`
- `vw_produtos_mais_vendidos`
- `vw_vendas_por_funcionario`
- `vw_ticket_medio_venda`
- `vw_produtos_por_categoria`
- `vw_produtos_estoque_baixo`
- `vw_produtos_sem_vendas_30dias`
- `vw_produto_maior_preco`
- `vw_produto_menor_preco`
- `vw_estoque_por_categoria`

## 📊 Consultas (Exemplos)

O banco de dados permite realizar diversas consultas para análise, como:

- Listar o total de vendas por dia.
- Verificar o total gasto por cada cliente.
- Identificar os 10 produtos mais vendidos em um período.
- Calcular o ticket médio das vendas.
- Listar produtos com estoque abaixo de 50 unidades.
- E muitas outras (ver os scripts SQL para mais exemplos de `SELECT`).

## 🛠️ Tecnologias Utilizadas

- MySQL 8.x
- Workbench
- Git & GitHub

## 📄 Scripts SQL

Os scripts de criação das tabelas estão disponíveis na pasta principal deste repositório. Para executá-los:

1. Crie o banco de dados:
   ```sql
   CREATE DATABASE IF NOT EXISTS mydb;
   USE mydb;
