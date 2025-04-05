-- criação do Banco de dados para o cenário de e-commerce
CREATE DATABASE if not exists ecommerce;
use ecommerce;
drop database ecommerce;

show databases;
show tables;

-- tabela clientes
create table clients(
		idClient INT AUTO_INCREMENT PRIMARY KEY,
        clientType ENUM('PF','PJ') NOT NULL,
        Fname VARCHAR(10),
        Mnit CHAR(3),
        Lname VARCHAR(20),
        CPF CHAR(11),
        CNPJ CHAR(15),
        Address VARCHAR(30),
        constraint unique_client_cpf UNIQUE (CPF),
        constraint unique_client_cnpj UNIQUE (CNPJ),
        constraint chk_client_cpf_cnpj check (
				(clientType = 'PF' AND 'CPF' IS NOT NULL AND CNPJ IS NULL) OR
                (clientType = 'PJ'AND CNPJ IS NOT NULL AND CPF IS NULL)
			)
	);
    desc clients;
    
    -- tabela produto
    create table products(
		idProduct INT AUTO_INCREMENT PRIMARY KEY,
        Pname VARCHAR(10),
        classification BOOLEAN,
        category ENUM('Eletronico','Vestimenta','Brinquedo','Alimentos','Moveis') NOT NULL,
        avaliacao FLOAT DEFAULT 0,
        size VARCHAR(10)
);
desc products;

-- tabela pagamentos
create table payements(
		idClient INT,
        idPayement INT,
        typePayement ENUM('Boleto','Cartão','Dois cartões'),
        limitAvaliable FLOAT,
        PRIMARY KEY (idClient, idPayement),
        FOREIGN KEY (idClient) REFERENCES clients(idClient)
);

SHOW CREATE TABLE payements;
desc payements;

-- tabela pedido
create table orders_(
		idOrder INT AUTO_INCREMENT PRIMARY KEY,
        idOrderClient INT,
        orderStatus ENUM('Cancelado','Confirmado','Em processamento') DEFAULT 'Em processamento',
        orderDescription VARCHAR(255),
        sendValue FLOAT DEFAULT 10,
        payementCash BOOLEAN DEFAULT FALSE,
        FOREIGN KEY (idOrderClient) REFERENCES clients(idClient)
);
desc orders_;

-- tabela entrega
create table delivery(
		idDelivery INT AUTO_INCREMENT PRIMARY KEY,
        idOrder INT UNIQUE,
        status VARCHAR(50),
        tracking_code VARCHAR(100),
        FOREIGN KEY (idOrder) REFERENCES orders_(idOrder)
);
desc delivery;

-- tabela estoque de produtos
create table productStorages(
		idprodStorage INT AUTO_INCREMENT PRIMARY KEY,
        storageLocation VARCHAR(255),
        quantity INT DEFAULT 0
);
desc productStorages;

-- tabela fornecedor
create table suppliers(
		idSupplier INT AUTO_INCREMENT PRIMARY KEY,
        SocialName VARCHAR(255) NOT NULL,
        CNPJ CHAR(15) NOT NULL,
        contact CHAR(11) NOT NULL,
        constraint unique_supplier_cnpj unique (CNPJ)
);
desc suppliers;

-- tabela vendedor
create table sellers(
		idSeller INT AUTO_INCREMENT PRIMARY KEY,
        SocialName VARCHAR(255) NOT NULL,
        AbstName VARCHAR(255),
        CNPJ CHAR(15),
        CPF CHAR(9),
        location VARCHAR(255),
        CONSTRAINT unique_seller_cnpj UNIQUE (CNPJ),
        CONSTRAINT unique_seller_cpf UNIQUE (CPF),
        CONSTRAINT chk_seller_cnpj_cpf CHECK (
				(CNPJ IS NOT NULL AND CPF IS NULL) OR
                (CPF IS NOT NULL AND CNPJ IS NULL)
		)
);
desc sellers; 

-- tabela de relacionamento produto-vendedor
create table productSellers(
		idPSeller INT,
        idProduct INT,
        prodQuantity INT DEFAULT 1,
        PRIMARY KEY (idPSeller, idProduct),
        FOREIGN KEY (idPSeller) REFERENCES sellers(idSeller),
        FOREIGN KEY (idProduct) REFERENCES products(idProduct)
);
desc productSellers;

-- tabela de relacionamento localização-produto-pedido
create table productOrders(
			idPOproduct INT,
            idPOorder INT,
            poQuantity INT DEFAULT 1,
            poStatus ENUM('Disponivel','Sem estoque') DEFAULT 'Disponivel',
            PRIMARY KEY (idPOproduct, idPOorder),
            FOREIGN KEY (idPOproduct) REFERENCES products(idProduct),
            FOREIGN KEY (idPOorder) REFERENCES orders_(idOrder)
);
desc  productOrders;

-- tabela de relacionamento localização-produto-estoque
create table storageLocations(
			idLproduct INT,
            idIstorage INT,
            location VARCHAR(255) NOT NULL,
            PRIMARY KEY (idLproduct, idIstorage),
            FOREIGN KEY (idLproduct) REFERENCES products(idProduct),
            FOREIGN KEY (idIstorage) REFERENCES productStorages(idprodStorage)
);
desc storageLocations;

-- tabela de relacionamento produto-fornecedor
create table productSuppliers(
		idPsSupplier INT,
        idPsProduct INT,
        quantity INT NOT NULL,
        PRIMARY KEY (idPsSupplier, idPsProduct),
        FOREIGN KEY (idPsSupplier) REFERENCES suppliers(idSupplier),
        FOREIGN KEY (idPsProduct) REFERENCES products(idProduct)
);
 
 -- persistência de dados para teste
 
 -- Inserir dados na tabela client
INSERT INTO clients (clientType, Fname, Lname, CPF, Address) VALUES ('PF', 'João', 'Silva', '12345678901', 'Rua A, 123');
INSERT INTO clients (clientType, Fname,Lname, CNPJ, Address) VALUES ('PJ', 'Beto','junior','123123123456789', 'Av. B, 456');
INSERT INTO clients (clientType, Fname, Lname, CPF, Address) VALUES ('PF', 'Maria', 'Souza', '98765432109', 'Avenida C, 789');
select * from clients;

-- Inserir dados na tabela product
INSERT INTO products (idProduct,Pname, classification, category, avaliacao, size) VALUES ('0','Camiseta', FALSE, 'Vestimenta', 4.5, 'M');
INSERT INTO products (idProduct,Pname, classification, category, avaliacao) VALUES ('0','Notebook', FALSE, 'Eletronico', 4.8);
INSERT INTO products (idProduct,Pname, classification, category, avaliacao, size) VALUES('0','Calça', FALSE, 'Vestimenta', 4.2, '38');
 select * from products;
 
-- Inserir dados na tabela payements
INSERT INTO payements (idClient, idPayement, typePayement, limitAvaliable) VALUES (3, 1, 'Cartão', 1000.0);
INSERT INTO payements (idClient, idPayement, typePayement, limitAvaliable) VALUES (1, 1, 'Boleto',null);
INSERT INTO payements (idClient, idPayement, typePayement, limitAvaliable) VALUES (2, 2, 'Dois Cartões', 500.0);
select * from payements;

-- Inserir dados na tabela orders
INSERT INTO orders_ (idOrderClient, orderStatus, orderDescription, sendValue, payementCash) VALUES (1, 'Confirmado', 'Pedido de camiseta', 5, FALSE);
INSERT INTO orders_ (idOrderClient, orderStatus, orderDescription, sendValue, payementCash) VALUES (2, 'Em processamento', 'Pedido de notebook', 15, FALSE);
INSERT INTO orders_ (idOrderClient, orderStatus, orderDescription, sendValue, payementCash) VALUES (1, 'Em processamento', 'Pedido de calça', 7, TRUE);
select * from orders_;

-- Inserir dados na tabela delivery
INSERT INTO delivery (idOrder, status, tracking_code) VALUES (1, 'Entregue', 'ABC123456');
INSERT INTO delivery (idOrder, status, tracking_code) VALUES (2, 'Em trânsito', 'DEF789012');
INSERT INTO delivery (idOrder, status, tracking_code) VALUES (3, 'Saiu para entrega', 'GHI345678');
select * from delivery;

-- Inserir dados na tabela productStorage
INSERT INTO productStorages (storageLocation, quantity) VALUES ('Galpão 1', 100);
INSERT INTO productStorages (storageLocation, quantity) VALUES ('Galpão 2', 50);
INSERT INTO productStorages (storageLocation, quantity) VALUES ('Loja Centro', 25);
select * from productStorages;

-- Inserir dados na tabela supplier
INSERT INTO suppliers (SocialName, CNPJ, contact) VALUES ('Fornecedor Alfa', '98765432109874', '11999999999');
INSERT INTO suppliers (SocialName, CNPJ, contact) VALUES ('Fornecedor Beta', '11223344556679', '21888888888');
select * from suppliers;

-- Inserir dados na tabela seller
INSERT INTO sellers (idSeller,SocialName,location,CPF) VALUES ('1', 'Bruno','Maceió','123456789');
INSERT INTO sellers (idSeller,SocialName,location,CNPJ) VALUES ('2', 'joão','Bahia','123456789012345');
INSERT INTO sellers (idSeller,SocialName,location,CPF) VALUES ('3', 'Ana','Goias','987654322');
select * from sellers;

-- Inserir dados na tabela productSeller
INSERT INTO productSellers (idPSeller, idProduct, prodQuantity) VALUES (2, 1, 50);
INSERT INTO productSellers (idPSeller, idProduct, prodQuantity) VALUES (1, 2, 20);
INSERT INTO productSellers (idPSeller, idProduct, prodQuantity) VALUES (2, 3, 30);
select * from productSellers;

-- Inserir dados na tabela productOrder
INSERT INTO productOrders (idPOproduct, idPOorder, poQuantity, poStatus) VALUES (1,2,3,'Disponivel');
INSERT INTO productOrders (idPOproduct, idPOorder, poQuantity, poStatus) VALUES (2, 2, 1, 'Disponivel');
INSERT INTO productOrders (idPOproduct, idPOorder, poQuantity, poStatus) VALUES (3, 2, 2, 'Disponivel');
select * from productOrders;

-- Inserir dados na tabela storageLocation
INSERT INTO storageLocations (idLproduct, idIstorage, location) VALUES (1, 1, 'Prateleira A1');
INSERT INTO storageLocations (idLproduct, idIstorage, location) VALUES (2, 2, 'Estoque Principal');
INSERT INTO storageLocations (idLproduct, idIstorage, location) VALUES (3, 3, 'Arara 5');
select * from storageLocations;

-- Inserir dados na tabela productSupplier
INSERT INTO productSuppliers (idPsSupplier, idPsProduct, quantity) VALUES (1, 1, 100);
INSERT INTO productSuppliers (idPsSupplier, idPsProduct, quantity) VALUES (2, 2, 50);
INSERT INTO productSuppliers (idPsSupplier, idPsProduct, quantity) VALUES (1, 3, 150);
select * from productsuppliers;


-- CRIAÇÃO DE CONSULTAS COMPLEXAS:
-- Recuperações simples com instrução SELECT:
-- Listar o nome de todos os clientes PF
SELECT Fname, Lname FROM clients WHERE clientType = 'PF';

-- Listar o nome e a categoria de todos os produtos
SELECT Pname, category FROM products;


-- FILTROS COM DECLARAÇÃO WHERE:
-- Listar os pedidos feitos pelo cliente com idClient = 1
SELECT * FROM orders_ WHERE idOrderClient = 1;

-- Listar os produtos da categoria 'Eletronico' com avaliação maior que 4.5
SELECT Pname FROM products WHERE category = 'Eletronico' AND avaliacao > 4.5;


-- EXPRESSÕES PARA GERAR ATRIBUTOS:
-- Exibir o nome completo dos clientes PF
SELECT Fname, Mnit, Lname, CONCAT(Fname, ' ', Lname) AS NomeCompleto FROM clients WHERE clientType = 'PF';

-- Calcular o valor total de cada pedido (considerando o valor de envio)
SELECT idOrder, sendValue, sendValue + (sendValue * 0.10) AS ValorTotalComImposto FROM orders_;


-- ORDENAÇÃO DE DADOS COM ORDER BY:
-- Listar todos os produtos em ordem alfabética crescente
SELECT Pname FROM products ORDER BY Pname ASC;

-- Listar os pedidos em ordem decrescente de ID
SELECT idOrder, idOrderClient FROM orders_ ORDER BY idOrder DESC;


-- CONDIÇÕES DE FILTROS PARA GRUPOS - DECLARAÇÃO HAVIN
-- Listar os clientes que fizeram mais de um pedido
SELECT c.idClient, c.Fname, c.Lname, COUNT(o.idOrder) AS NumeroPedidos
FROM clients c
JOIN orders_ o ON c.idClient = o.idOrderClient
GROUP BY c.idClient, c.Fname, c.Lname
HAVING COUNT(o.idOrder) > 1; 


-- Listar o nome do cliente e o status de cada pedido
SELECT cl.Fname, cl.Lname, o.idOrder, o.orderStatus
FROM clients cl
JOIN orders_ o ON cl.idClient = o.idOrderClient;

-- Listar o nome do produto e a localização em que está armazenado
SELECT p.Pname, ps.storageLocation, sl.location
FROM products p
JOIN storageLocations sl ON p.idProduct = sl.idLproduct
JOIN productStorages ps ON sl.idIstorage = ps.idprodStorage;

-- Listar o nome do cliente, o número do pedido e o código de rastreamento da entrega
SELECT cl.Fname, cl.Lname, o.idOrder, d.tracking_code
FROM clients cl
JOIN orders_ o ON cl.idClient = o.idOrderClient
JOIN delivery d ON o.idOrder = d.idOrder;

-- Resposta para as perguntas sugeridas:

-- Quantos pedidos foram feitos por cada cliente?
SELECT c.Fname, c.Lname, COUNT(o.idOrder) AS TotalPedidos
FROM clients c
LEFT JOIN orders_ o ON c.idClient = o.idOrderClient
GROUP BY c.idClient, c.Fname, c.Lname;

-- Algum vendedor também é fornecedor?
SELECT s.SocialName AS NomeVendedor
FROM sellers s
WHERE s.SocialName IN (SELECT sp.SocialName FROM suppliers sp);

-- Relação de produtos fornecidos e estoques;
SELECT p.Pname AS NomeProduto, sp.SocialName AS NomeFornecedor, psup.quantity AS QuantidadeFornecida, pst.storageLocation AS LocalEstoque, sl.location AS DetalheLocalizacao, pst.quantity AS QuantidadeEstoque
FROM products p
JOIN productSuppliers psup ON p.idProduct = psup.idPsProduct
JOIN suppliers sp ON psup.idPsSupplier = sp.idSupplier
JOIN storageLocations sl ON p.idProduct = sl.idLproduct
JOIN productStorages pst ON sl.idIstorage = pst.idprodStorage;

-- Relação de nomes de fornecedores e nomes de produtos;
SELECT sp.SocialName AS NomeFornecedor, p.Pname AS NomeProduto
FROM suppliers sp
JOIN productSuppliers psup ON sp.idSupplier = psup.idPsSupplier
JOIN products p ON psup.idPsProduct = p.idProduct;

-- Consultas mais complexas:
-- Encontrar os produtos que são fornecidos por mais de um fornecedor
SELECT p.Pname AS NomeProduto
FROM products p
JOIN productSuppliers psup ON p.idProduct = psup.idPsProduct
GROUP BY p.idProduct, p.Pname
HAVING COUNT(DISTINCT psup.idPsSupplier) > 1;

-- Listar os vendedores que venderam pelo menos um produto
SELECT s.SocialName AS NomeVendedor, p.Pname AS NomeProduto
FROM sellers s
JOIN productSellers ps ON s.idSeller = ps.idPseller
JOIN products p ON ps.idProduct = p.idProduct;





 



       
        