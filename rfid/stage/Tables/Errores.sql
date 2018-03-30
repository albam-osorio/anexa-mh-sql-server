CREATE TABLE [stage].[Errores] (
    [idError]       BIGINT         IDENTITY (1, 1) NOT NULL,
    [id]            BIGINT         NOT NULL,
    [integracion]   VARCHAR (50)   NOT NULL,
    [externalId]    VARCHAR (50)   NOT NULL,
    [codigo]        VARCHAR (50)   NOT NULL,
    [mensaje]       VARCHAR (1024) NOT NULL,
    [fechaCreacion] DATETIME       NOT NULL,
    CONSTRAINT [PK_Errores] PRIMARY KEY CLUSTERED ([idError] ASC)
);

