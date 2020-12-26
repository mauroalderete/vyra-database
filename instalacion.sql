DROP DATABASE IF EXISTS dbvyra2;

CREATE DATABASE IF NOT EXISTS dbvyra2
	CHARACTER SET 'UTF8MB4'
    COLLATE 'utf8mb4_spanish2_ci';

USE dbvyra2;

/*
Maestro de proveedores
*/
CREATE TABLE IF NOT EXISTS PROV_PROVEEDORES (
PROV_PROVEEDOR	int	unsigned auto_increment	primary key comment 'Clave principal que identifica a un proveedor',
PROV_NOMBRE varchar(45) not null comment 'Nombre o razon social de un proveedor',
PROV_CONTACTO	varchar(45) comment 'Nombre del contacto principal del proveedor',
PROV_TELEFONO	varchar(45) comment 'Telefono para efectuar llamadas',
PROV_WHATSAPP	varchar(45) comment 'Numero de whatsapp',
PROV_EMAIL	varchar(100) comment 'Correo electronico principal o ventas',
PROV_DIRECCION	varchar(100) comment 'Dirección principal. Generalmente coincide con la dirección del retiro de mercaderia',
PROV_PROVINCIA	varchar(100) comment 'Provincia de la dirección',
PROV_NOTAS	varchar(6000) comment 'Notas, comentarios  y observaciones sobre el proveedor',
PROV_TIEMPO_ALTA DATETIME NOT NULL default current_timestamp comment 'Fecha y hora del alta del proveedor',
PROV_BAJA	tinyint not null default 0 comment 'Indica si el proveedor esta dado de baja [1] o no [0]'
);

/*
Auditoria del modulo de proveedores
*/
CREATE TABLE IF NOT EXISTS PROV_AUDITORIA (
	AUDI_AUDITORIA bigint unsigned not null auto_increment primary key comment 'Clave principal de la auditoria del modulo de proveedores',
    AUDI_OPERACION varchar(10) not null comment 'Operacion realizada',
    AUDI_ENTIDAD varchar(100) not null comment 'Entidad sobre la que se realizo la operacion',
    AUDI_TIEMPO datetime not null default current_timestamp comment 'Fecha y hora en la que se realizo la operacion',
    AUDI_AUTOR varchar(45) not null comment 'Autor de la operacion, nombre de usuario de la sesion sql'
);

/************************************************************************************************************************************************
TRIGGERS
*************************************************************************************************************************************************/
/************************************************************************************************************************************************
TRIGGER MODULO PROVEEDORES
*************************************************************************************************************************************************/
/*------------------------------------------
Registro en auditoria nuevo proveedor
--------------------------------------------*/
DROP TRIGGER IF EXISTS TRG_PROV_PROVEEDORES_insert;
CREATE TRIGGER TRG_PROV_PROVEEDORES_insert
after insert on PROV_PROVEEDORES
for each row
insert into PROV_AUDITORIA (
	AUDI_OPERACION,
    AUDI_ENTIDAD,
    AUDI_AUTOR
)
values (
	'insert',
    new.PROV_PROVEEDOR,
	current_user
);
/*------------------------------------------
Registro en auditoria actualizacion de proveedor
--------------------------------------------*/
DROP TRIGGER IF EXISTS TRG_PROV_PROVEEDORES_update;
CREATE TRIGGER TRG_PROV_PROVEEDORES_update
after update on PROV_PROVEEDORES
for each row
insert into PROV_AUDITORIA (
	AUDI_OPERACION,
    AUDI_ENTIDAD,
    AUDI_AUTOR
)
values (
	'update',
    new.PROV_PROVEEDOR,
	current_user
);
/*------------------------------------------
Registro en auditoria eliminacion de proveedor
	Se reemplaza la eliminacion por la baja del proveedor
--------------------------------------------*/
DROP TRIGGER IF EXISTS TRG_PROV_PROVEEDORES_delete;
CREATE TRIGGER TRG_PROV_PROVEEDORES_delete
before delete on PROV_PROVEEDORES
for each row
	insert into PROV_AUDITORIA (
		AUDI_OPERACION,
		AUDI_ENTIDAD,
		AUDI_AUTOR
	)
	values (
		'delete',
		OLD.PROV_PROVEEDOR,
		current_user
	);
