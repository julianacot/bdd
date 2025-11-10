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
