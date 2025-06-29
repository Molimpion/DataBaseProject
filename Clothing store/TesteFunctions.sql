USE mydb;

-- 1. Teste da Função: CalcularValorTotalVendaPorId
-- Substitua '1' por um ID de venda real existente no seu banco.
SELECT CalcularValorTotalVendaPorId(1) AS ValorTotalDaPrimeiraVenda;


-- 2. Teste da Função: ObterQuantidadeProdutosPorCategoria
-- Substitua '1' por um ID de categoria real existente (ex: Roupas Femininas).
SELECT ObterQuantidadeProdutosPorCategoria(1) AS QtdProdutosCategoria1;
-- Teste com uma categoria que pode não ter produtos (ou um ID inexistente)
SELECT ObterQuantidadeProdutosPorCategoria(999) AS QtdProdutosCategoriaInexistente;


-- 3. Teste da Função: VerificarEstoqueDisponivel
-- Verifica a quantidade disponível de produtos no estoque.
SELECT VerificarEstoqueDisponivel(1) AS EstoqueProduto1CamisetaBasica;    -- ID 1: Camiseta Básica
SELECT VerificarEstoqueDisponivel(2) AS EstoqueProduto2CalcaJeansSkinny; -- ID 2: Calça Jeans Skinny
SELECT VerificarEstoqueDisponivel(999) AS EstoqueProdutoInexistente;


-- 4. Teste da Função: ObterPrecoMedioCategoria
-- Retorna o preço médio dos produtos na Categoria 1 (substitua por um ID real se necessário).
SELECT ObterPrecoMedioCategoria(1) AS PrecoMedioCategoria1;
-- Teste com uma categoria sem produtos ou inexistente
SELECT ObterPrecoMedioCategoria(999) AS PrecoMedioCategoriaInexistente;


-- 5. Teste da Função: ObterNomeFuncionarioPorId
-- Retorna o nome de funcionários específicos.
SELECT ObterNomeFuncionarioPorId(1) AS NomeFuncionario1RobertoCarlos;
SELECT ObterNomeFuncionarioPorId(2) AS NomeFuncionario2FernandaLima;
SELECT ObterNomeFuncionarioPorId(999) AS NomeFuncionarioInexistente;


-- 6. Teste da Função: ContarItensVendidosPorProduto
-- Conta o total de um produto específico vendido (use um ID de produto que você sabe que foi vendido).
SELECT ContarItensVendidosPorProduto(1) AS TotalVendidoProduto1CamisetaBasica;
SELECT ContarItensVendidosPorProduto(5) AS TotalVendidoProduto5ColarPedras;
SELECT ContarItensVendidosPorProduto(999) AS TotalVendidoProdutoInexistente;
