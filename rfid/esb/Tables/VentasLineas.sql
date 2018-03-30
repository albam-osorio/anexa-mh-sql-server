CREATE TABLE [esb].[VentasLineas] (
    [externalId] VARCHAR (50) NOT NULL,
    [barCode]    VARCHAR (13) NOT NULL,
    [quantity]   INT          NOT NULL,
    CONSTRAINT [PK_Ventas_Lineas] PRIMARY KEY CLUSTERED ([externalId] ASC, [barCode] ASC),
    CONSTRAINT [FK_Ventas_Lineas_Ventas] FOREIGN KEY ([externalId]) REFERENCES [esb].[Ventas] ([externalId])
);

