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
