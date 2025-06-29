-- 1. Teste da Procedure: RegistrarNovaVendaCompleta (Agora para UM produto por chamada)
-- Registra uma venda para o Cliente 1 (João Silva) e Funcionario 2 (Fernanda Lima)
-- com 2 unidades do Produto 1 (Camiseta Básica)
CALL RegistrarNovaVendaCompleta(1, 2, CURDATE(), 'Venda simplificada de uma camiseta.', 1, 2, 34.99);

-- Para verificar o resultado:
-- SELECT * FROM Venda ORDER BY idVenda DESC LIMIT 1;
-- SELECT * FROM Item_Venda ORDER BY idItem_Venda DESC LIMIT 1;
-- SELECT p.Nome_Produto, e.Quantidade FROM Estoque e JOIN Produto p ON e.idProduto = p.idProduto WHERE e.idProduto = 1;


-- 2. Teste da Procedure: GerenciarPromocaoProduto
-- 2.1 Adiciona o Produto 3 (Saia Midi Floral) à Promoção 1 (Liquidação Verão)
CALL GerenciarPromocaoProduto(3, 1, 'ADICIONAR', NULL);

-- 2.2 Atualiza o desconto da Promoção 2 (Semana da Moda) para 12%
CALL GerenciarPromocaoProduto(NULL, 2, 'ATUALIZAR', 0.12); -- NULL para idProduto é aceitável para ATUALIZAR a promoção em si.

-- 2.3 Remove o Produto 1 (Camiseta Básica) da Promoção 1 (Liquidação Verão)
CALL GerenciarPromocaoProduto(1, 1, 'REMOVER', NULL);

-- Para verificar o resultado:
-- SELECT * FROM Produto_Promocao WHERE idProduto = 3 AND idPromocao = 1;
-- SELECT * FROM Promocao WHERE idPromocao = 2;
-- SELECT * FROM Produto_Promocao WHERE idProduto = 1 AND idPromocao = 1;


-- 3. Teste da Procedure: AtualizarStatusProdutoFornecedor
-- Altera o status do Produto 5 (Colar Pedras) para 'Inativo'
CALL AtualizarStatusProdutoFornecedor(5, 'Inativo');

-- Altera o status do Produto 5 (Colar Pedras) de volta para 'Ativo'
CALL AtualizarStatusProdutoFornecedor(5, 'Ativo');

-- Para verificar o resultado:
-- SELECT idProduto, Nome_Produto, Status FROM Produto WHERE idProduto = 5;


-- 4. Teste da Procedure: GerarRelatorioVendasDetalhado
-- Gera um relatório de vendas detalhado para o mês atual, para todos os funcionários
CALL GerarRelatorioVendasDetalhado(CURDATE() - INTERVAL 30 DAY, CURDATE(), NULL);

-- Gera um relatório de vendas detalhado para o mês atual, apenas para o Funcionário 1 (Roberto Carlos)
CALL GerarRelatorioVendasDetalhado(CURDATE() - INTERVAL 30 DAY, CURDATE(), 1);


-- 5. Teste da Procedure: GerenciarCadastroCliente
-- 5.1 Adiciona um novo cliente
CALL GerenciarCadastroCliente(
    'ADICIONAR',
    NULL,
    'Cliente Simples Teste',
    '111.111.111-12',
    'simples.cliente@teste.com',
    '(99) 99999-0000',
    'Rua Simples, 1, Bairro Teste Simples'
);

-- 5.2 Atualiza o cliente recém-adicionado (será o último inserido, então ID 6 ou 7 dependendo dos seus testes anteriores)
-- ATENÇÃO: Verifique o ID do cliente inserido no passo anterior antes de executar.
-- Você pode usar SELECT idCliente FROM Cliente WHERE CPF = '111.111.111-12'; para pegar o ID.
CALL GerenciarCadastroCliente(
    'ATUALIZAR',
    (SELECT idCliente FROM Cliente WHERE CPF = '111.111.111-12'), -- Pega o ID dinamicamente
    'Cliente Simples Atualizado',
    '111.111.111-12',
    'simples.atualizado@teste.com',
    '(99) 88888-0000',
    'Av. Simples, 2, Nova Area Simples'
);

-- 5.3 Exclui o cliente (CUIDADO: Se este cliente tiver vendas associadas, a exclusão pode falhar devido à FK ON DELETE RESTRICT)
CALL GerenciarCadastroCliente('EXCLUIR', (SELECT idCliente FROM Cliente WHERE CPF = '111.111.111-12'), NULL, NULL, NULL, NULL, NULL);


-- 6. Teste da Procedure: AuditoriaEstoque
-- Adiciona 10 unidades ao Produto 1 (Camiseta Básica) e define o limite de alerta em 50
CALL AuditoriaEstoque(1, 10, 'Recebimento de nova mercadoria', 50);

-- Remove 70 unidades do Produto 2 (Calça Jeans Skinny) e define o limite de alerta em 100
CALL AuditoriaEstoque(2, -70, 'Venda em massa', 100);

-- Para verificar o resultado:
-- SELECT p.Nome_Produto, e.Quantidade FROM Estoque e JOIN Produto p ON e.idProduto = p.idProduto WHERE e.idProduto IN (1, 2);
