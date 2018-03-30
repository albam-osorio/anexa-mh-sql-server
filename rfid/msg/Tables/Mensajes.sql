CREATE TABLE [msg].[Mensajes] (
    [mid]                BIGINT        IDENTITY (1, 1) NOT NULL,
    [integracion]        VARCHAR (50)  NOT NULL,
    [externalId]         VARCHAR (50)  NOT NULL,
    [id]                 VARCHAR (50)  NOT NULL,
    [operacion]          VARCHAR (1)   NOT NULL,
    [estado]             VARCHAR (50)  NOT NULL,
    [intentos]           INT           NOT NULL,
    [fechaUltimoIntento] DATETIME      NULL,
    [datos]              VARCHAR (MAX) NOT NULL,
    [fechaCreacion]      DATETIME      NOT NULL,
    [fechaModificacion]  DATETIME      NOT NULL,
    CONSTRAINT [PK_Mensajes] PRIMARY KEY CLUSTERED ([mid] ASC)
);

