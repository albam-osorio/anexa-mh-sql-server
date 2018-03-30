﻿CREATE TABLE [msg].[Productos] (
    [mid]               BIGINT         IDENTITY (1, 1) NOT NULL,
    [tipo_cambio]       VARCHAR (50)   NOT NULL,
    [estado_cambio]     VARCHAR (50)   NOT NULL,
    [intentos]          INT            NOT NULL,
    [fecha_ultimo_pull] DATETIME       NOT NULL,
    [fecha_ultimo_push] DATETIME       NULL,
    [sync_codigo]       INT            NOT NULL,
    [sync_mensaje]      VARCHAR (1024) NOT NULL,
    [sync_exception]    VARCHAR (256)  NOT NULL,
    [externalId]        VARCHAR (13)   NOT NULL,
    [id]                VARCHAR (50)   NOT NULL,
    [companyPrefix]     VARCHAR (7)    NOT NULL,
    [name]              VARCHAR (50)   NOT NULL,
    [reference]         VARCHAR (6)    NOT NULL,
    [ean]               VARCHAR (25)   NOT NULL,
    [color]             VARCHAR (50)   NOT NULL,
    [codigoColor]       VARCHAR (50)   NOT NULL,
    [talla]             VARCHAR (50)   NOT NULL,
    [tipoProducto]      VARCHAR (50)   NOT NULL,
    [coleccion]         VARCHAR (50)   NOT NULL,
    [grupoProducto]     VARCHAR (50)   NOT NULL,
    [subGrupoProducto]  VARCHAR (50)   NOT NULL,
    [fabricante]        VARCHAR (50)   NOT NULL,
    [temporada]         VARCHAR (50)   NOT NULL,
    [referencia]        VARCHAR (50)   NOT NULL,
    [modelo]            VARCHAR (50)   NOT NULL,
    [genero]            VARCHAR (50)   NOT NULL,
    CONSTRAINT [PK_Productos] PRIMARY KEY CLUSTERED ([mid] ASC)
);
