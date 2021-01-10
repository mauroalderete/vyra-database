DROP TABLE IF EXISTS AUDI_AUDITORIA;
DROP TABLE IF EXISTS AUDI_LOG;
DROP TABLE IF EXISTS COMP_PAGOS;
DROP TABLE IF EXISTS COMP_COMPROBANTES_DETALLE;
DROP TABLE IF EXISTS COMP_COMPROBANTES;
DROP TABLE IF EXISTS COMP_COMPROBANTES_TIPOS;
DROP TABLE IF EXISTS PROV_PROVEEDORES;

DROP TABLE IF EXISTS STOC_MOVIMIENTOS;

DROP TABLE IF EXISTS VENT_COBROS;
DROP TABLE IF EXISTS VENT_COMPROBANTES_DETALLE;
DROP TABLE IF EXISTS VENT_COMPROBANTES;
DROP TABLE IF EXISTS VENT_COMPROBANTES_TIPOS;
DROP TABLE IF EXISTS STOC_ARTICULOS;
DROP TABLE IF EXISTS STOC_MARCAS;
DROP TABLE IF EXISTS STOC_UNIDADES;
DROP TABLE IF EXISTS CLIE_CLIENTES;

/************************************************************************************************************************************************
MODULO AUDITORIA
*************************************************************************************************************************************************/
	/*
	Auditoria de modulos
	*/
	CREATE TABLE IF NOT EXISTS AUDI_AUDITORIA (
		AUDI_AUDITORIA bigserial primary key,
        AUDI_MODULO varchar(4) not null,
        AUDI_SUBMODULO varchar(4) null,
        AUDI_OBSERVACION varchar(150) null,
		AUDI_OPERACION varchar(10) not null,
		AUDI_ENTIDAD varchar(100) not null,
		AUDI_TIEMPO timestamp not null default current_timestamp,
		AUDI_AUTOR varchar(45) not null
	);
	
	comment on table AUDI_AUDITORIA is 'Registra las operaciones que alteran los datos de las tablas de la base';
	comment on column AUDI_AUDITORIA.AUDI_AUDITORIA is 'Clave principal de la auditoria';
	comment on column AUDI_AUDITORIA.AUDI_MODULO is 'Modulo al que pertenece el evento a auditar';
	comment on column AUDI_AUDITORIA.AUDI_SUBMODULO is 'Submodulo o tabla al que pertenece el evento a auditar';
	comment on column AUDI_AUDITORIA.AUDI_OBSERVACION is 'Resumen de operacion';
	comment on column AUDI_AUDITORIA.AUDI_OPERACION is 'Operacion realizada';
	comment on column AUDI_AUDITORIA.AUDI_ENTIDAD is 'Entidad sobre la que se realizo la operacion';
	comment on column AUDI_AUDITORIA.AUDI_TIEMPO is 'Fecha y hora en la que se realizo la operacion';
	comment on column AUDI_AUDITORIA.AUDI_AUTOR is 'Autor de la operacion, nombre de usuario de la sesion sql';
	
    /*
	Registro de eventos
	*/
	CREATE TABLE IF NOT EXISTS AUDI_LOG (
		LOG_LOG bigserial primary key,
        LOG_ORIGEN varchar(45) not null,
        LOG_NIVEL smallint not null default 0,
        LOG_MENSAJE text not null,
        LOG_TIEMPO timestamp not null default current_timestamp
	);
	
	comment on table AUDI_LOG is 'Registros de eventos';
	comment on column AUDI_LOG.LOG_LOG is 'Clave principal de la auditoria';
	comment on column AUDI_LOG.LOG_ORIGEN is 'Modulo, autor, sector, bloque, funcion, proceso, trigger u otro posible origen que genera el log';
	comment on column AUDI_LOG.LOG_NIVEL is 'Nivel de log: 0 Critico, 10 Error, 20 Advertencia, 30 Depuración 40 Informacion';
	comment on column AUDI_LOG.LOG_MENSAJE is 'Mensaje a informar';
	comment on column AUDI_LOG.LOG_TIEMPO is 'Fecha y hora del log';

INSERT INTO AUDI_LOG (LOG_ORIGEN, LOG_NIVEL, LOG_MENSAJE) VALUES ('install', 40, 'Inicio de la instalación de dbVyra');

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
		PROV_PROVEEDOR	serial	primary key,
		PROV_NOMBRE varchar(45) not null,
		PROV_CONTACTO	varchar(45),
		PROV_TELEFONO	varchar(45),
		PROV_WHATSAPP	varchar(45),
		PROV_EMAIL	varchar(100),
		PROV_DIRECCION	varchar(100),
		PROV_PROVINCIA	varchar(100),
		PROV_NOTAS	text,
		PROV_BAJA	boolean not null default false
	);
	
	comment on table PROV_PROVEEDORES is 'Maestro de proveedores';
	comment on column PROV_PROVEEDORES.PROV_PROVEEDOR is 'Clave principal que identifica a un proveedor';
	comment on column PROV_PROVEEDORES.PROV_NOMBRE is 'Nombre o razon social de un proveedor';
	comment on column PROV_PROVEEDORES.PROV_CONTACTO is 'Nombre del contacto principal del proveedor';
	comment on column PROV_PROVEEDORES.PROV_TELEFONO is 'Telefono para efectuar llamadas';
	comment on column PROV_PROVEEDORES.PROV_WHATSAPP is 'Numero de whatsapp';
	comment on column PROV_PROVEEDORES.PROV_EMAIL is 'Correo electronico principal o ventas';
	comment on column PROV_PROVEEDORES.PROV_DIRECCION is 'Dirección principal. Generalmente coincide con la dirección del retiro de mercaderia';
	comment on column PROV_PROVEEDORES.PROV_PROVINCIA is 'Provincia de la dirección';
	comment on column PROV_PROVEEDORES.PROV_NOTAS is 'Notas, comentarios y observaciones sobre el proveedor';
	comment on column PROV_PROVEEDORES.PROV_BAJA is 'Indica si el proveedor esta dado de baja [1] o no [0]';

/************************************************************************************************************************************************
MODULO STOCK (1/2)
*************************************************************************************************************************************************/
	/************************************************************************************************************************************************
	MAESTRO DE UNIDADES
	*************************************************************************************************************************************************/
	CREATE TABLE IF NOT EXISTS STOC_UNIDADES (
		UNID_UNIDAD	serial	primary key,
		UNID_NOMBRE varchar(45) not null,
		UNID_SIMBOLO varchar(5) not null,
		UNID_NOTAS	text,
		UNID_BAJA	boolean not null default false,
		UNIQUE(UNID_NOMBRE)
	);
	
	/************************************************************************************************************************************************
	MAESTRO DE MARCAS
	*************************************************************************************************************************************************/
	CREATE TABLE IF NOT EXISTS STOC_MARCAS (
		MARC_MARCA	serial	primary key,
		MARC_NOMBRE varchar(45) not null,
		MARC_NOTAS	text,
		MARC_BAJA	boolean not null default false,
		UNIQUE(MARC_NOMBRE)
	);
	
	/************************************************************************************************************************************************
	MAESTRO DE ARTICULOS
	*************************************************************************************************************************************************/
	CREATE TABLE IF NOT EXISTS STOC_ARTICULOS (
		ARTS_ARTICULO	serial	primary key,
		ARTS_NOMBRE varchar(45) not null,
		ARTS_VALOR numeric(12,2) not null,
		ARTS_UNIDAD_UNID int not null,
		ARTS_MARCA_MARC int not null,
		ARTS_CANTIDAD_MINIMA numeric(12,2) not null default 0,
		ARTS_NOTAS	text,
		ARTS_BAJA	boolean not null default false,
		foreign key (ARTS_UNIDAD_UNID) references STOC_UNIDADES(UNID_UNIDAD),
        foreign key (ARTS_MARCA_MARC) references STOC_MARCAS(MARC_MARCA),
		UNIQUE(ARTS_NOMBRE, ARTS_VALOR, ARTS_UNIDAD_UNID, ARTS_MARCA_MARC)
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
		CCTP_TIPO varchar(3) not null primary key,
		CCTP_NOMBRE varchar(100) not null,
		CCTP_NOTAS text,
		CCTP_BAJA boolean not null default false
	);

	comment on table COMP_COMPROBANTES_TIPOS is 'Tipos de comprobantes para compras';
	comment on column COMP_COMPROBANTES_TIPOS.CCTP_TIPO is 'Codigo que identifica al tipo de comprobantes';
	comment on column COMP_COMPROBANTES_TIPOS.CCTP_NOMBRE is 'Nombre largo del tipo de comprobante';
	comment on column COMP_COMPROBANTES_TIPOS.CCTP_NOTAS is 'Notas, obseraciones, descripción del tipo de comprobante';
	comment on column COMP_COMPROBANTES_TIPOS.CCTP_BAJA is 'Indica si el tipo de comprobante esta dado de baja [1] o no [0]';


	/************************************************************************************************************************************************
	CABECERA DE COMPROBANTES DE COMPRA
	*************************************************************************************************************************************************/
	/*
    Tabla de cabecera de comprobantes de compras
    */
    CREATE TABLE IF NOT EXISTS COMP_COMPROBANTES (
		CCCA_TIPO_CCTP varchar(3) not null,
        CCCA_NUMERO int not null,
        CCCA_PROVEEDOR_PROV int not null,
        CCCA_COMPROBANTE varchar(45) null,
        CCCA_TIEMPO timestamp not null default current_timestamp,
        CCCA_DESCUENTO numeric(12,2) null,
        CCCA_NOTAS text,
        CCCA_BAJA boolean not null default false,
        primary key (CCCA_TIPO_CCTP, CCCA_NUMERO),
        foreign key (CCCA_TIPO_CCTP) references COMP_COMPROBANTES_TIPOS(CCTP_TIPO),
        foreign key (CCCA_PROVEEDOR_PROV) references PROV_PROVEEDORES(PROV_PROVEEDOR)
    );

	comment on table COMP_COMPROBANTES is 'Comprobantes de compras';
	comment on column COMP_COMPROBANTES.CCCA_TIPO_CCTP is 'Tipo de comprobante';
	comment on column COMP_COMPROBANTES.CCCA_NUMERO is 'Numero de comprobante';
	comment on column COMP_COMPROBANTES.CCCA_PROVEEDOR_PROV is 'Numero del proveedor';
	comment on column COMP_COMPROBANTES.CCCA_COMPROBANTE is 'Codigo del comrpobante fisico si es que existe';
	comment on column COMP_COMPROBANTES.CCCA_TIEMPO is 'Fecha y hora de emision del comprobante, puede ser diferente a la fecha y hora de alta del comprobante';
	comment on column COMP_COMPROBANTES.CCCA_DESCUENTO is 'Descuento general a toda la factura. Null si no se aplica';
	comment on column COMP_COMPROBANTES.CCCA_NOTAS is 'Notas, obseraciones, descripción del tipo de comprobante';
	comment on column COMP_COMPROBANTES.CCCA_BAJA is 'Indica si el tipo de comprobante esta dado de baja [1] o no [0]';

	/************************************************************************************************************************************************
	DETALLE DE COMPROBANTES DE COMPRA
	*************************************************************************************************************************************************/
	/*
    Tabla de detalle de comprobantes de compras
    */
    CREATE TABLE IF NOT EXISTS COMP_COMPROBANTES_DETALLE (
		CCDE_TIPO_CCCA varchar(3) not null,
        CCDE_NUMERO_CCCA int not null,
        CCDE_RENGLON int not null,
        CCDE_ARTICULO_ARTS int not null,
        CCDE_CANTIDAD numeric(12,2) not null default 1,
        CCDE_DESCUENTO numeric(5,2) null,
        CCDE_IMPORTE_BRUTO numeric(12,2) not null default 0,
        CCDE_NOTAS text,
        primary key (CCDE_TIPO_CCCA, CCDE_NUMERO_CCCA, CCDE_RENGLON),
        foreign key (CCDE_TIPO_CCCA, CCDE_NUMERO_CCCA) references COMP_COMPROBANTES(CCCA_TIPO_CCTP, CCCA_NUMERO),
        foreign key (CCDE_ARTICULO_ARTS) references STOC_ARTICULOS(ARTS_ARTICULO)
    );
	
	comment on table COMP_COMPROBANTES_DETALLE is 'Detalle con los articulos comprados';
	comment on column COMP_COMPROBANTES_DETALLE.CCDE_TIPO_CCCA is 'Tipo de comprobante';
	comment on column COMP_COMPROBANTES_DETALLE.CCDE_NUMERO_CCCA is 'Numero de comprobante';
	comment on column COMP_COMPROBANTES_DETALLE.CCDE_RENGLON is 'Renglon del detalle del comprobante';
	comment on column COMP_COMPROBANTES_DETALLE.CCDE_ARTICULO_ARTS is 'Codigo del articulo a comprar';
	comment on column COMP_COMPROBANTES_DETALLE.CCDE_CANTIDAD is 'Cantidad del articulo a ingresar';
	comment on column COMP_COMPROBANTES_DETALLE.CCDE_DESCUENTO is 'Descuento a aplicar sobre el articulo';
	comment on column COMP_COMPROBANTES_DETALLE.CCDE_IMPORTE_BRUTO is 'Importe unitario del articulo a ingresar sin el descuento aplicado';
	comment on column COMP_COMPROBANTES_DETALLE.CCDE_NOTAS is 'Notas, obseraciones, descripción del tipo de comprobante';

	/************************************************************************************************************************************************
	PAGOS DE COMPROBANTES
	*************************************************************************************************************************************************/
	/*
    Tabla para registras pagos de facturas, recibos y otros documentos ingresantes
    */
    CREATE TABLE IF NOT EXISTS COMP_PAGOS (
		CPAG_TIPO_CCCA varchar(3) not null,
        CPAG_NUMERO_CCCA int not null,
        CPAG_PAGO int not null,
        CPAG_RECIBO	varchar(45) null,
        CPAG_DESCUENTO numeric(5,2) null,
        CPAG_IMPORTE_BRUTO numeric(12,2) not null default 0,
        CPAG_NOTAS text,
        primary key (CPAG_TIPO_CCCA, CPAG_NUMERO_CCCA, CPAG_PAGO),
        foreign key (CPAG_TIPO_CCCA, CPAG_NUMERO_CCCA) references COMP_COMPROBANTES(CCCA_TIPO_CCTP, CCCA_NUMERO)
    );
	
	comment on table COMP_PAGOS is 'Pagos realizados por las compras efectuadas';
	comment on column COMP_PAGOS.CPAG_TIPO_CCCA is 'Codigo que identifica al comprobante a pagar';
	comment on column COMP_PAGOS.CPAG_NUMERO_CCCA is 'Numero del comprobante a pagar';
	comment on column COMP_PAGOS.CPAG_PAGO is 'Renglon de la cuota o numero de pago del comprobante';
	comment on column COMP_PAGOS.CPAG_RECIBO is 'Codigo identificatorio del recibo obtenido tras el pago del comprobante';
	comment on column COMP_PAGOS.CPAG_DESCUENTO is 'Descuento obtenido al realizar el pago';
	comment on column COMP_PAGOS.CPAG_IMPORTE_BRUTO is 'Importe pagado sin el descuento recibido aplicado';
	comment on column COMP_PAGOS.CPAG_NOTAS is 'Notas, obseraciones, descripción del pago';
	
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
		CLIE_CLIENTE serial	primary key,
		CLIE_NOMBRE varchar(45) not null,
		CLIE_TELEFONO	varchar(45),
		CLIE_WHATSAPP	varchar(45),
		CLIE_EMAIL	varchar(100),
		CLIE_DIRECCION	varchar(100),
		CLIE_NOTAS	text,
		CLIE_BAJA	boolean not null default false
	);
	
	comment on table CLIE_CLIENTES is 'Maestro de clientes';
	comment on column CLIE_CLIENTES.CLIE_CLIENTE is 'Clave principal que identifica a un cliente';
	comment on column CLIE_CLIENTES.CLIE_NOMBRE is 'Nombre o razon social de un cliente';
	comment on column CLIE_CLIENTES.CLIE_TELEFONO is 'Telefono para efectuar llamadas';
	comment on column CLIE_CLIENTES.CLIE_WHATSAPP is 'Numero de whatsapp';
	comment on column CLIE_CLIENTES.CLIE_EMAIL is 'Correo electronico principal o ventas';
	comment on column CLIE_CLIENTES.CLIE_DIRECCION is 'Dirección principal. Generalmente coincide con el lugar de entrega de la mercadería';
	comment on column CLIE_CLIENTES.CLIE_NOTAS is 'Notas, comentarios y observaciones sobre el cliente';
	comment on column CLIE_CLIENTES.CLIE_BAJA is 'Indica si el cliente esta dado de baja';

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
		CVTP_TIPO varchar(3) not null primary key,
        CVTP_NOMBRE varchar(100) not null,
        CVTP_NOTAS text,
        CVTP_BAJA boolean not null default false
    );
	
	/************************************************************************************************************************************************
	CABECERA DE COMPROBANTES DE VENTA
	*************************************************************************************************************************************************/
	/*
    Tabla de cabecera de comprobantes de venta
    */
    CREATE TABLE IF NOT EXISTS VENT_COMPROBANTES (
		CVCA_TIPO_CVTP varchar(3) not null,
        CVCA_NUMERO int not null,
        CVCA_CLIENTE_CLIE int not null,
        CVCA_COMPROBANTE varchar(45) null,
        CVCA_TIEMPO timestamp not null default current_timestamp,
        CVCA_DESCUENTO numeric(5,2) null,
        CVCA_NOTAS text,
        CVCA_BAJA boolean not null default false,
        primary key (CVCA_TIPO_CVTP, CVCA_NUMERO),
        foreign key (CVCA_TIPO_CVTP) references VENT_COMPROBANTES_TIPOS(CVTP_TIPO),
        foreign key (CVCA_CLIENTE_CLIE) references CLIE_CLIENTES(CLIE_CLIENTE)
    );
	
	/************************************************************************************************************************************************
	DETALLE DE COMPROBANTES DE VENTA
	*************************************************************************************************************************************************/
	/*
    Tabla de detalle de comprobantes de ventas
    */
    CREATE TABLE IF NOT EXISTS VENT_COMPROBANTES_DETALLE (
		CVDE_TIPO_CVCA varchar(3) not null,
        CVDE_NUMERO_CVCA int not null,
        CVDE_RENGLON int not null,
        CVDE_ARTICULO_ARTS int not null,
        CVDE_CANTIDAD numeric(12,2) not null default 1,
        CVDE_DESCUENTO numeric(5,2) null,
        CVDE_IMPORTE_BRUTO	numeric(12,2) not null default 0,
        CVDE_NOTAS text,
        primary key (CVDE_TIPO_CVCA, CVDE_NUMERO_CVCA, CVDE_RENGLON),
        foreign key (CVDE_TIPO_CVCA, CVDE_NUMERO_CVCA) references VENT_COMPROBANTES(CVCA_TIPO_CVTP, CVCA_NUMERO),
        foreign key (CVDE_ARTICULO_ARTS) references STOC_ARTICULOS(ARTS_ARTICULO)
    );
	
	/************************************************************************************************************************************************
	COBROS DE COMPROBANTES
	*************************************************************************************************************************************************/
	/*
    Tabla para registras cobros de facturas, recibos y otros documentos egresantes
    */
    CREATE TABLE IF NOT EXISTS VENT_COBROS (
		CCOB_TIPO_CVCA varchar(3) not null,
        CCOB_NUMERO_CVCA int not null,
        CCOB_COBRO int not null,
        CCOB_RECIBO	varchar(45) null,
        CCOB_DESCUENTO numeric(5,2) null,
        CCOB_IMPORTE_BRUTO numeric(12,2) not null default 0,
        CCOB_NOTAS text,
        primary key (CCOB_TIPO_CVCA, CCOB_NUMERO_CVCA, CCOB_COBRO),
        foreign key (CCOB_TIPO_CVCA, CCOB_NUMERO_CVCA) references VENT_COMPROBANTES(CVCA_TIPO_CVTP, CVCA_NUMERO)
    );

/************************************************************************************************************************************************
MODULO STOCK (2/2)
*************************************************************************************************************************************************/
/************************************************************************************************************************************************
REGISTRO DE MOVIMIENTOS DE STOCK
*************************************************************************************************************************************************/
	/*
	Movimiento de stock
	*/
	CREATE TABLE IF NOT EXISTS STOC_MOVIMIENTOS (
		MOVS_ARTICULO_ARTS int not null,
		MOVS_PARTIDA int not null default 1,
		MOVS_TIPO_COMP varchar(3) not null,
		MOVS_NUMERO_COMP int not null,
		MOVS_RENGLON_COMP int not null,
		MOVS_OPERACION_ENTRADA boolean not null,
		MOVS_CANTIDAD numeric(12,2) not null,
		primary key (MOVS_ARTICULO_ARTS, MOVS_PARTIDA, MOVS_TIPO_COMP, MOVS_NUMERO_COMP, MOVS_RENGLON_COMP),
		foreign key (MOVS_ARTICULO_ARTS) references STOC_ARTICULOS(ARTS_ARTICULO)
	);
	
INSERT INTO AUDI_LOG (LOG_ORIGEN, LOG_NIVEL, LOG_MENSAJE) VALUES ('install', 40, 'Finalización de la instalación de dbVyra');