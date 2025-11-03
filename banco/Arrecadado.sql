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