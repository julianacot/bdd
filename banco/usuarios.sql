CREATE USER 'administrador'@'localhost' IDENTIFIED BY 'admin123';
GRANT ALL PRIVILEGES ON supermais.* TO 'administrador'@'localhost'WITH GRANT OPTION;

CREATE USER 'gerente'@'localhost' IDENTIFIED BY 'gerente123';
GRANT SELECT, DELETE, UPDATE ON supermais.* TO 'gerente'@'localhost';

CREATE USER 'funcionario'@'localhost' IDENTIFIED BY 'func123';
GRANT SELECT, INSERT ON supermais.vendas TO 'funcionario'@'localhost';

FLUSH PRIVILEGES;