USE dbvyra;

INSERT INTO `dbvyra`.`clie_clientes`
(
`CLIE_NOMBRE`,
`CLIE_CONTACTO`,
`CLIE_TELEFONO`,
`CLIE_WHATSAPP`,
`CLIE_EMAIL`,
`CLIE_DIRECCION`,
`CLIE_NOTAS`)
VALUES
(
'Sin identificar',
null,
null,
null,
null,
null,
'Cliente para usar cuando no se individualiza al comprador');

INSERT INTO `dbvyra`.`prov_proveedores`
(
`PROV_NOMBRE`,
`PROV_CONTACTO`,
`PROV_TELEFONO`,
`PROV_WHATSAPP`,
`PROV_EMAIL`,
`PROV_DIRECCION`,
`PROV_PROVINCIA`,
`PROV_NOTAS`)
VALUES
(
'Sin identificar',
null,
null,
null,
null,
null,
null,
'Proveedor a usar cuando no es posible identificarlo');

INSERT INTO `dbvyra`.`comp_comprobantes_tipos`
(`CCTP_TIPO`,
`CCTP_NOMBRE`,
`CCTP_NOTAS`)
VALUES
('INI',
'Ingresos iniciales',
'Se usa para registrar los ingresos de los articulos al inicio de la actividad. Muchas veces el origen de estos articulos es desconocido, o no se refleja como un movimiento en la caja. Se recomienda dar de baja una vez que se haya configurado el inicio de la empresa');

INSERT INTO `dbvyra`.`vent_comprobantes_tipos`
(`CVTP_TIPO`,
`CVTP_NOMBRE`,
`CVTP_NOTAS`)
VALUES
('INI',
'Egresos iniciales',
'Se usa para registrar los egresos de articulos previos al inicio de la actividad. Muchas veces el origen o destino de los articulos es desconocido, pero se reflejan en el estado inicial de la empresa. Se recomienda dar de baja una vez que se haya configurado el inicio de la empresa');
