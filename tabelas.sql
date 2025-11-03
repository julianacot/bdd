CREATE DATABASE supermais;
USE supermais;

CREATE TABLE Cliente (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Sexo CHAR(1) CHECK (Sexo = 'm' OR Sexo = 'f' OR Sexo = 'o'),
    Nasc DATE,
    Idade INT
);

CREATE TABLE Cliente_Esp (
    Id INT PRIMARY KEY,
    Cashback DECIMAL(10, 2) DEFAULT 0,
    FOREIGN KEY(Id) REFERENCES Cliente(Id)
);

CREATE TABLE Funcionario (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Salario DECIMAL(10, 2) DEFAULT 0,
    Nota DECIMAL(10, 2),
    Causa VARCHAR(255),
    Cargo VARCHAR(50) CHECK (Cargo = 'vendedor' OR Cargo = 'gerente' OR Cargo = 'CEO')
);

CREATE TABLE Funcionario_Esp(
    Id INT PRIMARY KEY,
    Bonus DECIMAL(10, 2) DEFAULT 0,
    FOREIGN KEY(Id) REFERENCES Funcionario(Id)
);

CREATE TABLE Transportadora (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Cidade VARCHAR(100)
);

CREATE TABLE Produto (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Estoque INT DEFAULT 0,
    Descricao VARCHAR(255),
    Obs VARCHAR(255),
    Valor DECIMAL(10, 2) NOT NULL,
    idFuncionario INT NOT NULL,
    FOREIGN KEY(idFuncionario) REFERENCES Funcionario(Id)
);

CREATE TABLE Venda (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Data DATE,
    Hora TIME,
    Endereco VARCHAR(255),
    Frete DECIMAL(10, 2),
    idCliente INT NOT NULL,
    idFuncionario INT NOT NULL,
    idTransportadora INT NOT NULL,
    FOREIGN KEY(idCliente) REFERENCES Cliente(Id),
    FOREIGN KEY(idFuncionario) REFERENCES Funcionario(Id),
    FOREIGN KEY(idTransportadora) REFERENCES Transportadora(Id)
);

CREATE TABLE Produto_Venda (
    idVenda INT NOT NULL,
    idProduto INT NOT NULL,
    PRIMARY KEY (idVenda, idProduto),
    FOREIGN KEY(idVenda) REFERENCES Venda(Id),
    FOREIGN KEY(idProduto) REFERENCES Produto(Id)
);

INSERT INTO Funcionario (Nome, Salario, Nota, Causa, Cargo) VALUES
('Ana Silva', 5000.00, 8.5, 'Vendas de alto desempenho', 'gerente'),
('Bruno Costa', 2500.00, 7.8, 'Atendimento ao cliente', 'vendedor'),
('Carla Santos', 2800.00, 9.1, 'Treinamento de novos vendedores', 'vendedor'),
('Daniel Pereira', 15000.00, 9.9, 'Estratégia e direção', 'CEO'),
('Eduarda Almeida', 4500.00, 8.2, 'Gestão de estoque', 'gerente');

INSERT INTO Funcionario_Esp (Id, Bonus) VALUES
(1, 0.00),
(3, 0.00);

INSERT INTO Cliente (Nome, Sexo, Nasc, Idade) VALUES
('Fernando Oliveira', 'm', '1985-05-20', 40),
('Giovanna Souza', 'f', '1992-11-15', 33),
('Henrique Lima', 'm', '2000-01-01', 25),
('Isabela Rocha', 'f', '1976-03-25', 49),
('João Mendes', 'm', '1998-07-10', 27),
('Lúcia Vieira', 'f', '1965-12-05', 60),
('Marcelo Nunes', 'm', '1989-09-30', 36),
('Natália Pires', 'f', '2003-04-12', 22),
('Otávio Martins', 'm', '1970-02-28', 55),
('Patrícia Gomes', 'f', '1995-06-18', 30),
('Quiteria Barbosa', 'f', '1980-10-02', 45),
('Ricardo Freitas', 'm', '1991-08-08', 34),
('Sofia Rodrigues', 'f', '1973-01-22', 52),
('Thiago Assis', 'm', '2001-11-04', 24),
('Ursula Xavier', 'f', '1987-05-13', 38),
('Vicente Barros', 'm', '1960-03-01', 65),
('Wanda Cordeiro', 'f', '1999-07-27', 26),
('Xavier Dantas', 'm', '1978-12-30', 47),
('Yara Euzébio', 'f', '1993-04-05', 32),
('Zacarias Flores', 'o', '1982-09-17', 43);

INSERT INTO Cliente_Esp (Id, Cashback) VALUES
(2, 0.00),
(10, 0.00),
(16, 0.00);

INSERT INTO Transportadora (Nome, Cidade) VALUES
('RápidoLog', 'São Paulo'),
('ExpressBR', 'Rio de Janeiro'),
('LogiSul', 'Curitiba'),
('TransNorte', 'Manaus'),
('Central Cargas', 'Belo Horizonte');

INSERT INTO Produto (Nome, Estoque, Descricao, Obs, Valor, idFuncionario) VALUES
('Smartphone X', 50, 'Modelo 2024, 128GB', 'Garantia de 1 ano', 1899.99, 2),
('Notebook Gamer', 15, 'Alto desempenho para jogos', 'Mouse pad incluso', 4500.00, 1),
('Teclado Mecânico', 120, 'Switches táteis, RGB', NULL, 350.50, 3),
('Mouse Wireless', 200, 'Ergonômico, 6 botões', 'Pilhas AA não inclusas', 89.90, 2),
('Monitor LED 27"', 30, 'Resolução 4K, 144Hz', 'Ideal para design', 1599.00, 5),
('Câmera IP Wi-Fi', 85, 'Visão noturna, Full HD', 'Armazenamento em nuvem opcional', 249.99, 3),
('Headset Bluetooth', 150, 'Cancelamento de ruído', NULL, 199.99, 1),
('Carregador Portátil 10K', 180, 'Carga rápida, 2 saídas USB', 'Preto fosco', 75.00, 2),
('Smartwatch Modelo A', 40, 'Monitor de atividades, GPS', 'Pulseira extra de brinde', 599.00, 3),
('Tablet 10 polegadas', 60, 'Processador quad-core', 'Cor cinza espacial', 999.00, 5),
('Webcam HD', 110, 'Microfone embutido', 'Plug and play', 59.90, 4),
('Roteador Dual Band', 70, 'Velocidade AC1200', '4 antenas externas', 129.90, 2),
('Impressora Multifuncional', 25, 'Tinta contínua, Wi-Fi', 'Inclui kit de tintas', 750.00, 1),
('Cartão de Memória 128GB', 300, 'Classe 10, UHS-I', 'Adaptador SD incluso', 65.50, 3),
('Controle Sem Fio PS5', 45, 'Várias cores', NULL, 399.90, 5),
('Cabo USB-C 2 metros', 400, 'Trançado em nylon', 'Transferência de dados 10Gbps', 29.90, 2),
('Lâmpada Smart RGB', 90, 'Controle por voz', 'Compatível com Alexa/Google Home', 45.00, 4),
('Filtro de Linha 8 Tomadas', 130, 'Proteção contra surtos', 'Cabo de 1.5m', 35.00, 1),
('Pen Drive 64GB', 250, 'Interface USB 3.0', 'Design compacto', 49.90, 3),
('Microfone Condensador', 20, 'Ideal para streaming', 'Acompanha tripé', 280.00, 5);

INSERT INTO Venda (Data, Hora, Endereco, Frete, idCliente, idFuncionario, idTransportadora) VALUES
('2025-10-01', '09:15:00', 'Rua 1, São Paulo', 30.00, 1, 3, 3),
('2025-10-01', '14:30:00', 'Rua 2, Recife', 10.00, 2, 2, 1),
('2025-10-01', '11:00:00', 'Rua 3, Rio de Janeiro', 20.00, 3, 3, 1),
('2025-10-01', '16:45:00', 'Rua 1, São Paulo', 35.00, 4, 4, 5),
('2025-10-01', '10:20:00', 'Rua 2, Recife', 17.00, 5, 5, 2),
('2025-10-01', '13:00:00', 'Rua 3, Rio de Janeiro', 26.00, 6, 1, 4),
('2025-10-01', '18:10:00', 'Rua 1, São Paulo', 30.00, 7, 2, 3),
('2025-10-01', '08:05:00', 'Rua 2, Recife', 13.00, 8, 3, 4),
('2025-10-01', '12:30:00', 'Rua 3, Rio de Janeiro', 25.00, 9, 4, 5),
('2025-10-01', '15:55:00', 'Rua 2, Recife', 10.00, 10, 5, 1);

INSERT INTO Produto_Venda (idVenda, idProduto) VALUES
(1, 1),
(2, 4),
(3, 8),
(4, 2),
(5, 11),
(6, 15),
(7, 20),
(8, 3),
(9, 17),
(10, 5);