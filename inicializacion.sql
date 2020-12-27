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

