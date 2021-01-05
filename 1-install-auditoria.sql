DROP TABLE IF EXISTS AUDI_AUDITORIA;
DROP TABLE IF EXISTS AUDI_LOG;

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
