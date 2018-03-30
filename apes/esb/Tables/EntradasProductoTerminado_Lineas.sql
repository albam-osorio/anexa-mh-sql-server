CREATE TABLE [esb].[EntradasProductoTerminado_Lineas] (
    [externalId] VARCHAR (50) NOT NULL,
    [sku]        VARCHAR (13) NOT NULL,
    [amount]     INT          NOT NULL,
    CONSTRAINT [PK_EntradasProductoTerminado_Lineas] PRIMARY KEY CLUSTERED ([externalId] ASC, [sku] ASC),
    CONSTRAINT [FK_EntradasProductoTerminado_Lineas_EntradasProductoTerminado] FOREIGN KEY ([externalId]) REFERENCES [esb].[EntradasProductoTerminado] ([externalId])
);

