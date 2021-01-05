DROP TABLE IF EXISTS STOC_ARTICULOS;

INSERT INTO AUDI_LOG (LOG_ORIGEN, LOG_NIVEL, LOG_MENSAJE) VALUES ('Instalación', 40, 'Instalación Modulo Stoc Parte 1');
/************************************************************************************************************************************************
MODULO STOCK (1/2)
*************************************************************************************************************************************************/
/************************************************************************************************************************************************
MAESTRO DE ARTICULOS
*************************************************************************************************************************************************/
/*
Maestro de articulos
*/
CREATE TABLE IF NOT EXISTS STOC_ARTICULOS (
ARTS_ARTICULO	serial	primary key,
ARTS_NOMBRE varchar(45) not null,
CANTIDAD_MINIMA	decimal not null default 0,
ARTS_NOTAS	text,
ARTS_BAJA	boolean not null default false
);

comment on table STOC_ARTICULOS is 'Maestro de articulos';
comment on column STOC_ARTICULOS.ARTS_ARTICULO is 'Clave principal que identifica a un articulo';
comment on column STOC_ARTICULOS.ARTS_NOMBRE is 'Nombre del articulo, se recomienda <nombre> <formato> <unidad medida>';
comment on column STOC_ARTICULOS.CANTIDAD_MINIMA is 'Indica la cantidad minima que debe haber en el stock antes de emitir una notificacion';
comment on column STOC_ARTICULOS.ARTS_NOTAS is 'Notas, comentarios y observaciones sobre el articulo';
comment on column STOC_ARTICULOS.ARTS_BAJA is 'Indica si el articulo esta dado de baja [true] o no [false]';

CREATE OR REPLACE FUNCTION STOC_ARTICULOS_auditoria_insert_func() RETURNS TRIGGER
AS $STOC_ARTICULOS_auditoria_insert$
BEGIN
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
	RETURN NEW;
END;
$STOC_ARTICULOS_auditoria_insert$ language plpgsql;

CREATE OR REPLACE FUNCTION STOC_ARTICULOS_auditoria_update_func() RETURNS TRIGGER
AS $STOC_ARTICULOS_auditoria_update$
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
		'STOC',
		'ARTS',
		'Modificación de artículo',
		new.ARTS_ARTICULO,
		current_user
	);
	RETURN NEW;
END;
$STOC_ARTICULOS_auditoria_update$ language plpgsql;

CREATE OR REPLACE FUNCTION STOC_ARTICULOS_auditoria_delete_func() RETURNS TRIGGER
AS $STOC_ARTICULOS_auditoria_delete$
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
		'STOC',
		'ARTS',
		'Eliminación de artículo',
		OLD.ARTS_ARTICULO,
		current_user
	);
	RETURN NEW;
END;
$STOC_ARTICULOS_auditoria_delete$ language plpgsql;

/*------------------------------------------
Registro en auditoria nuevo articulo
--------------------------------------------*/
CREATE TRIGGER STOC_ARTICULOS_auditoria_insert
after insert on STOC_ARTICULOS
for each row EXECUTE PROCEDURE STOC_ARTICULOS_auditoria_insert_func();

/*------------------------------------------
Registro en auditoria actualizacion de articulo
--------------------------------------------*/
CREATE TRIGGER STOC_ARTICULOS_auditoria_update
after update on STOC_ARTICULOS
for each row EXECUTE PROCEDURE STOC_ARTICULOS_auditoria_update_func();

/*------------------------------------------
Registro en auditoria eliminacion de articulo
--------------------------------------------*/
CREATE TRIGGER STOC_ARTICULOS_auditoria_delete
before delete on STOC_ARTICULOS
for each row EXECUTE PROCEDURE STOC_ARTICULOS_auditoria_delete_func();
		
INSERT INTO AUDI_LOG (LOG_ORIGEN, LOG_NIVEL, LOG_MENSAJE) VALUES ('Instalación', 40, 'Fin Modulo Stoc Parte 1');
