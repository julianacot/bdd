USE supermais;

DELIMITER $$
CREATE PROCEDURE Estatisticas()
BEGIN
    -- Variáveis existentes (OK)
    DECLARE v_produto_mais INT;
    DECLARE v_produto_menos INT;
    DECLARE v_vendedor_mais VARCHAR(100);
    DECLARE v_valor_mais DECIMAL(10,2);
    DECLARE v_valor_menos DECIMAL(10,2);
    DECLARE v_mes_mais INT;
    DECLARE v_mes_menos INT;
    
    -- ======== VARIÁVEIS NOVAS ADICIONADAS ========
    DECLARE v_mes_mais_prod_menos INT; -- Mês de MAIOR venda do produto MENOS vendido
    DECLARE v_mes_menos_prod_menos INT; -- Mês de MENOR venda do produto MENOS vendido

    -- Lógica para produto MAIS vendido (OK)
    SELECT pv.idProduto
    INTO v_produto_mais
    FROM Produto_Venda pv
    GROUP BY pv.idProduto
    ORDER BY COUNT(*) DESC
    LIMIT 1;

    -- Lógica para produto MENOS vendido (OK)
    SELECT pv.idProduto
    INTO v_produto_menos
    FROM Produto_Venda pv
    GROUP BY pv.idProduto
    ORDER BY COUNT(*) ASC
    LIMIT 1;

    -- Lógica para vendedor do produto MAIS vendido (OK)
    SELECT f.Nome INTO v_vendedor_mais
    FROM Funcionario f
    JOIN Produto p ON f.Id = p.idFuncionario
    WHERE p.Id = v_produto_mais;

    -- Lógica para valor ganho com produto MAIS vendido (OK)
    SELECT SUM(p.Valor) INTO v_valor_mais
    FROM Produto p
    JOIN Produto_Venda pv ON p.Id = pv.idProduto
    WHERE p.Id = v_produto_mais;

    -- Lógica para valor ganho com produto MENOS vendido (OK)
    SELECT SUM(p.Valor) INTO v_valor_menos
    FROM Produto p
    JOIN Produto_Venda pv ON p.Id = pv.idProduto
    WHERE p.Id = v_produto_menos;

    -- Lógica para meses do produto MAIS vendido (OK)
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

    -- ======== LÓGICA NOVA ADICIONADA ========
    -- Lógica para meses do produto MENOS vendido
    SELECT MONTH(v.Data)
    INTO v_mes_mais_prod_menos
    FROM Venda v
    JOIN Produto_Venda pv ON v.Id = pv.idVenda
    WHERE pv.idProduto = v_produto_menos
    GROUP BY MONTH(v.Data)
    ORDER BY COUNT(*) DESC
    LIMIT 1;

    SELECT MONTH(v.Data)
    INTO v_mes_menos_prod_menos
    FROM Venda v
    JOIN Produto_Venda pv ON v.Id = pv.idVenda
    WHERE pv.idProduto = v_produto_menos
    GROUP BY MONTH(v.Data)
    ORDER BY COUNT(*) ASC
    LIMIT 1;
    
    -- ======== SELECT FINAL CORRIGIDO ========
    SELECT 
        p1.Nome AS Produto_Mais_Vendido,
        v_vendedor_mais AS Vendedor_Associado,
        v_valor_mais AS Valor_Ganho_Produto_Mais,
        v_mes_mais AS Mes_Mais_Vendas_Produto_Mais,
        v_mes_menos AS Mes_Menor_Vendas_Produto_Mais,
        
        p2.Nome AS Produto_Menos_Vendido,
        v_valor_menos AS Valor_Ganho_Produto_Menos,
        v_mes_mais_prod_menos AS Mes_Mais_Vendas_Produto_Menos,
        v_mes_menos_prod_menos AS Mes_Menor_Vendas_Produto_Menos
        
    FROM Produto p1, Produto p2
    WHERE p1.Id = v_produto_mais AND p2.Id = v_produto_menos;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE Reajuste(
    IN p_percentual DECIMAL(5,2),
    IN p_categoria VARCHAR(50)
)
BEGIN
    UPDATE Funcionario
    SET Salario = Salario + (Salario * (p_percentual / 100))
    WHERE Cargo = p_categoria;

    SELECT CONCAT('Reajuste de ', p_percentual, '% aplicado aos funcionários da categoria ', p_categoria) AS Mensagem;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE Sorteio()
BEGIN
    DECLARE v_id_cliente INT;
    DECLARE v_valor_voucher DECIMAL(10,2);

    SELECT Id INTO v_id_cliente 
    FROM Cliente 
    ORDER BY RAND() 
    LIMIT 1;

    IF EXISTS (SELECT 1 FROM Cliente_Esp WHERE Id = v_id_cliente) THEN
        SET v_valor_voucher = 200.00;
    ELSE
        SET v_valor_voucher = 100.00;
    END IF;

    SELECT 
        c.Nome AS Cliente,
        v_valor_voucher AS Valor_Voucher,
        CASE 
            WHEN v_valor_voucher = 200 THEN 'Cliente Especial'
            ELSE 'Cliente Comum'
        END AS Tipo_Cliente
    FROM Cliente c
    WHERE c.Id = v_id_cliente;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE Venda(
    IN p_id_venda INT
)
BEGIN
    UPDATE Produto p
    JOIN Produto_Venda pv ON p.Id = pv.idProduto
    SET p.Estoque = p.Estoque - 1
    WHERE pv.idVenda = p_id_venda;

    SELECT 'Estoque atualizado com sucesso para os produtos da venda informada.' AS Mensagem;
END$$
DELIMITER ;