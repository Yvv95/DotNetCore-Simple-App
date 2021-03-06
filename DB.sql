USE [ExchRates]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetCurses]    Script Date: 07/12/2017 19:10:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetCurses]
AS
    SELECT * FROM [ExchRates].[dbo].[ValuteCursDynamic]
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertEnum]    Script Date: 07/12/2017 19:10:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsertEnum]
    @Vcode varchar(10),
    @Vname char(150),
@VEngname varchar(50),
@Vnom varchar(5),
@VcommonCode varchar(10),
@VnumCode varchar(50),
@VcharCode varchar(50)
AS
    INSERT INTO [ExchRates].[dbo].[EnumValutes] (Vcode, Vname, VEngname, Vnom, VcommonCode, VnumCode, VcharCode )
    VALUES (@Vcode, @Vname, @VEngname, @Vnom, @VcommonCode, @VnumCode, @VcharCode)
  
    SELECT SCOPE_IDENTITY()
GO
/****** Object:  Table [dbo].[EnumValutes]    Script Date: 07/12/2017 19:10:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EnumValutes](
	[Vcode] [varchar](7) NOT NULL,
	[Vname] [varchar](100) NOT NULL,
	[VEngname] [varchar](100) NULL,
	[Vnom] [smallint] NULL,
	[VcommonCode] [varchar](10) NULL,
	[VnumCode] [smallint] NULL,
	[VcharCode] [varchar](50) NULL,
	[VId] [int] IDENTITY(1,1) NOT NULL,
	[VImage] [image] NULL,
 CONSTRAINT [PK_EnumValutes] PRIMARY KEY CLUSTERED 
(
	[VId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ValuteCursDynamic]    Script Date: 07/12/2017 19:10:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ValuteCursDynamic](
	[CursDate] [datetime] NULL,
	[Vcurs] [money] NULL,
	[VId] [int] NOT NULL,
 CONSTRAINT [IX_ValuteCursDynamic_1] UNIQUE NONCLUSTERED 
(
	[VId] ASC,
	[CursDate] DESC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertCurs]    Script Date: 07/12/2017 19:10:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InsertCurs]
    (@id integer,
    @curs money,
@date datetime)
AS
    INSERT INTO [ExchRates].[dbo].[ValuteCursDynamic] (VId, CursDate, Vcurs)
    VALUES (@id, @date, @curs)
  
    SELECT SCOPE_IDENTITY()
GO
/****** Object:  StoredProcedure [dbo].[sp_CheckDates]    Script Date: 07/12/2017 19:10:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CheckDates]
    @id smallint,
    @dateFrom DateTime out,
    @dateTo DateTime out
AS
    SELECT *  FROM [ExchRates].[dbo].[ValuteCursDynamic] WHERE 
DATEDIFF (day, [CursDate],@dateFrom)<=0 and DATEDIFF(day, @dateTo,[CursDate])<=0 and [VId]=@id
GO
/****** Object:  StoredProcedure [dbo].[sp_CheckName]    Script Date: 07/12/2017 19:10:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_CheckName]
    @code varchar(100)  
 AS SELECT [VId]
    FROM [ExchRates].[dbo].[EnumValutes]
where [dbo].[EnumValutes].[Vcode]=@code
GO
/****** Object:  StoredProcedure [dbo].[sp_GetId]    Script Date: 07/12/2017 19:10:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SELECT [Vcode]
--      ,[Vname]
--      ,[VEngname]
--      ,[Vnom]
--      ,[VcommonCode]
--      ,[VnumCode]
--      ,[VcharCode]
--  FROM [ExchRates].[dbo].[EnumValutes]
CREATE PROC [dbo].[sp_GetId] @name varchar(100), @id smallint out
AS
SELECT @id=min([ExchRates].[dbo].[EnumValutes].[VId]) FROM [ExchRates].[dbo].[EnumValutes]
WHERE [ExchRates].[dbo].[EnumValutes].[Vname] = @name
GO
/****** Object:  ForeignKey [Index_relation]    Script Date: 07/12/2017 19:10:38 ******/
ALTER TABLE [dbo].[ValuteCursDynamic]  WITH CHECK ADD  CONSTRAINT [Index_relation] FOREIGN KEY([VId])
REFERENCES [dbo].[EnumValutes] ([VId])
GO
ALTER TABLE [dbo].[ValuteCursDynamic] CHECK CONSTRAINT [Index_relation]
GO
