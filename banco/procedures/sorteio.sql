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
