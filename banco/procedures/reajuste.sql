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
