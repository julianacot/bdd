USE supermais;

CREATE USER 'administrador'@'localhost' IDENTIFIED BY 'admin123';
GRANT ALL PRIVILEGES ON supermais.* TO 'administrador'@'localhost' WITH GRANT OPTION;
 
CREATE USER 'gerente'@'localhost' IDENTIFIED BY 'gerente123';
GRANT SELECT, DELETE, UPDATE ON supermais.* TO 'gerente'@'localhost';

CREATE USER 'funcionario'@'localhost' IDENTIFIED BY 'func123';
GRANT SELECT, INSERT ON supermais.Venda TO 'funcionario'@'localhost';
GRANT SELECT, INSERT ON supermais.Produto_Venda TO 'funcionario'@'localhost';

CREATE USER 'cadastrador'@'localhost' IDENTIFIED BY 'cad123';
GRANT INSERT ON supermais.Cliente TO 'cadastrador'@'localhost';
GRANT INSERT ON supermais.Produto TO 'cadastrador'@'localhost';

FLUSH PRIVILEGES;