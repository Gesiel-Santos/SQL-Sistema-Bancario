-- -----------------------------------------------------
-- Schema ecommerce_
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ecommerce_` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `ecommerce_` ;

-- -----------------------------------------------------
-- Table `ecommerce_`.`Clientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce_`.`Clientes` (
  `idClient` INT NOT NULL AUTO_INCREMENT,
  `Pname` VARCHAR(10) NOT NULL,
  `Minit` CHAR(3) NULL,
  `Lname` VARCHAR(20) NOT NULL,
  `Address` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`idClient`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce_`.`Entregas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce_`.`Entregas` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Cod` INT NOT NULL,
  `Status` ENUM('Aguardando', 'Em preparação', 'Enviado', 'Em trânsito', 'Saiu para entrega', 'Entregue') NOT NULL DEFAULT 'Aguardando',
  `ShipValue` FLOAT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce_`.`CreditCards`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce_`.`CreditCards` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NOT NULL,
  `Number` VARCHAR(15) NOT NULL,
  `Flag` VARCHAR(45) NOT NULL,
  `ExpDate` DATE NOT NULL,
  `fk_idClient` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `Number_UNIQUE` (`Number` ASC) VISIBLE,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_Pagamentos_Clientes1_idx` (`fk_idClient` ASC) VISIBLE,
  CONSTRAINT `fk_Pagamentos_Clientes1`
    FOREIGN KEY (`fk_idClient`)
    REFERENCES `ecommerce_`.`Clientes` (`idClient`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce_`.`Formas_Pagamentos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce_`.`Formas_Pagamentos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `PayType` VARCHAR(45) NOT NULL DEFAULT 'Pix',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `PayType_UNIQUE` (`PayType` ASC) VISIBLE,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce_`.`Pedidos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce_`.`Pedidos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `fk_idClient` INT NOT NULL,
  `fk_idDeliver` INT NOT NULL,
  `fk_idPayType` INT NOT NULL,
  `fk_idCreditCard` INT NULL,
  `Status` ENUM('Cancelado', 'Confirmado', 'Em processamento') NOT NULL DEFAULT 'Em Processamento',
  `Description` VARCHAR(255) NULL,
  `TotalValue` FLOAT NOT NULL,
  `Date` DATE NOT NULL,
  `NumberPayment` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`, `fk_idClient`, `fk_idDeliver`),
  INDEX `fk_Pedido_Cliente1_idx` (`fk_idClient` ASC) VISIBLE,
  INDEX `fk_Pedidos_Entregas1_idx` (`fk_idDeliver` ASC) VISIBLE,
  INDEX `fk_Pedidos_CreditCards1_idx` (`fk_idCreditCard` ASC) VISIBLE,
  INDEX `fk_Pedidos_Formas_Pagamentos1_idx` (`fk_idPayType` ASC) VISIBLE,
  CONSTRAINT `fk_Pedido_Cliente1`
    FOREIGN KEY (`fk_idClient`)
    REFERENCES `ecommerce_`.`Clientes` (`idClient`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pedidos_Entregas1`
    FOREIGN KEY (`fk_idDeliver`)
    REFERENCES `ecommerce_`.`Entregas` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pedidos_CreditCards1`
    FOREIGN KEY (`fk_idCreditCard`)
    REFERENCES `ecommerce_`.`CreditCards` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pedidos_Formas_Pagamentos1`
    FOREIGN KEY (`fk_idPayType`)
    REFERENCES `ecommerce_`.`Formas_Pagamentos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce_`.`Produtos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce_`.`Produtos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(20) NOT NULL,
  `ClassKids` TINYINT NOT NULL DEFAULT 0,
  `Category` ENUM('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') NOT NULL,
  `Size` VARCHAR(10) NULL,
  `Rating` FLOAT NULL DEFAULT 0,
  `Price` FLOAT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce_`.`Fornecedores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce_`.`Fornecedores` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `SocialName` VARCHAR(255) NOT NULL,
  `CNPJ` CHAR(15) NOT NULL,
  `Contact` CHAR(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `CNPJ_UNIQUE` (`CNPJ` ASC) VISIBLE,
  UNIQUE INDEX `idFornecedor_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce_`.`Fornecedores_Produtos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce_`.`Fornecedores_Produtos` (
  `fk_idSupplier` INT NOT NULL,
  `fk_idProduct` INT NOT NULL,
  `Qtd` INT NOT NULL,
  PRIMARY KEY (`fk_idSupplier`, `fk_idProduct`),
  INDEX `fk_Fornecedor_has_Produto_Produto1_idx` (`fk_idProduct` ASC) VISIBLE,
  INDEX `fk_Fornecedor_has_Produto_Fornecedor1_idx` (`fk_idSupplier` ASC) VISIBLE,
  CONSTRAINT `fk_Fornecedor_has_Produto_Fornecedor1`
    FOREIGN KEY (`fk_idSupplier`)
    REFERENCES `ecommerce_`.`Fornecedores` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Fornecedor_has_Produto_Produto1`
    FOREIGN KEY (`fk_idProduct`)
    REFERENCES `ecommerce_`.`Produtos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce_`.`Estoques`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce_`.`Estoques` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Local` VARCHAR(255) NOT NULL,
  `Name` VARCHAR(50) NULL DEFAULT 0,
  `Contact` CHAR(11) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce_`.`Produtos_Estoques`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce_`.`Produtos_Estoques` (
  `fk_idProduct` INT NOT NULL,
  `fk_idStorage` INT NOT NULL,
  `Qtd` INT NOT NULL,
  PRIMARY KEY (`fk_idProduct`, `fk_idStorage`),
  INDEX `fk_Produto_has_Estoque_Estoque1_idx` (`fk_idStorage` ASC) VISIBLE,
  INDEX `fk_Produto_has_Estoque_Produto1_idx` (`fk_idProduct` ASC) VISIBLE,
  CONSTRAINT `fk_Produto_has_Estoque_Produto1`
    FOREIGN KEY (`fk_idProduct`)
    REFERENCES `ecommerce_`.`Produtos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Produto_has_Estoque_Estoque1`
    FOREIGN KEY (`fk_idStorage`)
    REFERENCES `ecommerce_`.`Estoques` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce_`.`Pedidos_Produtos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce_`.`Pedidos_Produtos` (
  `fk_idProduct` INT NOT NULL,
  `fk_idOrder` INT NOT NULL,
  `Qtd` INT NULL DEFAULT 1,
  `Status` ENUM('Disponível', 'Sem estoque') NOT NULL DEFAULT 'Disponível',
  PRIMARY KEY (`fk_idProduct`, `fk_idOrder`),
  INDEX `fk_Produto_has_Pedido_Pedido1_idx` (`fk_idOrder` ASC) VISIBLE,
  INDEX `fk_Produto_has_Pedido_Produto1_idx` (`fk_idProduct` ASC) VISIBLE,
  CONSTRAINT `fk_Produto_has_Pedido_Produto1`
    FOREIGN KEY (`fk_idProduct`)
    REFERENCES `ecommerce_`.`Produtos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Produto_has_Pedido_Pedido1`
    FOREIGN KEY (`fk_idOrder`)
    REFERENCES `ecommerce_`.`Pedidos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce_`.`Vendedores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce_`.`Vendedores` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `SocialName` VARCHAR(255) NOT NULL,
  `AbstName` VARCHAR(255) NULL,
  `CNPJ` CHAR(15) NULL,
  `CPF` CHAR(11) NULL,
  `Local` VARCHAR(255) NOT NULL,
  `Contact` CHAR(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `CNPJ_UNIQUE` (`CNPJ` ASC) VISIBLE,
  UNIQUE INDEX `CPF_UNIQUE` (`CPF` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce_`.`Produtos_Terceiros`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce_`.`Produtos_Terceiros` (
  `fk_idSeller` INT NOT NULL,
  `fk_idProduct` INT NOT NULL,
  `Qtd` INT NULL DEFAULT 1,
  PRIMARY KEY (`fk_idSeller`, `fk_idProduct`),
  INDEX `fk_Terceiros - Vendedor_has_Relação de Produto/Pedido_Rel_idx` (`fk_idProduct` ASC) VISIBLE,
  INDEX `fk_Terceiros - Vendedor_has_Relação de Produto/Pedido_Ter_idx` (`fk_idSeller` ASC) VISIBLE,
  CONSTRAINT `fk_Terceiros - Vendedor_has_Relação de Produto/Pedido_Terce1`
    FOREIGN KEY (`fk_idSeller`)
    REFERENCES `ecommerce_`.`Vendedores` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Terceiros - Vendedor_has_Relação de Produto/Pedido_Rela1`
    FOREIGN KEY (`fk_idProduct`)
    REFERENCES `ecommerce_`.`Pedidos_Produtos` (`fk_idProduct`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce_`.`Documentos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce_`.`Documentos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `DocType` ENUM('CPF', 'CNPJ') NOT NULL DEFAULT 'CPF',
  `DocNum` VARCHAR(15) NOT NULL,
  `fk_idClient` INT NOT NULL,
  PRIMARY KEY (`id`, `fk_idClient`),
  INDEX `fk_Documentos_Cliente1_idx` (`fk_idClient` ASC) VISIBLE,
  UNIQUE INDEX `DocNum_UNIQUE` (`DocNum` ASC) VISIBLE,
  CONSTRAINT `fk_Documentos_Cliente1`
    FOREIGN KEY (`fk_idClient`)
    REFERENCES `ecommerce_`.`Clientes` (`idClient`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;