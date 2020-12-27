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
		AUDI_AUDITORIA bigint unsigned not null auto_increment primary key comment 'Clave principal de la auditoria',
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
	/*
    Tabla de cabecera de comprobantes de compras
    */
    CREATE TABLE IF NOT EXISTS COMP_COMPROBANTES (
		CCCA_TIPO_CCTP varchar(3) not null comment 'Tipo de comprobante',
        CCCA_NUMERO int unsigned not null comment 'Numero de comprobante',
        CCCA_PROVEEDOR_PROV int unsigned not null comment 'Numero del proveedor',
        CCCA_COMPROBANTE varchar(45) null comment 'Codigo del comrpobante fisico si es que existe',
        CCCA_TIEMPO datetime not null default current_timestamp comment 'Fecha y hora de emision del comprobante, puede ser diferente a la fecha y hora de alta del comprobante',
        CCCA_DESCUENTO decimal null comment 'Descuento general a toda la factura. Null si no se aplica',
        CCCA_NOTAS varchar(6000) comment 'Notas, obseraciones, descripción del tipo de comprobante',
        CCCA_BAJA tinyint not null default 0 comment 'Indica si el tipo de comprobante esta dado de baja [1] o no [0]',
        primary key (CCCA_TIPO_CCTP, CCCA_NUMERO),
        foreign key (CCCA_TIPO_CCTP) references COMP_COMPROBANTES_TIPOS(CCTP_TIPO),
        foreign key (CCCA_PROVEEDOR_PROV) references PROV_PROVEEDORES(PROV_PROVEEDOR)
    );
		/*------------------------------------------
		Registro en auditoria nuevo cabecera de comprobantes de compras
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_insert;
		CREATE TRIGGER auditoria_insert
		after insert on COMP_COMPROBANTES
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
            'CCCA',
            'Alta de cabecera de comprobante',
			CONCAT(new.CCCA_TIPO_CCTP, '-', new.CCCA_NUMERO),
			current_user
		);
		/*------------------------------------------
		Registro en auditoria actualizacion de cabecera de comprobantes de compras
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_update;
		CREATE TRIGGER auditoria_update
		after update on COMP_COMPROBANTES
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
            'CCCA',
            'Modificación de cabecera de comprobante',
			CONCAT(new.CCCA_TIPO_CCTP, '-', new.CCCA_NUMERO),
			current_user
		);
		/*------------------------------------------
		Registro en auditoria eliminacion de cabecera de comprobantes de compras
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_delete;
		CREATE TRIGGER auditoria_delete
		before delete on COMP_COMPROBANTES
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
			'CCCA',
			'Eliminación de cabecera de comprobante',
			CONCAT(old.CCCA_TIPO_CCTP, '-', old.CCCA_NUMERO),
			current_user
		);
/************************************************************************************************************************************************
DETALLE DE COMPROBANTES DE COMPRA
*************************************************************************************************************************************************/
	/*
    Tabla de detalle de comprobantes de compras
    */
    CREATE TABLE IF NOT EXISTS COMP_COMPROBANTES_DETALLE (
		CCDE_TIPO_CCCA varchar(3) not null comment 'Tipo de comprobante',
        CCDE_NUMERO_CCCA int unsigned not null comment 'Numero de comprobante',
        CCDE_RENGLON int unsigned not null comment 'Renglon del detalle del comprobante',
        CCDE_ARTICULO_ARTS int unsigned not null comment 'Codigo del articulo a comprar',
        CCDE_CANTIDAD decimal unsigned not null default 1 comment 'Cantidad del articulo a ingresar',
        CCDE_DESCUENTO decimal unsigned null comment 'Descuento a aplicar sobre el articulo',
        CCDE_IMPORTE_BRUTO	decimal unsigned not null default 0 comment 'Importe unitario del articulo a ingresar sin el descuento aplicado',
        CCDE_NOTAS varchar(6000) comment 'Notas, obseraciones, descripción del tipo de comprobante',
        primary key (CCDE_TIPO_CCCA, CCDE_NUMERO_CCCA, CCDE_RENGLON),
        foreign key (CCDE_TIPO_CCCA, CCDE_NUMERO_CCCA) references COMP_COMPROBANTES(CCCA_TIPO_CCTP, CCCA_NUMERO),
        foreign key (CCDE_ARTICULO_ARTS) references STOC_ARTICULOS(ARTS_ARTICULO)
    );
		/*------------------------------------------
		Registro en auditoria nuevo detalle de comprobante
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_insert;
		CREATE TRIGGER auditoria_insert
		after insert on COMP_COMPROBANTES_DETALLE
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
            'CCDE',
            'Alta de detalle de comprobante',
			CONCAT(new.CCDE_TIPO_CCCA, '-', new.CCDE_NUMERO_CCCA, '-', new.CCDE_RENGLON),
			current_user
		);
		/*------------------------------------------
		Registro en auditoria actualizacion de detalle de comprobante
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_update;
		CREATE TRIGGER auditoria_update
		after update on COMP_COMPROBANTES_DETALLE
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
            'CCDE',
            'Modificación de detalle de comprobante',
			CONCAT(new.CCDE_TIPO_CCCA, '-', new.CCDE_NUMERO_CCCA, '-', new.CCDE_RENGLON),
			current_user
		);
		/*------------------------------------------
		Registro en auditoria eliminacion de detalle de comprobante
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_delete;
		CREATE TRIGGER auditoria_delete
		before delete on COMP_COMPROBANTES_DETALLE
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
			'CCDE',
			'Eliminación de detalle de comprobante',
			CONCAT(old.CCDE_TIPO_CCCA, '-', old.CCDE_NUMERO_CCCA, '-', old.CCDE_RENGLON),
			current_user
		);
/************************************************************************************************************************************************
PAGOS DE COMPROBANTES
*************************************************************************************************************************************************/
	/*
    Tabla para registras pagos de facturas, recibos y otros documentos ingresantes
    */
    CREATE TABLE IF NOT EXISTS COMP_PAGOS (
		CPAG_TIPO_CCCA varchar(3) not null comment 'Codigo que identifica al comprobante a pagar',
        CPAG_NUMERO_CCCA int unsigned not null comment 'Numero del comprobante a pagar',
        CPAG_PAGO int unsigned not null comment 'Renglon de la cuota o numero de pago del comprobante',
        CPAG_RECIBO	varchar(45) null comment 'Codigo identificatorio del recibo obtenido tras el pago del comprobante',
        CPAG_DESCUENTO decimal unsigned null comment 'Descuento obtenido al realizar el pago',
        CPAG_IMPORTE_BRUTO decimal unsigned not null default 0 comment 'Importe pagado sin el descuento recibido aplicado',
        CPAG_NOTAS varchar(6000) comment 'Notas, obseraciones, descripción del pago',
        primary key (CPAG_TIPO_CCCA, CPAG_NUMERO_CCCA, CPAG_PAGO),
        foreign key (CPAG_TIPO_CCCA, CPAG_NUMERO_CCCA) references COMP_COMPROBANTES(CCCA_TIPO_CCTP, CCCA_NUMERO)
    );
		/*------------------------------------------
		Registro en auditoria nuevo pago
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_insert;
		CREATE TRIGGER auditoria_insert
		after insert on COMP_PAGOS
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
            'CPAG',
            'Alta de pago',
			CONCAT(new.CPAG_TIPO_CCCA, '-', new.CPAG_NUMERO_CCCA, '-', new.CPAG_PAGO),
			current_user
		);
		/*------------------------------------------
		Registro en auditoria actualizacion de pago
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_update;
		CREATE TRIGGER auditoria_update
		after update on COMP_PAGOS
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
            'CPAG',
            'Modificación de pago',
			CONCAT(new.CPAG_TIPO_CCCA, '-', new.CPAG_NUMERO_CCCA, '-', new.CPAG_PAGO),
			current_user
		);
		/*------------------------------------------
		Registro en auditoria eliminacion de pago
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_delete;
		CREATE TRIGGER auditoria_delete
		before delete on COMP_PAGOS
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
			'CPAG',
			'Eliminación de pago',
			CONCAT(old.CPAG_TIPO_CCCA, '-', old.CPAG_NUMERO_CCCA, '-', old.CPAG_PAGO),
			current_user
		);
/************************************************************************************************************************************************
MODULO CLIENTES
*************************************************************************************************************************************************/
/************************************************************************************************************************************************
MAESTRO DE CLIENTES
*************************************************************************************************************************************************/
	/*
	Tabla maestro de Clientes
	*/
	CREATE TABLE IF NOT EXISTS CLIE_CLIENTES (
	CLIE_CLIENTE int	unsigned auto_increment	primary key comment 'Clave principal que identifica a un cliente',
	CLIE_NOMBRE varchar(45) not null comment 'Nombre o razon social de un cliente',
	CLIE_CONTACTO	varchar(45) comment 'Nombre del contacto principal del cliente',
	CLIE_TELEFONO	varchar(45) comment 'Telefono para efectuar llamadas',
	CLIE_WHATSAPP	varchar(45) comment 'Numero de whatsapp',
	CLIE_EMAIL	varchar(100) comment 'Correo electronico principal o ventas',
	CLIE_DIRECCION	varchar(100) comment 'Dirección principal. Generalmente coincide con el lugar de entrega de la mercadería',
	CLIE_NOTAS	varchar(6000) comment 'Notas, comentarios y observaciones sobre el cliente',
	CLIE_BAJA	tinyint not null default 0 comment 'Indica si el cliente esta dado de baja [1] o no [0]'
	);
		/*------------------------------------------
		Registro en auditoria nuevo proveedor
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_insert;
		CREATE TRIGGER auditoria_insert
		after insert on CLIE_CLIENTES
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
            'CLIE',
            'CLIE',
            'Alta de cliente',
			new.CLIE_CLIENTE,
			current_user
		);
		/*------------------------------------------
		Registro en auditoria actualizacion de proveedor
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_update;
		CREATE TRIGGER auditoria_update
		after update on CLIE_CLIENTES
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
            'CLIE',
            'CLIE',
            'Modificación de cliente',
			new.CLIE_CLIENTE,
			current_user
		);
		/*------------------------------------------
		Registro en auditoria eliminacion de proveedor
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_delete;
		CREATE TRIGGER auditoria_delete
		before delete on CLIE_CLIENTES
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
			'CLIE',
			'CLIE',
			'Eliminación de cliente',
			old.CLIE_CLIENTE,
			current_user
		);
/************************************************************************************************************************************************
MODULO VENTAS
*************************************************************************************************************************************************/
/************************************************************************************************************************************************
TIPOS DE COMPROBANTES DE VENTAS
*************************************************************************************************************************************************/
	/*
    Tabla de tipos de comprobantes del modulo de compras
    */
    CREATE TABLE IF NOT EXISTS VENT_COMPROBANTES_TIPOS (
		CVTP_TIPO varchar(3) not null primary key comment 'Codigo que identifica al tipo de comprobantes',
        CVTP_NOMBRE varchar(100) not null comment 'Nombre largo del tipo de comprobante',
        CVTP_NOTAS varchar(6000) comment 'Notas, obseraciones, descripción del tipo de comprobante',
        CVTP_BAJA tinyint not null default 0 comment 'Indica si el tipo de comprobante esta dado de baja [1] o no [0]'
    );
		/*------------------------------------------
		Registro en auditoria nuevo tipo de comprobante de egreso
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_insert;
		CREATE TRIGGER auditoria_insert
		after insert on VENT_COMPROBANTES_TIPOS
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
            'VENT',
            'CVTP',
            'Alta de tipo de comprobante de venta',
			new.CVTP_TIPO,
			current_user
		);
		/*------------------------------------------
		Registro en auditoria actualizacion de tipo de comprobante de ingreso
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_update;
		CREATE TRIGGER auditoria_update
		after update on VENT_COMPROBANTES_TIPOS
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
            'VENT',
            'CVTP',
            'Modificación de tipo de comprobante de venta',
			new.CVTP_TIPO,
			current_user
		);
		/*------------------------------------------
		Registro en auditoria eliminacion de tipo de comprobante de ingreso
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_delete;
		CREATE TRIGGER auditoria_delete
		before delete on VENT_COMPROBANTES_TIPOS
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
			'VENT',
			'CVTP',
			'Eliminación de tipo de comprobante de venta',
			old.CVTP_TIPO,
			current_user
		);

/************************************************************************************************************************************************
CABECERA DE COMPROBANTES DE VENTA
*************************************************************************************************************************************************/
	/*
    Tabla de cabecera de comprobantes de venta
    */
    CREATE TABLE IF NOT EXISTS VENT_COMPROBANTES (
		CVCA_TIPO_CVTP varchar(3) not null comment 'Tipo de comprobante',
        CVCA_NUMERO int unsigned not null comment 'Numero de comprobante',
        CVCA_CLIENTE_CLIE int unsigned not null comment 'Numero del cliente',
        CVCA_COMPROBANTE varchar(45) null comment 'Codigo del comrpobante fisico si es que existe',
        CVCA_TIEMPO datetime not null default current_timestamp comment 'Fecha y hora de emision del comprobante, puede ser diferente a la fecha y hora de alta del comprobante',
        CVCA_DESCUENTO decimal null comment 'Descuento otorgado general a toda la venta. Null si no se aplica',
        CVCA_NOTAS varchar(6000) comment 'Notas, obseraciones, descripción del tipo de comprobante',
        CVCA_BAJA tinyint not null default 0 comment 'Indica si el tipo de comprobante esta dado de baja [1] o no [0]',
        primary key (CVCA_TIPO_CVTP, CVCA_NUMERO),
        foreign key (CVCA_TIPO_CVTP) references VENT_COMPROBANTES_TIPOS(CVTP_TIPO),
        foreign key (CVCA_CLIENTE_CLIE) references CLIE_CLIENTES(CLIE_CLIENTE)
    );
		/*------------------------------------------
		Registro en auditoria nuevo cabecera de comprobantes de venta
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_insert;
		CREATE TRIGGER auditoria_insert
		after insert on VENT_COMPROBANTES
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
            'VENT',
            'CVCA',
            'Alta de cabecera de comprobante de venta',
			CONCAT(new.CVCA_TIPO_CVTP, '-', new.CVCA_NUMERO),
			current_user
		);
		/*------------------------------------------
		Registro en auditoria actualizacion de cabecera de comprobantes de ventas
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_update;
		CREATE TRIGGER auditoria_update
		after update on VENT_COMPROBANTES
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
            'VENT',
            'CVCA',
            'Modificación de cabecera de comprobante de venta',
			CONCAT(new.CVCA_TIPO_CVTP, '-', new.CVCA_NUMERO),
			current_user
		);
		/*------------------------------------------
		Registro en auditoria eliminacion de cabecera de comprobantes de ventas
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_delete;
		CREATE TRIGGER auditoria_delete
		before delete on VENT_COMPROBANTES
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
			'VENT',
			'CVCA',
			'Eliminación de cabecera de comprobante de ventas',
			CONCAT(old.CVCA_TIPO_CVTP, '-', old.CVCA_NUMERO),
			current_user
		);
/************************************************************************************************************************************************
DETALLE DE COMPROBANTES DE VENTA
*************************************************************************************************************************************************/
	/*
    Tabla de detalle de comprobantes de ventas
    */
    CREATE TABLE IF NOT EXISTS VENT_COMPROBANTES_DETALLE (
		CVDE_TIPO_CVCA varchar(3) not null comment 'Tipo de comprobante',
        CVDE_NUMERO_CVCA int unsigned not null comment 'Numero de comprobante',
        CVDE_RENGLON int unsigned not null comment 'Renglon del detalle del comprobante',
        CVDE_ARTICULO_ARTS int unsigned not null comment 'Codigo del articulo',
        CVDE_CANTIDAD decimal unsigned not null default 1 comment 'Cantidad del articulo a vender',
        CVDE_DESCUENTO decimal unsigned null comment 'Descuento a otorgar sobre el articulo',
        CVDE_IMPORTE_BRUTO	decimal unsigned not null default 0 comment 'Importe unitario del articulo a ingresar sin el descuento aplicado',
        CVDE_NOTAS varchar(6000) comment 'Notas, obseraciones, descripción del tipo de comprobante',
        primary key (CVDE_TIPO_CVCA, CVDE_NUMERO_CVCA, CVDE_RENGLON),
        foreign key (CVDE_TIPO_CVCA, CVDE_NUMERO_CVCA) references VENT_COMPROBANTES(CVCA_TIPO_CVTP, CVCA_NUMERO),
        foreign key (CVDE_ARTICULO_ARTS) references STOC_ARTICULOS(ARTS_ARTICULO)
    );
		/*------------------------------------------
		Registro en auditoria nuevo detalle de comprobante de venta
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_insert;
		CREATE TRIGGER auditoria_insert
		after insert on VENT_COMPROBANTES_DETALLE
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
            'VENT',
            'CVDE',
            'Alta de detalle de comprobante venta',
			CONCAT(new.CVDE_TIPO_CVCA, '-', new.CVDE_NUMERO_CVCA, '-', new.CVDE_RENGLON),
			current_user
		);
		/*------------------------------------------
		Registro en auditoria actualizacion de detalle de comprobante
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_update;
		CREATE TRIGGER auditoria_update
		after update on VENT_COMPROBANTES_DETALLE
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
            'VENT',
            'CVDE',
            'Modificación de detalle de comprobante venta',
			CONCAT(new.CVDE_TIPO_CVCA, '-', new.CVDE_NUMERO_CVCA, '-', new.CVDE_RENGLON),
			current_user
		);
		/*------------------------------------------
		Registro en auditoria eliminacion de detalle de comprobante
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_delete;
		CREATE TRIGGER auditoria_delete
		before delete on VENT_COMPROBANTES_DETALLE
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
			'VENT',
			'CVDE',
			'Eliminación de detalle de comprobante venta',
			CONCAT(old.CVDE_TIPO_CVCA, '-', old.CVDE_NUMERO_CVCA, '-', old.CVDE_RENGLON),
			current_user
		);
/************************************************************************************************************************************************
COBROS DE COMPROBANTES
*************************************************************************************************************************************************/
	/*
    Tabla para registras cobros de facturas, recibos y otros documentos egresantes
    */
    CREATE TABLE IF NOT EXISTS VENT_COBROS (
		CCOB_TIPO_CVCA varchar(3) not null comment 'Codigo que identifica al comprobante a cobrar',
        CCOB_NUMERO_CVCA int unsigned not null comment 'Numero del comprobante a cobrar',
        CCOB_COBRO int unsigned not null comment 'Renglon de la cuota o numero de cobro del comprobante',
        CCOB_RECIBO	varchar(45) null comment 'Codigo identificatorio del recibo emitido tras la recepción del pago',
        CCOB_DESCUENTO decimal unsigned null comment 'Descuento otorgado al recibir el cobro',
        CCOB_IMPORTE_BRUTO decimal unsigned not null default 0 comment 'Importe cobrad sin el descuento otorgado aplicado',
        CCOB_NOTAS varchar(6000) comment 'Notas, obseraciones, descripción del cobro',
        primary key (CCOB_TIPO_CVCA, CCOB_NUMERO_CVCA, CCOB_COBRO),
        foreign key (CCOB_TIPO_CVCA, CCOB_NUMERO_CVCA) references VENT_COMPROBANTES(CVCA_TIPO_CVTP, CVCA_NUMERO)
    );
		/*------------------------------------------
		Registro en auditoria nuevo pago
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_insert;
		CREATE TRIGGER auditoria_insert
		after insert on VENT_COBROS
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
            'VENT',
            'CCOB',
            'Alta de cobro',
			CONCAT(new.CCOB_TIPO_CVCA, '-', new.CCOB_NUMERO_CVCA, '-', new.CCOB_COBRO),
			current_user
		);
		/*------------------------------------------
		Registro en auditoria actualizacion de pago
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_update;
		CREATE TRIGGER auditoria_update
		after update on VENT_COBROS
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
            'VENT',
            'CCOB',
            'Modificación de cobro',
			CONCAT(new.CCOB_TIPO_CVCA, '-', new.CCOB_NUMERO_CVCA, '-', new.CCOB_COBRO),
			current_user
		);
		/*------------------------------------------
		Registro en auditoria eliminacion de pago
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS auditoria_delete;
		CREATE TRIGGER auditoria_delete
		before delete on VENT_COBROS
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
			'VENT',
			'COCB',
			'Eliminación de cobro',
			CONCAT(old.CCOB_TIPO_CVCA, '-', old.CCOB_NUMERO_CVCA, '-', old.CCOB_COBRO),
			current_user
		);