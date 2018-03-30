CREATE TABLE [dbo].[OrdersItems] (
    [id]            BIGINT       NOT NULL,
    [numeroItem]    INT          NOT NULL,
    [orderId]       VARCHAR (20) NOT NULL,
    [itemId]        INT          NOT NULL,
    [productId]     VARCHAR (25) NOT NULL,
    [productName]   VARCHAR (80) NOT NULL,
    [ean]           VARCHAR (25) NOT NULL,
    [refId]         VARCHAR (25) NOT NULL,
    [quantity]      INT          NOT NULL,
    [price]         INT          NOT NULL,
    [commision]     INT          NOT NULL,
    [tax]           INT          NOT NULL,
    [shippingPrice] INT          NOT NULL,
    CONSTRAINT [PK_OrdersItems] PRIMARY KEY CLUSTERED ([id] ASC, [numeroItem] ASC),
    CONSTRAINT [FK_OrdersItems_Orders] FOREIGN KEY ([id]) REFERENCES [dbo].[Orders] ([id]),
    CONSTRAINT [UK_OrdersItems] UNIQUE NONCLUSTERED ([orderId] ASC, [itemId] ASC)
);

