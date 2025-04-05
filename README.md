# Projeto de Banco de Dados para E-commerce

Este projeto consiste na replicação e refinamento do modelo lógico de banco de dados para um cenário de e-commerce, conforme especificado no desafio.

## Descrição do Projeto Lógico

O esquema lógico do banco de dados foi projetado para suportar as operações de um sistema de e-commerce, incluindo o cadastro de clientes (tanto Pessoa Física quanto Pessoa Jurídica), produtos, pagamentos, pedidos, informações de entrega, controle de estoque, fornecedores e vendedores.

### Tabelas e seus Atributos

* **clients:** Armazena informações sobre os clientes. Inclui `idClient` (PK), `clientType` (ENUM 'PF', 'PJ'), `Fname`, `Mnit`, `Lname`, `CPF` (UNIQUE), `CNPJ` (UNIQUE), `Address`.
* **products:** Contém detalhes dos produtos. Inclui `idProduct` (PK), `Pname`, `classification`, `category` (NOT NULL), `avaliacao`, `size`.
* **payements:** Registra as formas de pagamento de cada cliente. Inclui `idClient`, `idPayement` (PK composto, FK `idClient`), `typePayement`, `limitAvaliable`.
* **orders_:** Armazena informações sobre os pedidos realizados. Inclui `idOrder` (PK), `idOrderClient` (FK `client`), `orderStatus`, `orderDescription`, `sendValue`, `payementCash`.
* **delivery:** Detalhes sobre a entrega de cada pedido. Inclui `idDelivery` (PK), `idOrder` (FK `orders`, UNIQUE), `status`, `tracking_code`.
* **productStorages:** Controla o estoque dos produtos. Inclui `idprodStorage` (PK), `storageLocation`, `quantity`.
* **supplier:** Informações sobre os fornecedores. Inclui `idSupplier` (PK), `SocialName` (NOT NULL), `CNPJ` (NOT NULL, UNIQUE), `contact` (NOT NULL).
* **sellers:** Informações sobre os vendedores. Inclui `idSeller` (PK), `SocialName` (NOT NULL), `AbstName`, `CNPJ` (UNIQUE), `CPF` (UNIQUE), `location`, `contact` (NOT NULL).
* **productSellers:** Tabela de junção para o relacionamento muitos para muitos entre produtos e vendedores. Inclui `idPseller` (FK `seller`), `idProduct` (FK `product`), `prodQuantity` (PK composto).
* **productOrders:** Tabela de junção para o relacionamento muitos para muitos entre produtos e pedidos. Inclui `idPOproduct` (FK `product`), `idPOorder` (FK `orders`), `poQuantity` (PK composto), `poStatus`.
* **storageLocations:** Tabela de junção para o relacionamento muitos para muitos entre produtos e locais de armazenamento. Inclui `idLproduct` (FK `product`), `idIstorage` (FK `productStorage`), `location` (NOT NULL, PK composto).
* **productSuppliers:** Tabela de junção para o relacionamento muitos para muitos entre produtos e fornecedores. Inclui `idPsSupplier` (FK `supplier`), `idPsProduct` (FK `product`), `quantity` (NOT NULL, PK composto).

### Refinamentos Implementados

* **Cliente PJ e PF:** A tabela `clients` foi modificada para suportar ambos os tipos de cliente através dos campos `clientType`, `CPF` e `CNPJ`, com uma constraint para garantir a integridade dos dados.
* **Pagamento:** A estrutura da tabela `payements` permite que um cliente tenha múltiplas formas de pagamento.
* **Entrega:** Foi adicionada a tabela `delivery` para rastrear o status e o código de rastreamento de cada pedido.

### Consultas SQL
Esta seção apresenta exemplos de consultas SQL para demonstrar a interação com o banco de dados do sistema de e-commerce. As consultas são organizadas por categoria para facilitar a consulta e compreensão.

#### Categorias de Consultas

* **Recuperação de Dados:** Consultas para selecionar e exibir informações das tabelas.
* **Junções:** Consultas que combinam dados de múltiplas tabelas para obter informações relacionadas.
* **Filtragem e Ordenação:** Consultas que utilizam cláusulas `WHERE`, `ORDER BY` e `LIMIT` para refinar e organizar os resultados.
* **Agregação:** Consultas que utilizam funções de agregação (por exemplo, `COUNT`, `SUM`, `AVG`) para resumir dados.
* **Manipulação de Dados:** Consultas para inserir, atualizar e excluir dados nas tabelas.

## Autor

Rafael Agra
