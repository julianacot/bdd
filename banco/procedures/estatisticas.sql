DELIMITER $$

CREATE PROCEDURE Estatisticas()
BEGIN
    DECLARE v_produto_mais INT;
    DECLARE v_produto_menos INT;
    DECLARE v_vendedor_mais VARCHAR(100);
    DECLARE v_valor_mais DECIMAL(10,2);
    DECLARE v_valor_menos DECIMAL(10,2);
    DECLARE v_mes_mais INT;
    DECLARE v_mes_menos INT;

    SELECT pv.idProduto
    INTO v_produto_mais
    FROM Produto_Venda pv
    GROUP BY pv.idProduto
    ORDER BY COUNT(*) DESC
    LIMIT 1;

    SELECT pv.idProduto
    INTO v_produto_menos
    FROM Produto_Venda pv
    GROUP BY pv.idProduto
    ORDER BY COUNT(*) ASC
    LIMIT 1;


    SELECT f.Nome INTO v_vendedor_mais
    FROM Funcionario f
    JOIN Produto p ON f.Id = p.idFuncionario
    WHERE p.Id = v_produto_mais;

    SELECT SUM(p.Valor) INTO v_valor_mais
    FROM Produto p
    JOIN Produto_Venda pv ON p.Id = pv.idProduto
    WHERE p.Id = v_produto_mais;


    SELECT SUM(p.Valor) INTO v_valor_menos
    FROM Produto p
    JOIN Produto_Venda pv ON p.Id = pv.idProduto
    WHERE p.Id = v_produto_menos;

    SELECT MONTH(v.Data)
    INTO v_mes_mais
    FROM Venda v
    JOIN Produto_Venda pv ON v.Id = pv.idVenda
    WHERE pv.idProduto = v_produto_mais
    GROUP BY MONTH(v.Data)
    ORDER BY COUNT(*) DESC
    LIMIT 1;

    SELECT MONTH(v.Data)
    INTO v_mes_menos
    FROM Venda v
    JOIN Produto_Venda pv ON v.Id = pv.idVenda
    WHERE pv.idProduto = v_produto_mais
    GROUP BY MONTH(v.Data)
    ORDER BY COUNT(*) ASC
    LIMIT 1;

    SELECT 
        p1.Nome AS Produto_Mais_Vendido,
        v_vendedor_mais AS Vendedor_Associado,
        v_valor_mais AS Valor_Ganho_Produto_Mais,
        v_mes_mais AS Mes_Mais_Vendas_Produto_Mais,
        v_mes_menos AS Mes_Menor_Vendas_Produto_Mais,
        p2.Nome AS Produto_Menos_Vendido,
        v_valor_menos AS Valor_Ganho_Produto_Menos
    FROM Produto p1, Produto p2
    WHERE p1.Id = v_produto_mais AND p2.Id = v_produto_menos;
END$$

DELIMITER ;
