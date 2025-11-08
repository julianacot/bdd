USE supermais;

CREATE VIEW vw_admin_vendas AS
SELECT 
    v.Id AS VendaID,
    v.Data,
    v.Hora,
    v.Endereco,
    c.Nome AS Cliente,
    t.Nome AS Transportadora,
    f.Nome AS Funcionario,
    COUNT(pv.idProduto) AS Qtde_Produtos,
    SUM(p.Valor) AS Total_Produtos,
    v.Frete,
    (SUM(p.Valor) + v.Frete) AS Valor_Total_Compra
FROM Venda v
JOIN Cliente c ON v.idCliente = c.Id
JOIN Transportadora t ON v.idTransportadora = t.Id
JOIN Produto_Venda pv ON v.Id = pv.idVenda
JOIN Produto p ON pv.idProduto = p.Id
JOIN Funcionario f ON v.idFuncionario = f.Id
GROUP BY v.Id, c.Nome, t.Nome, f.Nome;

CREATE VIEW vw_gerente_funcionarios AS
SELECT 
    f.Id AS FuncionarioID,
    f.Nome AS Funcionario,
    f.Cargo,
    f.Salario,
    f.Nota,
    COUNT(DISTINCT p.Id) AS Produtos_Cadastrados,
    COUNT(DISTINCT v.Id) AS Vendas_Realizadas
FROM Funcionario f
LEFT JOIN Produto p ON f.Id = p.idFuncionario
LEFT JOIN Venda v ON f.Id = v.idFuncionario
GROUP BY f.Id;

CREATE VIEW vw_funcionario_resumo_vendas AS
SELECT 
    c.Id AS ClienteID,
    c.Nome AS Cliente,
    COUNT(DISTINCT v.Id) AS Total_Vendas_Cliente,
    SUM(p.Valor) AS Valor_Total_Produtos
FROM Cliente c
LEFT JOIN Venda v ON c.Id = v.idCliente
LEFT JOIN Produto_Venda pv ON v.Id = pv.idVenda
LEFT JOIN Produto p ON pv.idProduto = p.Id
GROUP BY c.Id;

CREATE VIEW vw_clientes_produtos AS
SELECT
    v.Id AS VendaID,
    v.Data,
    c.Nome AS Cliente,
    p.Nome AS Produto,
    p.Valor AS Valor_Produto,
    f.Nome AS Funcionario,
    t.Nome AS Transportadora
FROM Venda v
JOIN Produto_Venda pv ON v.Id = pv.idVenda
JOIN Produto p ON pv.idProduto = p.Id
JOIN Funcionario f ON v.idFuncionario = f.Id
JOIN Transportadora t ON v.idTransportadora = t.Id
JOIN Cliente c ON v.idCliente = c.Id;