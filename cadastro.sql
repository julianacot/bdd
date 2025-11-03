CREATE USER IF NOT EXISTS 'cadastrador'@'localhost' IDENTIFIED BY '12345';

GRANT INSERT ON supermais.Cliente TO 'cadastrador'@'localhost';

GRANT INSERT ON supermais.Produto TO 'cadastrador'@'localhost';

GRANT SELECT ON supermais.* TO 'cadastrador'@'localhost';

FLUSH PRIVILEGES;