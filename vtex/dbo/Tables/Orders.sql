CREATE TABLE [dbo].[Orders] (
    [id]                BIGINT        IDENTITY (1, 1) NOT NULL,
    [estado]            VARCHAR (50)  NOT NULL,
    [sourceId]          VARCHAR (20)  NOT NULL,
    [targetId]          VARCHAR (20)  NOT NULL,
    [orderId]           VARCHAR (20)  NOT NULL,
    [status]            VARCHAR (20)  NOT NULL,
    [statusDescription] VARCHAR (80)  NOT NULL,
    [value]             INT           NOT NULL,
    [creationDate]      VARCHAR (50)  NOT NULL,
    [lastChange]        VARCHAR (50)  NOT NULL,
    [total]             INT           NOT NULL,
    [discounts]         INT           NOT NULL,
    [shipping]          INT           NOT NULL,
    [tax]               INT           NOT NULL,
    [firstName]         VARCHAR (20)  NOT NULL,
    [lastName]          VARCHAR (20)  NOT NULL,
    [documentType]      VARCHAR (20)  NOT NULL,
    [document]          VARCHAR (20)  NOT NULL,
    [phone]             VARCHAR (20)  NOT NULL,
    [city]              VARCHAR (20)  NOT NULL,
    [state]             VARCHAR (20)  NOT NULL,
    [country]           VARCHAR (20)  NOT NULL,
    [street]            VARCHAR (100) NOT NULL,
    [neighborhood]      VARCHAR (100) NOT NULL,
    [complement]        VARCHAR (100) NOT NULL,
    [reference]         VARCHAR (100) NOT NULL,
    [deliveryCompany]   VARCHAR (90)  NOT NULL,
    [receiverName]      VARCHAR (90)  NOT NULL,
    [trackingNumber]    VARCHAR (50)  NOT NULL,
    [version]           INT           NOT NULL,
    [fechaCreacion]     DATETIME      NOT NULL,
    [fechaModificacion] DATETIME      NOT NULL,
    CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [UK_Orders_SourceId] UNIQUE NONCLUSTERED ([orderId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Orders_TargetId]
    ON [dbo].[Orders]([targetId] ASC);

