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
/*------------------------------------------
Registro en auditoria nuevo tipo de comprobante de ingreso
--------------------------------------------*/
DROP TRIGGER IF EXISTS COMP_COMPROBANTES_TIPOS_auditoria_insert;
CREATE TRIGGER COMP_COMPROBANTES_TIPOS_auditoria_insert
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
DROP TRIGGER IF EXISTS COMP_COMPROBANTES_TIPOS_auditoria_update;
CREATE TRIGGER COMP_COMPROBANTES_TIPOS_auditoria_update
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
DROP TRIGGER IF EXISTS COMP_COMPROBANTES_TIPOS_auditoria_delete;
CREATE TRIGGER COMP_COMPROBANTES_TIPOS_auditoria_delete
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
