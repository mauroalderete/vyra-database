DROP DATABASE IF EXISTS dbvyra2;

CREATE DATABASE IF NOT EXISTS dbvyra2
	CHARACTER SET 'UTF8MB4'
    COLLATE 'utf8mb4_spanish2_ci';

USE dbvyra2;

/************************************************************************************************************************************************
MODULO AUDITORIA
*************************************************************************************************************************************************/
	/*
	Auditoria de modulos
	*/
	CREATE TABLE IF NOT EXISTS AUDI_AUDITORIA (
		AUDI_AUDITORIA bigint unsigned not null auto_increment primary key comment 'Clave principal de la auditoria del modulo de proveedores',
        AUDI_MODULO varchar(4) not null comment 'Modulo al que pertenece el evento a auditar',
        AUDI_SUBMODULO varchar(4) null comment 'Submodulo o tabla al que pertenece el evento a auditar',
        AUDI_OBSERVACION varchar(150) null comment 'Resumen de operacion',
		AUDI_OPERACION varchar(10) not null comment 'Operacion realizada',
		AUDI_ENTIDAD varchar(100) not null comment 'Entidad sobre la que se realizo la operacion',
		AUDI_TIEMPO datetime not null default current_timestamp comment 'Fecha y hora en la que se realizo la operacion',
		AUDI_AUTOR varchar(45) not null comment 'Autor de la operacion, nombre de usuario de la sesion sql'
	);

/************************************************************************************************************************************************
MODULO PROVEEDORES
*************************************************************************************************************************************************/
/************************************************************************************************************************************************
MAESTRO DE PROVEEDORES
*************************************************************************************************************************************************/
	/*
	Tabla maestro de Proveedores
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
	PROV_NOTAS	varchar(6000) comment 'Notas, comentarios y observaciones sobre el proveedor',
	PROV_BAJA	tinyint not null default 0 comment 'Indica si el proveedor esta dado de baja [1] o no [0]'
	);
		/*------------------------------------------
		Registro en auditoria nuevo proveedor
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_insert;
		CREATE TRIGGER auditoria_insert
		after insert on PROV_PROVEEDORES
		for each row
		insert into AUDI_AUDITORIA (
			AUDI_OPERACION,
            AUDI_MODULO,
			AUDI_SUBMODULO,
            AUDI_OBSERVACION,
            AUDI_ENTIDAD,
			AUDI_AUTOR
		)
		values (
			'insert',
            'PROV',
            'PROV',
            'Alta de proveedor',
			new.PROV_PROVEEDOR,
			current_user
		);
		/*------------------------------------------
		Registro en auditoria actualizacion de proveedor
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_update;
		CREATE TRIGGER auditoria_update
		after update on PROV_PROVEEDORES
		for each row
		insert into AUDI_AUDITORIA (
			AUDI_OPERACION,
            AUDI_MODULO,
			AUDI_SUBMODULO,
            AUDI_OBSERVACION,
            AUDI_ENTIDAD,
			AUDI_AUTOR
		)
		values (
			'update',
            'PROV',
            'PROV',
            'Modificación de proveedor',
			new.PROV_PROVEEDOR,
			current_user
		);
		/*------------------------------------------
		Registro en auditoria eliminacion de proveedor
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_delete;
		CREATE TRIGGER auditoria_delete
		before delete on PROV_PROVEEDORES
		for each row
			insert into AUDI_AUDITORIA (
				AUDI_OPERACION,
                AUDI_MODULO,
                AUDI_SUBMODULO,
                AUDI_OBSERVACION,
				AUDI_ENTIDAD,
				AUDI_AUTOR
			)
			values (
				'delete',
                'PROV',
                'PROV',
				'Eliminación de proveedor',
				OLD.PROV_PROVEEDOR,
				current_user
			);
/************************************************************************************************************************************************
MODULO STOCK
*************************************************************************************************************************************************/
/************************************************************************************************************************************************
MAESTRO DE ARTICULOS
*************************************************************************************************************************************************/
	/*
	Maestro de articulos
	*/
	CREATE TABLE IF NOT EXISTS STOC_ARTICULOS (
	ARTS_ARTICULO	int	unsigned auto_increment	primary key comment 'Clave principal que identifica a un articulo',
	ARTS_NOMBRE varchar(45) not null comment 'Nombre del articulo, se recomienda <nombre> <formato> <unidad medida>',
    CANTIDAD_MINIMA	decimal not null default 0 comment 'Indica la cantidad minima que debe haber en el stock antes de emitir una notificacion',
	PROV_NOTAS	varchar(6000) comment 'Notas, comentarios y observaciones sobre el articulo',
	PROV_BAJA	tinyint not null default 0 comment 'Indica si el articulo esta dado de baja [1] o no [0]'
	);
		/*------------------------------------------
		Registro en auditoria nuevo articulo
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_insert;
		CREATE TRIGGER auditoria_insert
		after insert on STOC_ARTICULOS
		for each row
		insert into AUDI_AUDITORIA (
			AUDI_OPERACION,
            AUDI_MODELO,
            AUDI_SUBMODELO,
            AUDI_OBSERVACION,
			AUDI_ENTIDAD,
			AUDI_AUTOR
		)
		values (
			'insert',
            'STOC',
            'ARTS',
            'Alta de artículo',
			new.ARTS_ARTICULO,
			current_user
		);
		/*------------------------------------------
		Registro en auditoria actualizacion de articulo
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_update;
		CREATE TRIGGER auditoria_update
		after update on STOC_ARTICULOS
		for each row
		insert into AUDI_AUDITORIA (
			AUDI_OPERACION,
            AUDI_MODULO,
			AUDI_SUBMODULO,
            AUDI_OBSERVACION,
            AUDI_ENTIDAD,
			AUDI_AUTOR
		)
		values (
			'update',
            'STOC',
            'ARTS',
            'Modificación de artículo',
			new.ARTS_ARTICULO,
			current_user
		);
		/*------------------------------------------
		Registro en auditoria eliminacion de articulo
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_delete;
		CREATE TRIGGER auditoria_delete
		before delete on STOC_ARTICULOS
		for each row
			insert into AUDI_AUDITORIA (
				AUDI_OPERACION,
                AUDI_MODULO,
                AUDI_SUBMODULO,
                AUDI_OBSERVACION,
				AUDI_ENTIDAD,
				AUDI_AUTOR
			)
			values (
				'delete',
                'STOC',
                'ARTS',
				'Eliminación de artículo',
				OLD.ARTS_ARTICULO,
				current_user
			);
/************************************************************************************************************************************************
MODULO COMPRAS
*************************************************************************************************************************************************/
/************************************************************************************************************************************************
TIPOS DE COMPROBANTES DE COMPRAS
*************************************************************************************************************************************************/
	/*
    Tabla de tipos de comprobantes del modulo de compras
    */
    CREATE TABLE IF NOT EXISTS COMP_COMPROBANTES_TIPOS (
		CCTP_TIPO varchar(3) not null primary key comment 'Codigo que identifica al tipo de comprobantes',
        CCTP_NOMBRE varchar(100) not null comment 'Nombre largo del tipo de comprobante',
        CCTP_NOTAS varchar(6000) comment 'Notas, obseraciones, descripción del tipo de comprobante',
        CCTP_BAJA tinyint not null default 0 comment 'Indica si el tipo de comprobante esta dado de baja [1] o no [0]'
    );
		/*------------------------------------------
		Registro en auditoria nuevo tipo de comprobante de ingreso
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_insert;
		CREATE TRIGGER auditoria_insert
		after insert on COMP_COMPROBANTES_TIPOS
		for each row
		insert into AUDI_AUDITORIA (
			AUDI_OPERACION,
            AUDI_MODULO,
			AUDI_SUBMODULO,
            AUDI_OBSERVACION,
            AUDI_ENTIDAD,
			AUDI_AUTOR
		)
		values (
			'insert',
            'COMP',
            'CCTP',
            'Alta de tipo de comprobante de compra',
			new.CCTP_TIPO,
			current_user
		);
		/*------------------------------------------
		Registro en auditoria actualizacion de tipo de comprobante de ingreso
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_update;
		CREATE TRIGGER auditoria_update
		after update on COMP_COMPROBANTES_TIPOS
		for each row
		insert into AUDI_AUDITORIA (
			AUDI_OPERACION,
            AUDI_MODULO,
			AUDI_SUBMODULO,
            AUDI_OBSERVACION,
            AUDI_ENTIDAD,
			AUDI_AUTOR
		)
		values (
			'update',
            'COMP',
            'CCTP',
            'Modificación de tipo de comprobante de compra',
			new.CCTP_TIPO,
			current_user
		);
		/*------------------------------------------
		Registro en auditoria eliminacion de tipo de comprobante de ingreso
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_delete;
		CREATE TRIGGER auditoria_delete
		before delete on COMP_COMPROBANTES_TIPOS
		for each row
			insert into AUDI_AUDITORIA (
				AUDI_OPERACION,
                AUDI_MODULO,
                AUDI_SUBMODULO,
                AUDI_OBSERVACION,
				AUDI_ENTIDAD,
				AUDI_AUTOR
			)
			values (
				'delete',
                'COMP',
                'CCTP',
				'Eliminación de tipo de comprobante de compra',
				OLD.CCTP_TIPO,
				current_user
			);

/************************************************************************************************************************************************
CABECERA DE COMPROBANTES DE COMPRA
*************************************************************************************************************************************************/
/************************************************************************************************************************************************
DETALLE DE COMPROBANTES DE COMPRA
*************************************************************************************************************************************************/
/************************************************************************************************************************************************
PAGOS DE COMPROBANTES
*************************************************************************************************************************************************/