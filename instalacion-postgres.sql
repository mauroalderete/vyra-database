--DROP DATABASE IF EXISTS dbvyra;

--CREATE DATABASE IF NOT EXISTS dbvyra
--	CHARACTER SET 'UTF8MB4'
--    COLLATE 'utf8mb4_spanish2_ci';

--USE dbvyra;

DO $$
DECLARE
	reinstall boolean := true;
BEGIN
	IF reinstall THEN
		DROP TABLE IF EXISTS AUDI_AUDITORIA;
		DROP TABLE IF EXISTS AUDI_LOG;
		DROP TABLE IF EXISTS PROV_PROVEEDORES;
	END IF;
END $$;

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

INSERT INTO AUDI_LOG (LOG_ORIGEN, LOG_NIVEL, LOG_MENSAJE) VALUES ('Instalación', 40, 'Inicio de la instalación de dbVyra');

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
		DROP TRIGGER IF EXISTS PROV_PROVEEDORES_auditoria_insert ON PROV_PROVEEDORES;
		CREATE TRIGGER PROV_PROVEEDORES_auditoria_insert
		after insert on PROV_PROVEEDORES
		for each row EXECUTE PROCEDURE PROV_PROVEEDORES_auditoria_insert_func();
		/*------------------------------------------
		Registro en auditoria actualizacion de proveedor
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS PROV_PROVEEDORES_auditoria_update ON PROV_PROVEEDORES;
		CREATE TRIGGER PROV_PROVEEDORES_auditoria_update
		after update on PROV_PROVEEDORES
		for each row EXECUTE PROCEDURE PROV_PROVEEDORES_auditoria_update_func();
		
		/*------------------------------------------
		Registro en auditoria eliminacion de proveedor
		--------------------------------------------*/
		DROP TRIGGER IF EXISTS PROV_PROVEEDORES_auditoria_delete ON PROV_PROVEEDORES;
		CREATE TRIGGER PROV_PROVEEDORES_auditoria_delete
		before delete on PROV_PROVEEDORES
		for each row EXECUTE PROCEDURE PROV_PROVEEDORES_auditoria_delete_func();
		

INSERT INTO AUDI_LOG (LOG_ORIGEN, LOG_NIVEL, LOG_MENSAJE) VALUES ('Instalación', 40, 'Finalización de la instalación de dbVyra');