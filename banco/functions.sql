DELIMITER $$

CREATE FUNCTION Arrecadado(p_data DATE, p_id_funcionario INT)
RETURNS DECIMAL(10, 2)
READS SQL DATA
BEGIN
    DECLARE v_total_arrecadado DECIMAL(10, 2);
    SELECT SUM(p.Valor) INTO v_total_arrecadado
    FROM Venda AS v
    JOIN Produto_Venda AS pv ON v.Id = pv.idVenda
    JOIN Produto AS p ON pv.idProduto = p.Id
    WHERE v.Data = p_data AND v.idFuncionario = p_id_funcionario;
    IF v_total_arrecadado IS NULL THEN
        SET v_total_arrecadado = 0;
    END IF;
    RETURN v_total_arrecadado;
END$$

DELIMITER ;

DELIMITER $$

CREATE FUNCTION Calcula_idade(p_id_cliente INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_nascimento DATE;
    SELECT Nasc INTO v_nascimento
    FROM Cliente
    WHERE Id = p_id_cliente;
    IF v_nascimento IS NULL THEN
        RETURN NULL;
    END IF;
    RETURN TIMESTAMPDIFF(YEAR, v_nascimento, CURDATE());
END$$

DELIMITER ;

DELIMITER $$

CREATE FUNCTION Soma_fretes(p_destino VARCHAR(255))
RETURNS DECIMAL(10, 2)
READS SQL DATA
BEGIN
    DECLARE v_total_fretes DECIMAL(10, 2);
    SELECT SUM(Frete) INTO v_total_fretes
    FROM Venda
    WHERE Endereco = p_destino;
    IF v_total_fretes IS NULL THEN
        SET v_total_fretes = 0;
    END IF;
    RETURN v_total_fretes;
END$$

DELIMITER ; 
