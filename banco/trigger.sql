DELIMITER $$

CREATE TRIGGER Bonus_venda
AFTER INSERT ON Vendas
FOR EACH ROW
BEGIN
    DECLARE bonus DECIMAL(10,2);
    DECLARE total_bonus DECIMAL(10,2);

    IF NEW.valor > 1000 THEN
        SET bonus = NEW.valor * 0.05;
        INSERT INTO vendedor_especial (id_vendedor, bonus)
        VALUES (NEW.id_vendedor, bonus);
        ON DUPLICATE KEY UPDATE bonus = vendedor_especial.bonus + VALUES(bonus);
    END IF;

    END IF;

    SELECT SUM(bonus) INTO total_bonus FROM vendedor_especial;

    SIGNAL SQLSTATE '01000'
        SET MESSAGE_TEXT = CONCAT('Total de bônus a pagar R$: ', total_bonus);
END$$

DELIMITER $$

CREATE TRIGGER Cashback_cliente
AFTER INSERT ON Vendas
FOR EACH ROW
BEGIN
    DECLARE cashback DECIMAL(10,2);
    DECLARE total_cashback DECIMAL(10,2);

    IF NEW.valor > 500 THEN
        SET cashback = NEW.valor * 0.02;
        INSERT INTO cliente_especial (id_cliente, cashback)
        VALUES (NEW.id_cliente, cashback)
        ON DUPLICATE KEY UPDATE cashback = cashback + VALUES(cashback);
    END IF;

    SELECT SUM(cashback) INTO total_cashback FROM cliente_especial;

    SIGNAL SQLSTATE '01000'
        SET MESSAGE_TEXT = CONCAT('Total de cashback a pagar R$: ', total_cashback);
END$$

DELIMITER $$

CREATE TRIGGER Remove_cliente_especial
AFTER UPDATE ON cliente_especial
FOR EACH ROW
BEGIN
    IF NEW.cashback = 0 THEN
        DELETE FROM cliente_especial WHERE id_cliente = NEW.id_cliente;
    END IF;
END$$


DELIMITER ;