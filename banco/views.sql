CREATE VIEW vw_admin_vendas AS
SELECT 
    v.Id AS VendaID,
    v.Data,
    v.Hora,
    v.Endereco,
    v.Valor_C,
    c.Nome AS Cliente,
    t.Nome AS Transportadora,
    ve.Nome AS Vendedor,
    COUNT(pv.idProduto) AS Qtde_Produtos,
    SUM(p.Valor) AS Total_Produtos
FROM Venda v
JOIN Cliente c ON v.idCliente = c.Id
JOIN Transportadora t ON v.idTransportadora = t.Id
JOIN Produto_Venda pv ON v.Id = pv.idVenda
JOIN Produto p ON pv.idProduto = p.Id
JOIN Vendedor ve ON p.idVendedor = ve.Id
GROUP BY v.Id;
CREATE VIEW vw_gerente_vendedores AS
SELECT 
    ve.Id AS VendedorID,
    ve.Nome AS Vendedor,
    ve.Tipo,
    ve.Nota,
    COUNT(p.Id) AS Produtos_Cadastrados,
    SUM(pv.idProduto IS NOT NULL) AS Produtos_Vendidos
FROM Vendedor ve
LEFT JOIN Produto p ON ve.Id = p.idVendedor
LEFT JOIN Produto_Venda pv ON p.Id = pv.idProduto
GROUP BY ve.Id;
CREATE VIEW vw_funcionario_resumo_vendas AS
SELECT 
    c.Id AS ClienteID,
    c.Nome AS Cliente,
    COUNT(v.Id) AS Total_Vendas,
    SUM(v.Valor_C) AS Valor_Total_Gasto
FROM Cliente c
LEFT JOIN Venda v ON c.Id = v.idCliente
GROUP BY c.Id;
CREATE VIEW vw_clientes_produtos AS
SELECT
    v.Id AS VendaID,
    v.Data,
    p.Nome AS Produto,
    p.Valor,
    ve.Nome AS Vendedor,
    t.Nome AS Transportadora
FROM Venda v
JOIN Produto_Venda pv ON v.Id = pv.idVenda
JOIN Produto p ON pv.idProduto = p.Id
JOIN Vendedor ve ON p.idVendedor = ve.Id
JOIN Transportadora t ON v.idTransportadora = t.Id;
