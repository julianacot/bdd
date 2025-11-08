CREATE DATABASE supermais;
USE supermais;

CREATE TABLE Cliente (
    Id      INT PRIMARY KEY AUTO_INCREMENT,
    Nome    VARCHAR(100) NOT NULL,
    Sexo    CHAR(1) CHECK (Sexo = 'm' OR Sexo = 'f' OR Sexo = 'o'),
    Nasc    DATE,
    Idade   INT
);

CREATE TABLE Cliente_Esp (
    Id          INT PRIMARY KEY,
    Cashback    DECIMAL(10, 2) DEFAULT 0,
    FOREIGN KEY (Id) REFERENCES Cliente(Id)
);

CREATE TABLE Funcionario (
    Id      INT PRIMARY KEY AUTO_INCREMENT,
    Nome    VARCHAR(100) NOT NULL,
    Salario DECIMAL(10, 2) DEFAULT 0,
    Nota    DECIMAL(10, 2),
    Causa   VARCHAR(255),
    Cargo   VARCHAR(50) CHECK (Cargo = 'vendedor' OR Cargo = 'gerente' OR Cargo = 'CEO')
);

CREATE TABLE Funcionario_Esp (
    Id      INT PRIMARY KEY,
    Bonus   DECIMAL(10, 2) DEFAULT 0,
    FOREIGN KEY (Id) REFERENCES Funcionario(Id)
);

CREATE TABLE Transportadora (
    Id      INT PRIMARY KEY AUTO_INCREMENT,
    Nome    VARCHAR(100) NOT NULL,
    Cidade  VARCHAR(100)
);

CREATE TABLE Produto (
    Id              INT PRIMARY KEY AUTO_INCREMENT,
    Nome            VARCHAR(100) NOT NULL,
    Estoque         INT DEFAULT 0,
    Descricao       VARCHAR(255),
    Obs             VARCHAR(255),
    Valor           DECIMAL(10, 2) NOT NULL,
    idFuncionario   INT NOT NULL,
    FOREIGN KEY (idFuncionario) REFERENCES Funcionario(Id)
);

CREATE TABLE Venda (
    Id                  INT PRIMARY KEY AUTO_INCREMENT,
    Data                DATE,
    Hora                TIME,
    Endereco            VARCHAR(255),
    Frete               DECIMAL(10, 2),
    idCliente           INT NOT NULL,
    idFuncionario       INT NOT NULL,
    idTransportadora    INT NOT NULL,
    FOREIGN KEY (idCliente) REFERENCES Cliente(Id),
    FOREIGN KEY (idFuncionario) REFERENCES Funcionario(Id),
    FOREIGN KEY (idTransportadora) REFERENCES Transportadora(Id)
);

CREATE TABLE Produto_Venda (
    idVenda     INT NOT NULL,
    idProduto   INT NOT NULL,
    PRIMARY KEY (idVenda, idProduto),
    FOREIGN KEY (idVenda) REFERENCES Venda(Id),
    FOREIGN KEY (idProduto) REFERENCES Produto(Id)
);