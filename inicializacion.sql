USE dbvyra;

INSERT INTO AUDI_LOG (LOG_ORIGEN, LOG_NIVEL, LOG_MENSAJE) VALUES ('Instalación', 40, 'Inicio de configuración inicial');

INSERT INTO CLIE_CLIENTES
(
CLIE_NOMBRE,
CLIE_CONTACTO,
CLIE_TELEFONO,
CLIE_WHATSAPP,
CLIE_EMAIL,
CLIE_DIRECCION,
CLIE_NOTAS)
VALUES
(
'Sin identificar',
null,
null,
null,
null,
null,
'Cliente para usar cuando no se individualiza al comprador');

INSERT INTO PROV_PROVEEDORES
(
PROV_NOMBRE,
PROV_CONTACTO,
PROV_TELEFONO,
PROV_WHATSAPP,
PROV_EMAIL,
PROV_DIRECCION,
PROV_PROVINCIA,
PROV_NOTAS)
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

INSERT INTO COMP_COMPROBANTES_TIPOS
(CCTP_TIPO,
CCTP_NOMBRE,
CCTP_NOTAS)
VALUES
('INI',
'Ingresos iniciales',
'Se usa para registrar los ingresos de los articulos al inicio de la actividad. Muchas veces el origen de estos articulos es desconocido, o no se refleja como un movimiento en la caja. Se recomienda dar de baja una vez que se haya configurado el inicio de la empresa');

INSERT INTO VENT_COMPROBANTES_TIPOS
(CVTP_TIPO,
CVTP_NOMBRE,
CVTP_NOTAS)
VALUES
('INI',
'Egresos iniciales',
'Se usa para registrar los egresos de articulos previos al inicio de la actividad. Muchas veces el origen o destino de los articulos es desconocido, pero se reflejan en el estado inicial de la empresa. Se recomienda dar de baja una vez que se haya configurado el inicio de la empresa');

INSERT INTO AUDI_LOG (LOG_ORIGEN, LOG_NIVEL, LOG_MENSAJE) VALUES ('Instalación', 40, 'Fin de configuración inicial');