
DELIMITER $$ 

CREATE TRIGGER Bonus_venda
AFTER INSERT ON Produto_Venda
FOR EACH ROW
BEGIN

    DECLARE v_total_venda DECIMAL(10, 2);
    DECLARE v_id_funcionario INT;
    DECLARE v_bonus DECIMAL(10, 2);
    DECLARE v_total_bonus_geral DECIMAL(10, 2);
    DECLARE v_mensagem VARCHAR(255); 

    SELECT idFuncionario INTO v_id_funcionario FROM Venda WHERE Id = NEW.idVenda;
    
    SELECT SUM(p.Valor) INTO v_total_venda
    FROM Produto_Venda AS pv JOIN Produto AS p ON pv.idProduto = p.Id
    WHERE pv.idVenda = NEW.idVenda;

    IF v_total_venda > 1000.00 THEN
        SET v_bonus = v_total_venda * 0.05;
        
        INSERT INTO Funcionario_Esp (Id, Bonus)
        VALUES (v_id_funcionario, v_bonus)
        ON DUPLICATE KEY UPDATE Bonus = Funcionario_Esp.Bonus + v_bonus;
        
        SELECT SUM(Bonus) INTO v_total_bonus_geral FROM Funcionario_Esp;

        SET v_mensagem = CONCAT_WS('', 'Total de bônus a pagar (geral) R$: ', v_total_bonus_geral);
        
        SIGNAL SQLSTATE '01000'
        SET MESSAGE_TEXT = v_mensagem;
    END IF;
END$$ 
DELIMITER ;

DELIMITER $$ 

CREATE TRIGGER Cashback_cliente
AFTER INSERT ON Produto_Venda
FOR EACH ROW
BEGIN
    DECLARE v_total_venda DECIMAL(10, 2);
    DECLARE v_id_cliente INT;
    DECLARE v_cashback DECIMAL(10, 2);
    DECLARE v_total_cashback_geral DECIMAL(10, 2);
    DECLARE v_mensagem VARCHAR(255); 

    SELECT idCliente INTO v_id_cliente
    FROM Venda
    WHERE Id = NEW.idVenda;

    SELECT SUM(p.Valor) INTO v_total_venda
    FROM Produto_Venda AS pv
    JOIN Produto AS p ON pv.idProduto = p.Id
    WHERE pv.idVenda = NEW.idVenda;

    IF v_total_venda > 500.00 THEN
        SET v_cashback = v_total_venda * 0.02;
        
        INSERT INTO Cliente_Esp (Id, Cashback)
        VALUES (v_id_cliente, v_cashback)
        ON DUPLICATE KEY UPDATE Cashback = Cliente_Esp.Cashback + v_cashback;

        SELECT SUM(Cashback) INTO v_total_cashback_geral FROM Cliente_Esp;

        SET v_mensagem = CONCAT_WS('', 'Total de cashback a pagar (geral) R$: ', v_total_cashback_geral);
        
        SIGNAL SQLSTATE '01000'
        SET MESSAGE_TEXT = v_mensagem;
    END IF;
END$$ 
DELIMITER ;

 
DELIMITER $$
CREATE TRIGGER Remove_cliente_especial
AFTER UPDATE ON Cliente_Esp
FOR EACH ROW
BEGIN
    IF NEW.Cashback <= 0 THEN
        DELETE FROM Cliente_Esp WHERE Id = NEW.Id;
    END IF;
END$$
DELIMITER ;