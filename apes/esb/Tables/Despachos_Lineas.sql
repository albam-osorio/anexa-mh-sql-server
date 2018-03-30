CREATE TABLE [esb].[Despachos_Lineas] (
    [externalId]           VARCHAR (50) NOT NULL,
    [sku]                  VARCHAR (13) NOT NULL,
    [amount]               INT          NOT NULL,
    [expectedShipmentDate] VARCHAR (10) NOT NULL,
    CONSTRAINT [PK_Despachos_Lineas] PRIMARY KEY CLUSTERED ([externalId] ASC, [sku] ASC, [expectedShipmentDate] ASC),
    CONSTRAINT [FK_Despachos_Lineas_Despachos] FOREIGN KEY ([externalId]) REFERENCES [esb].[Despachos] ([externalId])
);

