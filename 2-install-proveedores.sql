DROP TABLE IF EXISTS PROV_PROVEEDORES;

INSERT INTO AUDI_LOG (LOG_ORIGEN, LOG_NIVEL, LOG_MENSAJE) VALUES ('Instalación', 40, 'Instalación Modulo Proveedores');
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

CREATE OR REPLACE FUNCTION PROV_PROVEEDORES_auditoria_insert_func() RETURNS TRIGGER
AS $PROV_PROVEEDORES_auditoria_insert$
BEGIN
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

	RETURN NEW;
END;
$PROV_PROVEEDORES_auditoria_insert$ language plpgsql;

CREATE OR REPLACE FUNCTION PROV_PROVEEDORES_auditoria_update_func() RETURNS TRIGGER
AS $PROV_PROVEEDORES_auditoria_update$
BEGIN
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

	RETURN NEW;
END;
$PROV_PROVEEDORES_auditoria_update$ language plpgsql;

CREATE OR REPLACE FUNCTION PROV_PROVEEDORES_auditoria_delete_func() RETURNS TRIGGER
AS $PROV_PROVEEDORES_auditoria_delete$
BEGIN
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
	RETURN NEW;
END;
$PROV_PROVEEDORES_auditoria_delete$ language plpgsql;

/*------------------------------------------
Registro en auditoria nuevo proveedor
--------------------------------------------*/
CREATE TRIGGER PROV_PROVEEDORES_auditoria_insert
after insert on PROV_PROVEEDORES
for each row EXECUTE PROCEDURE PROV_PROVEEDORES_auditoria_insert_func();
/*------------------------------------------
Registro en auditoria actualizacion de proveedor
--------------------------------------------*/
CREATE TRIGGER PROV_PROVEEDORES_auditoria_update
after update on PROV_PROVEEDORES
for each row EXECUTE PROCEDURE PROV_PROVEEDORES_auditoria_update_func();

/*------------------------------------------
Registro en auditoria eliminacion de proveedor
--------------------------------------------*/
CREATE TRIGGER PROV_PROVEEDORES_auditoria_delete
before delete on PROV_PROVEEDORES
for each row EXECUTE PROCEDURE PROV_PROVEEDORES_auditoria_delete_func();

INSERT INTO AUDI_LOG (LOG_ORIGEN, LOG_NIVEL, LOG_MENSAJE) VALUES ('Instalación', 40, 'Fin Modulo Proveedores');
