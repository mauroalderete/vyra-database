DROP DATABASE IF EXISTS dbvyra;

CREATE DATABASE IF NOT EXISTS dbvyra
	CHARACTER SET 'UTF8MB4'
    COLLATE 'utf8mb4_spanish2_ci';

USE dbvyra;

/************************************************************************************************************************************************
AUDITORIA
*************************************************************************************************************************************************/
/*
Auditoria de modulos
*/
CREATE TABLE IF NOT EXISTS AUDI_AUDITORIA (
	AUDI_AUDITORIA bigint unsigned not null auto_increment comment 'Clave principal de la auditoria',
    AUDI_MODULO varchar(4) not null comment 'Modulo al que pertenece el evento a auditar',
    AUDI_SUBMODULO varchar(4) not null comment 'Submodulo o tabla al que pertenece el evento a auditar',
	AUDI_OPERACION varchar(10) not null comment 'Operacion realizada',
	AUDI_ENTIDAD varchar(100) not null comment 'Entidad sobre la que se realizo la operacion',
    AUDI_OBSERVACION varchar(150) null comment 'Resumen de operacion',
	AUDI_TIEMPO datetime not null default current_timestamp comment 'Fecha y hora en la que se realizo la operacion',
	AUDI_AUTOR varchar(45) not null comment 'Autor de la operacion, nombre de usuario de la sesion sql',

    PRIMARY KEY (AUDI_AUDITORIA)
);
/*
Registro de eventos
*/
CREATE TABLE IF NOT EXISTS AUDI_LOG (
	LOG_LOG bigint unsigned not null auto_increment comment 'Clave principal de la auditoria',
    LOG_ORIGEN varchar(45) not null comment 'Modulo, autor, sector, bloque, funcion, proceso, trigger u otro posible origen que genera el log',
    LOG_NIVEL tinyint unsigned not null default 0 comment 'Nivel de log: 0 Critico, 10 Error, 20 Advertencia, 30 Depuración 40 Informacion',
    LOG_MENSAJE varchar(6000) not null comment 'Mensaje a informar',
    LOG_TIEMPO datetime not null default current_timestamp comment 'Fecha y hora del log',

    PRIMARY KEY (LOG_LOG)
);

INSERT INTO AUDI_LOG (LOG_ORIGEN, LOG_NIVEL, LOG_MENSAJE) VALUES ('Instalación', 40, 'Inicio de la instalación de dbvyra');

/*********************************************************************************************
DOMINIO PRINCIPAL
*********************************************************************************************/
/*********************************************************************************************
DOMINIO PRINCIPAL: UNIDADES DE STOCK
*********************************************************************************************/
CREATE TABLE IF NOT EXISTS STOC_TIPOS_UNIDADES(
    TPUN_TIPO bigint unsigned not null auto_increment comment 'Clave principal de los tipos de unidades',
    TPUN_NOMBRE varchar(100) not null unique comment 'Nombre del tipo de unidad',

    PRIMARY KEY (TPUN_TIPO)
);

CREATE TABLE IF NOT EXISTS STOC_UNIDADES(
    UNID_UNIDAD bigint unsigned not null auto_increment comment 'Clave principal de las unidades',
    UNID_TIPO_TPUN bigint unsigned not null comment 'Tipo de unidad al que pertenecen las unidades',
    UNID_NOMBRE_SINGULAR varchar(100) not null comment 'Nombre de la unidad cuando la cantidad es 1',
    UNID_NOMBRE_PLURAL varchar(100) not null comment 'Nombre de la unidad cuando la cantidad es mayor a 1',
    UNID_FACTOR decimal unsigned not null default 1 comment 'Es el factor de conversion de la unidad, indica cuantas unidades de stock equivalen a la unidad definida',

    PRIMARY KEY (UNID_UNIDAD),
    FOREIGN KEY (UNID_TIPO_TPUN) REFERENCES STOC_TIPOS_UNIDADES(TPUN_TIPO)
);
/*********************************************************************************************
DOMINIO PRINCIPAL: MARCAS
*********************************************************************************************/
CREATE TABLE IF NOT EXISTS STOC_MARCAS(
    MARC_MARCA bigint unsigned not null auto_increment comment 'Clave principal de las marcas',
    MARC_NOMBRE varchar(100) not null unique comment 'Nombre de la marca',

    PRIMARY KEY (MARC_MARCA),
    UNIQUE KEY MARC_UK01 (MARC_NOMBRE)
);
/*********************************************************************************************
DOMINIO PRINCIPAL: RUBROS
*********************************************************************************************/
CREATE TABLE IF NOT EXISTS STOC_RUBROS(
    RUBR_RUBRO bigint unsigned not null auto_increment comment 'Clave principal de los rubros',
    RUBR_PADRE bigint unsigned null comment 'Rubro padre al que pertenece',
    RUBR_NOMBRE varchar(100) not null unique comment 'Nombre del rubro',

    PRIMARY KEY (RUBR_RUBRO),
    FOREIGN KEY (RUBR_PADRE) REFERENCES STOC_RUBROS(RUBR_RUBRO),
    UNIQUE KEY MARC_UK01 (RUBR_NOMBRE)
);
/*********************************************************************************************
DOMINIO PRINCIPAL: ARTICULOS
*********************************************************************************************/
CREATE TABLE IF NOT EXISTS STOC_ARTICULOS(
    ARTS_ARTICULO bigint unsigned not null auto_increment comment 'Clave principal de los articulos',
    ARTS_NOMBRE varchar(200) not null comment 'Nombre del articulo completo, incluye presentacion, marca y otras caractersticas',
    ARTS_NOMBRE_IMPRESION varchar(200) not null comment 'Nombre mostrado en impresiones, generalmente mas corto',
    ARTS_RUBRO_RUBR bigint unsigned not null comment 'Rubro al que pertenece un articulo',
    ARTS_MARCA_MARC bigint unsigned not null comment 'Marca del articulo',
    ARTS_UNISTO_TPUN bigint unsigned not null comment 'Tipo de unidad de stock con la que se mide el articulo',
    ARTS_CANTIDAD_MINIMA decimal unsigned not null default 0 comment 'Cantidad minima del articulo que debe haber siempre presente en el almacen',
    ARTS_NOTAS varchar(6000) comment 'Notas, comentarios y observaciones',
    ARTS_ALTA_TIEMPO datetime not null default current_timestamp comment 'Fecha y hora en que se dio de alta el articulo',
    ARTS_BAJA_TIEMPO datetime null comment 'Fecha y hora en que se determina su baja. Puede ser un valor pasado o futuro.',

    PRIMARY KEY (ARTS_ARTICULO),
    FOREIGN KEY (ARTS_RUBRO_RUBR) REFERENCES STOC_RUBROS(RUBR_RUBRO),
    FOREIGN KEY (ARTS_MARCA_MARC) REFERENCES STOC_MARCAS(MARC_MARCA),
    FOREIGN KEY (ARTS_UNISTO_TPUN) REFERENCES STOC_TIPOS_UNIDADES(TPUN_TIPO),
    UNIQUE KEY ARTS_UK01 (ARTS_NOMBRE),
    UNIQUE KEY ARTS_UK02 (ARTS_NOMBRE_IMPRESION)
);
/*********************************************************************************************
DOMINIO PRINCIPAL: COMBOS
*********************************************************************************************/
CREATE TABLE IF NOT EXISTS STOC_COMBOS(
    COMB_COMBO bigint unsigned not null comment 'Referencia al articulo que es un combo',
    COMB_HABILITADO boolean not null default TRUE comment 'Estado del combo',

    FOREIGN KEY (COMB_COMBO) REFERENCES STOC_ARTICULOS(ARTS_ARTICULO),
    UNIQUE KEY COMB_UK01 (COMB_COMBO)
);

CREATE TABLE IF NOT EXISTS STOC_COMBOS_DETALLE(
    CBDE_COMBO_COMB bigint unsigned not null comment 'Referencia al combo',
    CBDE_ARTICULO_ARTS bigint unsigned not null comment 'Referencia al articulo que compone parte del combo',
    CBDE_CANTIDAD decimal unsigned not null default 1 comment 'Cantidad del articulo en unidades de stock',

    PRIMARY KEY (CBDE_COMBO_COMB, CBDE_ARTICULO_ARTS),
    FOREIGN KEY (CBDE_COMBO_COMB) REFERENCES STOC_COMBOS(COMB_COMBO) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (CBDE_ARTICULO_ARTS) REFERENCES STOC_ARTICULOS(ARTS_ARTICULO),
    CONSTRAINT CBDE_CH01 CHECK (CBDE_CANTIDAD>0)

);
/*********************************************************************************************
DOMINIO PRINCIPAL: PARTIDAS
*********************************************************************************************/
CREATE TABLE IF NOT EXISTS STOC_PARTIDAS(
    PART_PARTIDA bigint unsigned not null auto_increment comment 'Clave principal de la partida',
    PART_ARTICULO_ARTS bigint unsigned not null comment 'Referencia a al articulo de la partida',
    PART_ALTA_TIEMPO datetime not null default current_timestamp comment 'Fecha y hora de alta de la partida',
    PART_ALTA_CANTIDAD decimal not null default 1 comment 'Cantidad del articulo en unidades de stock cuando la partida fue dada de alta',
    PART_BAJA_TIEMPO datetime null comment 'Fecha y hora de baja de la partida. Esto refleja una perdida, por vencimiento, por producto defectuoso, por accidente',
    PART_BAJA_NOTAS varchar(6000) null comment 'Observaciones sobre la baja. Se indica la causa entre otras',
    PART_STOC_ACTUAL decimal unsigned not null comment 'Cantidad del articulo en unidades de stock actualmente',
    PART_FECHA_VENCIMIENTO datetime not null comment 'Fecha de vencimiento de la partida',

    PRIMARY KEY (PART_PARTIDA),
    FOREIGN KEY (PART_ARTICULO_ARTS) REFERENCES STOC_ARTICULOS(ARTS_ARTICULO),
    CONSTRAINT PART_CH01 CHECK (PART_ALTA_CANTIDAD>0)
);
/*********************************************************************************************
DOMINIO PRINCIPAL: MOVIMIENTOS DE STOCK
*********************************************************************************************/
CREATE TABLE IF NOT EXISTS STOC_MOVS(
    MOVS_MOVIMIENTO bigint unsigned not null auto_increment comment 'Clave principal del movimiento de stock',
    MOVS_PARTIDA_PART bigint unsigned not null comment 'Referencia a la partida que es alterada',
    MOVS_SIGNO varchar(1) not null comment 'Tipo de movimiento de stock, E indica un ingreso y S una salida. El primer registro deberia ser el unico tipo E',
    MOVS_CANTIDAD decimal not null comment 'Cantidad de unidades de stock del articulo movidas',
    MOVS_ALTA_TIEMPO datetime not null default current_timestamp comment 'Fecha y hora del movimiento',
    MOVS_NOTAS varchar(6000) null comment 'Notas, comentarios, observaciones',

    PRIMARY KEY (MOVS_MOVIMIENTO),
    FOREIGN KEY (MOVS_PARTIDA_PART) REFERENCES STOC_PARTIDAS(PART_PARTIDA),
    CONSTRAINT MOVS_CH01 CHECK (MOVS_CANTIDAD>0),
    CONSTRAINT MOVS_CH02 CHECK (MOVS_SIGNO IN ('E','S'))
);
