CREATE USER 'administrador'@'localhost' IDENTIFIED BY 'admin123';
GRANT ALL PRIVILEGES ON supermais.* TO 'administrador'@'localhost'WITH GRANT OPTION;
 
CREATE USER 'gerente'@'localhost' IDENTIFIED BY 'gerente123';
GRANT SELECT, DELETE, UPDATE ON supermais.* TO 'gerente'@'localhost';

CREATE USER 'funcionario'@'localhost' IDENTIFIED BY 'func123';
GRANT SELECT, INSERT ON supermais.vendas TO 'funcionario'@'localhost';

CREATE USER 'cadastrador'@'localhost' IDENTIFIED BY 'cad123';
GRANT INSERT ON supermais.Cliente TO 'cadastrador'@'localhost';
GRANT INSERT ON supermais.Produto TO 'cadastrador'@'localhost';

