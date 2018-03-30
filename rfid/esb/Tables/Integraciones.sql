CREATE TABLE [esb].[Integraciones] (
    [id_integracion]    INT           IDENTITY (1, 1) NOT NULL,
    [codigo]            VARCHAR (50)  NOT NULL,
    [nombre]            VARCHAR (100) NOT NULL,
    [descripcion]       VARCHAR (200) NOT NULL,
    [fecha_ultimo_pull] DATETIME      NOT NULL,
    [batch_size]        INT           NOT NULL,
    CONSTRAINT [PK_Integraciones] PRIMARY KEY CLUSTERED ([id_integracion] ASC),
    CONSTRAINT [UK_Integraciones_01] UNIQUE NONCLUSTERED ([codigo] ASC)
);

