# Vyra Database

Base de datos principal del proyecto Vyra

## Descripción

El proyecto contiene los scripts y recuersos necesarios para construir una instancia de la base de datos del proyecto Vyra elaborada para servidores mysql.

Vyra Database modela un sistema de contabilidad, ventas, compras y control de inventario minimo para poder gestionar pequeños negocios.

El objetivo es brindar herramientas de inteligencia de negocios para la elaboración de estrategias y analisis de decisiones a traves del registro de los acontecimientos comerciales en series de tiempo.

## Modelo

La base de datos modelara las operaciones basicas de un negocio en modulos diferenciados por las carateristicas principales de sectorizacion de una organización empresarial pequeña.

Los modelos se agruparan por modulos:

- Módulo Proveedores: Contiene informacion de las entidades relacionadas con las cuentas a pagar. Esto incluye a terceros identificados o desconocidos.
- Módulo Compras: Registra los eventos de operaciones enmarcadas en cuentas a pagar. Pagos de productos, mercaderias, servicios y toda entidad adquirible por medio de una compra.
- Módulo Ventas: Registra los eventos ocurridos tras una operacion de ventas o que pueden traducirse como ventas: Facturación, cotización, descuentos, listas de precios.
- Módulo Stock: Regsitra los movimientos del stock de mercaderias. Los movimientos son producidos por compras, ventas, fallas u otras causas.
- Modulo Clientes: Almacena datos de las entidades de clientes, contacto, domicilios, acontecimientos.

## CHANGELOG

### 20202612 - 1630

Inicializacion de Vyra Database