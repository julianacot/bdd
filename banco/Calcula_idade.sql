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