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