-- =====================================================
-- CONSOLIDATED SQL QUERY TEMPLATES
-- =====================================================
-- Description: This file contains all SQL query templates 
-- collected from various SQL files in the project
-- =====================================================

-- =====================================================
-- 1. MERGE OPERATIONS
-- =====================================================

-- 1.1. MERGE INTO PreferredDealer
-- File: IMS10010502.sql
MERGE INTO PreferredDealer AS TARGET
USING (
    SELECT
        'InternalUserId' AS InternalUserId, 
        'Vin' AS Vin,
        'PreferredDealerType' AS PreferredDealerType,
        'salesCode' AS salesCode,
        'StoreCode' AS StoreCode,
        'RecordCreateDateTime' AS RecordCreateDateTime,
        'RecordUpdateDateTime' AS RecordUpdateDateTime
) AS SOURCE
ON (
    TARGET.InternalUserId = '1000' AND
    TARGET.Vin = 'JM0ABCDEF8A000001' AND
    TARGET.PreferredDealerType = 'SALES'
)
WHEN MATCHED AND (CASE WHEN TARGET.RecordUpdateDateTime IS NOT NULL THEN TARGET.RecordUpdateDateTime
    ELSE TARGET.RecordCreateDateTime
    END) < SYSDATETIME() THEN
    UPDATE SET
        TARGET.SalesCode = 'XXXX',
        TARGET.StoreCode = 'XXXXXXXXAAAA',
        TARGET.RecordUpdateDateTime = SYSDATETIME()
WHEN NOT MATCHED THEN
    INSERT (
        InternalUserId, Vin, SalesCode, StoreCode,
        RecordCreateDateTime, RecordUpdateDateTime,
        Company, PreferredDealerType
    ) VALUES (
        '11111', 'JM0ABCDEF8A000001', 'ABC', 'DEF',
        SYSDATETIME(), SYSDATETIME(), 'MA', 'SALES'
    );

-- 1.2. MERGE INTO AddressDataMaster
-- File: No3.sql
MERGE INTO AddressDataMaster AS TARGET
USING (
    SELECT 
        'CountryCode' AS CountryCode,
        'postCode' AS PostCode,
        'street' AS Street,
        'suburb' AS Suburb,
        'RecordCreatedAt' AS RecordCreatedAt,
        'RecordUpdatedAt' AS RecordUpdatedAt
) AS SOURCE
ON (
    TARGET.CountryCode = 'AU'
    AND TARGET.PostCode = SOURCE.PostCode
    AND TARGET.Street = SOURCE.Street
    AND TARGET.Suburb = SOURCE.Suburb
)
WHEN MATCHED AND ((
    CASE 
        WHEN TARGET.RecordUpdatedAt IS NOT NULL 
        THEN TARGET.RecordUpdatedAt
        ELSE TARGET.RecordCreatedAt
    END
) < CONVERT(DATETIME, STUFF(STUFF(STUFF('20220321', 9, 0, ' '), 12, 0, ':'), 15, 0, ':')))
THEN
    UPDATE SET
        TARGET.RecordCreatedAt = SYSDATETIME()
WHEN NOT MATCHED THEN
    INSERT (
        CountryCode, PostCode, Street, Suburb, State,
        RecordCreatedAt, RecordUpdatedAt
    ) VALUES (
        'AU', '31701', '211A Wellington Rd', 'MULGRAVE', 'VIC',
        SYSDATETIME(), SYSDATETIME()
    );

-- 1.3. MERGE INTO IMEIInfoHistoryTable
-- File: #10155-#10104.sql
MERGE INTO IMEIInfoHistoryTable AS TARGET
USING (
    SELECT
        Vin AS Vin,
        Imei AS Imei,
        Company AS Company
    FROM IMEIIntegrationDataTargetTable
) AS SOURCE
ON(
    TARGET.Vin = SOURCE.Vin AND
    TARGET.Imei = SOURCE.Imei AND
    TARGET.Company = SOURCE.Company
)
WHEN MATCHED THEN
    UPDATE SET
        TARGET.LinkageFlag = 1,
        TARGET.RecordUpdatedAt = SYSDATETIME();

-- 1.4. MERGE INTO VehicleSpecificationMaster
-- File: 10113.sql
MERGE INTO VehicleSpecificationMaster AS TARGET
USING (
    SELECT Vin AS Vin
    FROM VehicleMaster,
    (
        SELECT
            MAX(FinalLineOffShift) AS CUR
        From VehicleMaster
        WHERE CarCode = '888'
        AND   FinalLineOffShift <= '888'
    ) AS CURRENTLINE
    WHERE 
        FinalLineOffShift = CURRENTLINE.CUR
    AND CarCode = '888'
) AS SOURCE
ON(
    TARGET.Vin = SOURCE.Vin
)
WHEN MATCHED THEN
    UPDATE SET
        TARGET.ModelCode = 'MODELCODE',
        TARGET.ModelName = 'MODELNAME',
        TARGET.TransmissionType = 'TRANSMISSIONTYPE',
        TARGET.TransmissionName = 'TRANSMISSIONNAME',
        TARGET.TrimName = 'TRIMNAME',
        TARGET.ModelYear = '2030',
        TARGET.EngineCode = 'ENGINECODE',
        TARGET.EngineInformation = 'ENGINEINFOMATION',
        TARGET.GradeCode = 'GRADECODE',
        TARGET.GradeName = 'GRADENAME',
        TARGET.InteriorColorCode = 'INTERIOR_COLORCODE',
        TARGET.InteriorColorName = 'INTERIOR_COLORNAME',
        TARGET.ExteriorColorCode = 'EXTERIOR_COLORCODE',
        TARGET.ExteriorColorName = 'EXTERIOR_COLORNAME',
        TARGET.CarlineCode = 'CARLINECODE',
        TARGET.CarlineName = 'CARLINENAME',
        TARGET.ImagePath = 'IMAGEPATH',
        TARGET.RecordUpdatedAt = SYSDATETIME()
WHEN NOT MATCHED THEN
    INSERT (
        Vin, Locale, ModelCode, ModelName, TransmissionName,
        TransmissionType, TrimName, ModelYear, EngineCode,
        EngineInformation, GradeCode, GradeName, InteriorColorCode,
        InteriorColorName, ExteriorColorCode, ExteriorColorName,
        CarlineCode, CarlineName, ImagePath, RecordCreatedAt,
        RecordUpdatedAt
    ) VALUES (
        SOURCE.Vin, 'jp_JP', '3333', 'MODELNAME_1', 'TRANSMISSIONNAME',
        'TRANSMISSIONTYPE', 'TRIMNAME', '2023', 'ENGINECODE',
        'ENGINEINFOMATION', 'GRADECODE', 'GRADECODE', 'INTERIOR_COLORCODE',
        'INTERIOR_COLORNAME', 'EXTERIOR_COLORCODE', 'EXTERIOR_COLORNAME',
        'CARLINECODE', 'CARLINENAME', 'IMAGEPATH',
        SYSDATETIME(), SYSDATETIME()
    );

-- =====================================================
-- 2. COMPLEX SELECT WITH CTE
-- =====================================================

-- 2.1. Vehicle Master with CTE
-- File: 10256_Base.sql
DECLARE @COUNTRY_NUMBER AS [varchar] = '4'
DECLARE @COMPANY AS [varchar] = 'MA'
DECLARE @vehicleTypeMode AS [varchar] = '0'
DECLARE @vehicleTypeCondition AS [varchar] = ' '

;WITH union1 AS 
(
    SELECT 
        RANK() OVER(PARTITION BY VM.Vin ORDER BY CV.InternalVin DESC) rank_,
        VM.Vin, 
        CASE 
            WHEN VM.RecallPermitFlag is null THEN 0 
            ELSE CASE 
                     WHEN CV.SimStatus != 21 THEN VM.RecallPermitFlag
                     ELSE 0
                 END
        END AS RecallPermitFlag, 
        CASE WHEN PD.SalesCode is null THEN '' ELSE PD.SalesCode END AS SalesCode, 
        CASE WHEN PD.StoreCode is null THEN '' ELSE PD.StoreCode END AS StoreCode, 
        CASE WHEN PD.RecordCreateDateTime is null THEN '' 
            ELSE FORMAT(PD.RecordCreateDateTime, 'yyyy-MM-ddTHH:mm:ssZ') END AS RecordCreateDateTime, 
        CASE WHEN SCM.StoreName is null THEN '' ELSE SCM.StoreName END AS SalesName, 
        CASE WHEN SM.StoreName is null THEN '' ELSE SM.StoreName END AS StoreName, 
        CASE WHEN VM.SaleCountry is null THEN '' ELSE VM.SaleCountry END AS SaleCountry
    FROM VehicleMaster AS VM 
    INNER JOIN CvVehicle AS CV 
        ON VM.vin = CV.BlankVin AND (CV.StartDateTime is not null AND CV.EndDateTime is null)
    LEFT OUTER JOIN PreferredDealer AS PD 
        ON CV.PrimaryUserId = PD.InternalUserId AND CV.BlankVin = PD.Vin
    LEFT OUTER JOIN SalesCompanyMaster AS SCM 
        ON PD.SalesCode = SCM.SalesCode AND SCM.Company = @COMPANY
    LEFT OUTER JOIN ShopMaster AS SM 
        ON PD.SalesCode = SM.SalesCode AND PD.StoreCode = SM.StoreCode AND SM.Company = @COMPANY
),
ccm AS (
    SELECT
    DISTINCT
        Vin
    FROM
        CrmContractMaster
    WHERE
        RecordDeleteAt is null
),
vmnew AS (
    SELECT vmm.Vin,RecallPermitFlag,
        CASE WHEN ccm.Vin is null then 0 else 1 end AS PhoneNotificationFlag,
        SalesCode,StoreCode,RecordCreateDateTime,SalesName,StoreName,SaleCountry
    FROM vmm
    LEFT OUTER JOIN ccm
    ON vmm.Vin = ccm.Vin
)
SELECT Vin,RecallPermitFlag,PhoneNotificationFlag,SalesCode,StoreCode,RecordCreateDateTime,SalesName,StoreName
FROM vmnew
WHERE SaleCountry = @COUNTRY_NUMBER;

-- =====================================================
-- 3. TABLE CREATION
-- =====================================================

-- 3.1. Journal Tables Creation
-- File: Script-5.sql, Script-6.sql, Script-7.sql, Script-9.sql
DROP TABLE IF EXISTS [dbo].[JnlLog]
DROP TABLE IF EXISTS [dbo].[JnlRequest]
DROP TABLE IF EXISTS [dbo].[JnlFile]
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[JnlLog] (
  [LogId] BIGINT NOT NULL IDENTITY(1,1),
  [FileId] BIGINT NOT NULL,
  [FileRecordNo] INT NOT NULL,
  [RequestId] BIGINT NOT NULL,
  [OutputDateTime] [datetime2](7) NOT NULL,
  [LogCategory] VARCHAR(2) NOT NULL,
  [OutputId] VARCHAR(3) NOT NULL,
  [BodyPointer] BIGINT NOT NULL,
  [BodySize] INT NOT NULL,
  [RecordCreateDateTime] [datetime2](7) NOT NULL,
  CONSTRAINT [JnlLog_PKC] PRIMARY KEY CLUSTERED
  (
  	[LogId] ASC
  )
);

CREATE TABLE [dbo].[JnlRequest] (
  [RequestId] BIGINT not null IDENTITY(1,1),
  [ApiId] VARCHAR(10) NOT NULL,
  [TransactionId] VARCHAR(40) NOT NULL,
  [SequenceNo] BIGINT,
  [InnerVin] INT,
  [InnerUserId] INT,
  [RecordCreateDateTime] DATETIME NOT NULL,
  [RecordUpdateDateTime] DATETIME NOT NULL,
  [GetRequestDateTime] [datetime2](7),
  [OutputRequestDateTime] [datetime2](7),
  [RequestStatus] TINYINT NOT NULL,
  CONSTRAINT [JnlRequest_PKC] PRIMARY KEY CLUSTERED
  (
	[RequestId] ASC
  )
);

CREATE TABLE [dbo].[JnlFile] (
  [FileId] BIGINT not null IDENTITY(1,1),
  [FilePath] VARCHAR(256) NOT NULL,
  [FileRecords] INT NOT NULL,
  [FileUpdateDateTime] [datetime2](7) NOT NULL,
  [RecordCreateDateTime] [datetime2](7) NOT NULL,
  CONSTRAINT [JnlFile_PKC] PRIMARY KEY CLUSTERED
  (
	[FileId] ASC
  )
);

-- 3.2. Compare Result Report Tables
-- File: Script-9.sql
CREATE TABLE [dbo].[JnlCompareResultReport](
  [ReportId] [bigint] NOT NULL IDENTITY(1,1),
  [ApiId] [varchar](50) NOT NULL,
  [ResendDateTime] [datetime] NULL,
  [RequestRecordCreateDateTime] [datetime] NULL,
  [InnerVin] [varchar](20) NULL,
  [InnerUserId] [varchar](20) NULL,
  [RequestId] BIGINT NULL,
  [ResendTransactionId] VARCHAR(40) NULL,
  [CurrentCVProcessRequestData] [nvarchar](max) NULL,
  [NewCVProcessRequestData] [nvarchar](max) NULL,
  [ProcessRequestDataDifference] [nvarchar](max) NULL,
  [CompareResult] [tinyint] NULL,
  [ReportCreateDateTime] [datetime] NULL,
 CONSTRAINT [JnlCompareResultReport_PKC] PRIMARY KEY CLUSTERED
  (
    [ReportId] ASC
  )
);

CREATE TABLE [dbo].[RequestResendHistory] (
  [ResendTransactionId] VARCHAR(40) NOT NULL,
  [RequestId] BIGINT NOT NULL,
  [ResendDateTime] [datetime2](7) NULL,
  [RecordCreateDateTime] [datetime2](7) NULL,
  CONSTRAINT [RequestResendHistory_PKC] PRIMARY KEY CLUSTERED
  (
	[ResendTransactionId] ASC
  )
);

-- 3.3. Warning Analysis Tables
-- File: Create_table_cosmos.sql
CREATE TABLE [dbo].[WarningFileAnalysisInformation](
[InternalVin] [INT]  NOT NULL,
[SortDate] [VARCHAR] (20) NOT NULL,
[Vin] [VARCHAR] (17) NOT NULL,
[TransactionID] [VARCHAR] (40) NOT NULL,
[ReceiveDateTime] [VARCHAR] (20) NOT NULL,
[MasterVersion] [VARCHAR] (32) NOT NULL,
[TriggerNumber] [VARCHAR] (4) NOT NULL,
[SortImportance] [VARCHAR] (20) NOT NULL,
[RelevanceSpecifiedValue] [INT]  NOT NULL,
[Info] [VARCHAR] (8000) NOT NULL,
[ActionCode] [VARCHAR] (10) NULL,
[NotificationFlag] [INT]  NOT NULL,
[RecordCreate] [VARCHAR] (24) NOT NULL,
CONSTRAINT [WarningFileAnalysisInformation_PK] PRIMARY KEY CLUSTERED
(
[InternalVin] ASC,
[SortDate] DESC,
[TriggerNumber]
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [WarningFileAnalysisInformation_IDX] ON [dbo].[WarningFileAnalysisInformation]
(
[InternalVin],
[ActionCode]
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

CREATE TABLE [dbo].[WarningFileAnalysisInformationDetail](
[InternalVin] [INT]  NOT NULL,
[SortDate] [VARCHAR] (20) NOT NULL,
[TriggerNumber] [VARCHAR] (4) NOT NULL,
[LanguageCode] [VARCHAR] (2) NOT NULL,
[Info] [VARCHAR] (max) NOT NULL,
CONSTRAINT [WarningFileAnalysisInformationDetail_FK] FOREIGN KEY 
(
[InternalVin],
[SortDate],
[TriggerNumber]
)REFERENCES [dbo].[WarningFileAnalysisInformation] (InternalVin,SortDate,TriggerNumber)
ON DELETE CASCADE) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

-- 3.4. Diagnostic Analysis Tables
-- File: Create_table_cosmos.sql
CREATE TABLE [dbo].[DiagFileAnalysisInformation](
	[InternalVin] [INT]  NOT NULL,
	[SortDate] [VARCHAR] (20) NOT NULL,
	[Vin] [VARCHAR] (17) NOT NULL,
	[TransactionID] [VARCHAR] (40) NOT NULL,
	[CenterReceivedTime] [VARCHAR] (20) NOT NULL,
	[RelativeOccurrenceTime] [INT]  NOT NULL,
	[ModuleName] [VARCHAR] (10) NOT NULL,
	[Module_SequenceNo] [VARCHAR] (20) NOT NULL,
	[MasterVersion] [VARCHAR] (32) NOT NULL,
	[DtcCode] [VARCHAR] (8) NOT NULL,
	[SortOrder] [INT]  NOT NULL,
	[RelevanceSpecifiedValue] [INT]  NOT NULL,
	[OrderCharactor] [INT]  NOT NULL,
	[Info] [VARCHAR] (8000) NOT NULL,
	[RecordCreate] [VARCHAR] (24) NOT NULL,
	CONSTRAINT [DiagFileAnalysisInformation_PK] PRIMARY KEY CLUSTERED
	(
		[InternalVin] ASC,
		[SortDate] DESC,
		[DtcCode],
		[ModuleName]
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[DtcAnalysisDetail](
	[InternalVin] [INT]  NOT NULL,
	[SortDate] [VARCHAR] (20) NOT NULL,
	[DtcCode] [VARCHAR] (8) NOT NULL,
	[ModuleName] [VARCHAR] (10) NOT NULL,
	[LanguageCode] [VARCHAR] (2) NOT NULL,
	[Info] [VARCHAR] (max) NOT NULL,
	CONSTRAINT [DtcAnalysisDetail_FK] FOREIGN KEY 
	(
		[InternalVin],
		[SortDate],
		[DtcCode],
		[ModuleName]
	)REFERENCES [dbo].[DiagFileAnalysisInformation] (InternalVin,SortDate,DtcCode,ModuleName)
ON DELETE CASCADE) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

-- 3.5. Remote Confirm Analysis Tables
-- File: Create_table_cosmos.sql
CREATE TABLE [dbo].[RemoteConfirmAnalysisInformation](
[AnalysisNo] [BIGINT]  NOT NULL,
[InternalVin] [INT]  NOT NULL,
[SortDate] [VARCHAR] (20) NOT NULL,
[Vin] [VARCHAR] (17) NULL,
[TransactionID] [VARCHAR] (40) NULL,
[MasterVersion] [VARCHAR] (32) NULL,
[Info] [VARCHAR] (max) NOT NULL,
[RecordCreate] [VARCHAR] (24) NOT NULL,
[RecordUpdate] [VARCHAR] (24) NULL,
CONSTRAINT [RemoteConfirmAnalysisInformation_PK] PRIMARY KEY CLUSTERED
(
[InternalVin] ASC,
[SortDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

-- 3.6. eConnect Remote Confirm Analysis Table
-- File: Create_table_cosmos.sql
CREATE TABLE [dbo].[eConnectRemoteConfirmAnalysisInformation](
[AnalysisNo] [BIGINT]  NOT NULL,
[InternalVin] [INT]  NOT NULL,
[SortDate] [VARCHAR] (20) NOT NULL,
[Vin] [VARCHAR] (17) NOT NULL,
[TransactionID] [VARCHAR] (40) NOT NULL,
[NotificationDataDivision] [INT]  NOT NULL,
[Info] [VARCHAR] (8000) NOT NULL,
[ElectricalRemain] [DECIMAL] (3) NULL,
[DrivingRangeKm] [DECIMAL] (5,1) NULL,
[DrivingRangeMile] [DECIMAL] (5,1) NULL,
[DrivingRangeEVKm] [DECIMAL] (5,1) NULL,
[DrivingRangeEVMile] [DECIMAL] (5,1) NULL,
[RecordCreate] [VARCHAR] (24) NOT NULL,
[RecordUpdate] [VARCHAR] (24) NULL,
CONSTRAINT [eConnectRemoteConfirmAnalysisInformation_PK] PRIMARY KEY CLUSTERED
(
[InternalVin] ASC,
[SortDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)

-- 3.7. Battery Care Analysis Tables
-- File: Create_table_cosmos.sql
CREATE TABLE [dbo].[BatteryCareAnalysisInformation](
[InternalVin] [INT]  NOT NULL,
[SortDate] [VARCHAR] (20) NOT NULL,
[Vin] [VARCHAR] (17) NOT NULL,
[TransactionID] [VARCHAR] (40) NOT NULL,
[ReceiveDateTime] [VARCHAR] (20) NOT NULL,
[FileAnalysisDetail] [VARCHAR] (8000) NOT NULL,
[RecordCreate] [VARCHAR] (24) NOT NULL,
[RecordUpdate] [VARCHAR] (24) NULL,
CONSTRAINT [BatteryCareAnalysisInformation_PK] PRIMARY KEY CLUSTERED
(
[InternalVin] ASC,
[SortDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[BatteryCareAnalysisCalculationInformation](
[InternalVin] [INT]  NOT NULL,
[Vin] [VARCHAR] (17) NOT NULL,
[CarName] [NVARCHAR] (40) NOT NULL,
[Info] [VARCHAR] (max) NOT NULL,
[RecordCreate] [VARCHAR] (24) NOT NULL,
[RecordUpdate] [VARCHAR] (24) NULL,
CONSTRAINT [BatteryCareAnalysisCalculationInformation_PK] PRIMARY KEY CLUSTERED
(
[InternalVin] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

-- 3.8. Vehicle Data Deletion Management Table
-- File: cosmos.sql
CREATE TABLE [dbo].[VehicleDataDeletionManagement](
	[Region] [varchar](10) NOT NULL,
	[RegisteredCountry] [varchar](10) NOT NULL,
	[DeletionPendingPeriod] [int] NOT NULL,
	[DeleteTargetPeriod] [int] NOT NULL,
	[NextProcessingDate] [datetime] NOT NULL,
	[LastInternalVin] [int] NOT NULL,
	[RecordCreateDateTime] [datetime] NOT NULL,
	[RecordUpdateDateTime] [datetime] NULL,
 CONSTRAINT [VehicleDataDeletionManagement_PK] PRIMARY KEY CLUSTERED 
(
	[Region] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

-- 3.9. Oracle Equipment Tables
-- File: Script-25.sql
CREATE TABLE M_EQUIPMENT (
    SG_KU_CD VARCHAR2(6) NOT NULL,
    ZONE_CD VARCHAR2(2) NOT NULL,
    SOCHI_ID VARCHAR2(20) NOT NULL,
    SOCHI_NAME VARCHAR2(30),
    SOCHI_CMT VARCHAR2(40),
    ENTRY_DATE DATE DEFAULT sysdate,
    SIMEI VARCHAR2(30),
    VERSION_NO NUMBER(10,0) DEFAULT 1,
    CONSTRAINT PK_M_EQUIPMENT PRIMARY KEY(SG_KU_CD,ZONE_CD,SOCHI_ID)
);

CREATE TABLE W_MOVEIN_INPUT (
    APP_ID VARCHAR2(10) NOT NULL,
    SOCHI_ID VARCHAR2(20) NOT NULL,
    JSON LONG NOT NULL,
    CONSTRAINT PK_W_MOVEIN_INPUT PRIMARY KEY(APP_ID,SOCHI_ID)
);

-- =====================================================
-- 4. SELECT QUERIES
-- =====================================================

-- 4.1. Journal Log Queries
-- File: Script-5.sql, Script-6.sql
SELECT
    jf.FilePath,
    jl.BodyPointer,
    jl.BodySize
FROM JnlRequest jr
JOIN JnlLog jl
    ON jr.RequestId = jl.RequestId
JOIN JnlFile jf
    ON jf.FileId = jl.FileId
WHERE jr.TransactionId = 'TransactionId-1' AND
    jl.LogCategory = 'TM' AND
    jl.OutputId = '030'

SELECT
    jr.ApiId,
    jr.InnerVin,
    jr.InnerUserId,
    jf.FilePath,
    jl.BodyPointer,
    jl.BodySize
FROM JnlLog jl
JOIN JnlRequest jr
    ON jr.RequestId = jl.RequestId
JOIN JnlFile jf
    ON jf.FileId = jl.FileId
WHERE jr.RequestId = '1' AND
    jl.LogCategory = 'JS' AND
    jl.OutputId = '000'

-- 4.2. Diagnostic Analysis Query with JSON
-- File: Script-17.sql, Script-18.sql
SELECT
    Vin,
    InternalVin,
    SortDate,
    TransactionID,
    MasterVersion,
    CenterReceivedTime,
    RelativeOccurrenceTime,
    Module_SequenceNo,
    DtcCode,
    SortOrder,
    RelevanceSpecifiedValue,
    OrderCharactor,
    (
        SELECT
            LanguageCode,
            Info
        FROM DtcAnalysisDetail dtc
        WHERE
            dtc.InternalVin = df.InternalVin
        AND dtc.SortDate = df.SortDate
        AND dtc.DtcCode = df.DtcCode
        AND dtc.ModuleName = df.ModuleName
        FOR JSON PATH
    ) AS DtcAnalysisDetail,
    Info,
    RecordCreate
FROM DiagFileAnalysisInformation df
WHERE
    df.InternalVin = 1

-- 4.3. CV Vehicle Queries
-- File: cosmos_666.sql
SELECT
    *
FROM
    CvVehicle WITH ( nolock )
WHERE
    (PrimaryUserId is not null AND EndDateTime is null)
    OR
    (PrimaryUserId is not null AND EndDateTime > @EndDateTime)

SELECT TOP (100)
 InternalVin ,
 OnetimePassAuthenticationDateTime
FROM CvVehicle WITH ( nolock )
WHERE
 InternalVin > @internalVin AND
 SimStatus = @simStatus AND
(OnetimePassAuthenticationDateTime IS NULL OR OnetimePassAuthenticationDateTime >= @onetimePassAuthenticationDateTime ) AND
(CASE ISJSON(VehicleInformation) WHEN 1 THEN JSON_VALUE(VehicleInformation, '$.registeredCountry') ELSE NULL END)
 IN ( @registeredCountry0 )
ORDER BY InternalVin ASC

-- 4.4. Permission History Queries
-- File: 10140.sql
DECLARE @InternalUserId AS [bigint] = 1
DECLARE @Vin AS [varchar] = 0
DECLARE @CvPermType AS [tinyint] = 0

SELECT TOP(1)
    UbiConsentStatus
FROM
    CvPermissionHistory
WHERE
    InternalUserId = @InternalUserId AND
    vin = @Vin AND
    cvPermType = @CvPermType AND 
    RecordDeleteAt is null
ORDER BY PermTime DESC

-- 4.5. Complex Permission Query with UNION
-- File: Script-2.sql
SELECT CvPermType, PermTime, Version, Locale
FROM
(
    SELECT TOP(1) 
        CvPermType, PermTime, Version, Locale, RecordUpdatedAt
    FROM
        CvPermissionPreContractHistory
    WHERE
        InternalUserId = @InternalUserId AND
        AdvanceContractId = @advanceContractId AND
        CvPermType = '0' AND
        RecordDeleteAt is null
    ORDER BY
        RecordUpdatedAt DESC
) AS Query1
UNION ALL
SELECT CvPermType, PermTime, Version, Locale
FROM
(
    SELECT TOP(1)
        CvPermType, PermTime, Version, Locale, RecordUpdatedAt
    FROM
        CvPermissionPreContractHistory
    WHERE
        InternalUserId = @InternalUserId AND
        AdvanceContractId = @advanceContractId AND
        CvPermType = '1' AND
        RecordDeleteAt is null
    ORDER BY
        RecordUpdatedAt DESC
) AS Query2
-- Continue for other CvPermTypes...

-- 4.6. Preferred Dealer with Multiple Joins
-- File: 10140.sql
SELECT
	StoreMaster.StoreCode,
	StoreMaster.Name,
	StoreMaster.SalesCode,
	SalesCompanyMaster.StoreName,
	RSAMailAddressMaster.MailAddress
FROM
	RSAMailAddressMaster
INNER JOIN PreferredDealer
	ON (
		PreferredDealer.SalesCode = RSAMailAddressMaster.DistributorCode AND
		PreferredDealer.StoreCode = RSAMailAddressMaster.DealerCode
	)
INNER JOIN StoreMaster
	ON (
		PreferredDealer.StoreCode = StoreMaster.StoreCode AND
		PreferredDealer.SalesCode = StoreMaster.SalesCode
	)
INNER JOIN SalesCompanyMaster
	ON (
		PreferredDealer.SalesCode = SalesCompanyMaster.SalesCode
	)
WHERE
	PreferredDealer.InternalUserId = @InternalUserId AND
	PreferredDealer.Vin = @Vin AND
	PreferredDealer.PreferredDealerType = @PreferredDealerType AND
	StoreMaster.ActiveFlg = 1 AND
	RSAMailAddressMaster.CountryCode = @CountryCode AND
	RSAMailAddressMaster.AddressType = @AddressType

-- 4.7. Permission Pre-Contract History with ROW_NUMBER
-- File: #10155-#10104.sql
DECLARE @InternalUserId AS [bigint] = 1
DECLARE @AdvanceContractId AS [bigint] = 0
DECLARE @CvPermType AS [tinyint] = 0

SELECT TOP (1) WITH ties
    CvPermType,
    FORMAT(PermTime, 'yyyy-MM-ddTHH:mm:ssZ') AS PermTime,
    Version,
    Locale
FROM
    CvPermissionPreContractHistory
WHERE
    InternalUserId = @InternalUserId AND
    AdvanceContractId = @AdvanceContractId AND
    (@CvPermType IN (0,1,2,3) AND CvPermType = @CvPermType) OR
    (@CvPermType NOT IN (0,1,2,3) AND CvPermType IN (0,1,2,3)) AND
    RecordDeleteAt is null
ORDER BY ROW_NUMBER() OVER (PARTITION BY CvPermType ORDER BY RecordUpdatedAt DESC)

-- =====================================================
-- 5. INSERT OPERATIONS
-- =====================================================

-- 5.1. Address Data Master Insert
-- File: No3.sql
INSERT INTO sampledb.dbo.AddressDataMaster
(CountryCode, PostCode, Suburb, State, Street, RecordCreatedAt, RecordUpdatedAt)
VALUES('AU', '3170', 'MULGRAVE', 'VIC', '211A Wellington Rd', '2022-03-20 13:10:16.000', '2022-03-20 13:10:16.000');

-- 5.2. Journal Tables Data Insert
-- File: Script-5.sql, Script-6.sql, Script-7.sql, Script-9.sql
INSERT [dbo].[JnlLog] ([FileId], [FileRecordNo], [RequestId], [OutputDateTime], [LogCategory], [OutputId], [BodyPointer], [BodySize], [RecordCreateDateTime])
VALUES (1, 1, 1, GETUTCDATE(), 'TM', '030', 0, 1024, GETUTCDATE())

INSERT [dbo].[JnlRequest] ([ApiId], [TransactionId], [RecordCreateDateTime], [RecordUpdateDateTime], [RequestStatus])
VALUES ('ApiId-1', 'TransactionId-1', GETUTCDATE(), GETUTCDATE(), 0)

INSERT [dbo].[JnlFile] ([FilePath], [FileRecords], [FileUpdateDateTime], [RecordCreateDateTime])
VALUES ('current.log', 1, GETUTCDATE(), GETUTCDATE())

-- 5.3. Warning Analysis Insert
-- File: Script-14.sql, cosmos_666.sql
INSERT INTO [dbo].[WarningAnalysisComplete](InternalVin,SortDate,AnalysisCount,RecordCreate)
VALUES(1,GETUTCDATE(),1,GETUTCDATE())

INSERT INTO [dbo].[WarningFileAnalysisInformation](InternalVin,SortDate,Vin,TransactionID,ReceiveDateTime,MasterVersion,TriggerNumber,SortImportance,RelevanceSpecifiedValue,Info,NotificationFlag,RecordCreate)
VALUES
(1,GETUTCDATE(),'JM0BP2H7601200000','TransactionID','ReceiveDateTime','MasterVersion',1,'SortImportance',1,'{}',1,'RecordCreate')

-- 5.4. eConnect Remote Confirm Analysis Insert
-- File: cosmos_666.sql
INSERT INTO [dbo].[eConnectRemoteConfirmAnalysisInformation](AnalysisNo,InternalVin,SortDate,Vin,TransactionID,NotificationDataDivision,Info,RecordCreate)
VALUES
(1,10,GETUTCDATE(),'JM0BP2H7601200000','TransactionID',1,'{}',GETUTCDATE())

-- 5.5. Compare Result Report Insert
-- File: Script-9.sql
INSERT [dbo].[JnlCompareResultReport] ([ApiId], [ResendDateTime], [RequestRecordCreateDateTime], [CompareResult], [ReportCreateDateTime])
VALUES ('ApiId-1', GETUTCDATE(), GETUTCDATE(),0, GETUTCDATE())

INSERT [dbo].[RequestResendHistory] ([ResendTransactionId], [RequestId], [ResendDateTime], [RecordCreateDateTime])
VALUES (N'TransactionId-1', 1, CAST(N'2024-05-19T07:56:14.6465294' AS DateTime2), CAST(N'2024-05-19T07:56:14.6465294' AS DateTime2))

-- 5.6. Vehicle Data Deletion Management Insert
-- File: cosmos.sql
INSERT INTO [dbo].[VehicleDataDeletionManagement](Region,RegisteredCountry,DeletionPendingPeriod,DeleteTargetPeriod,NextProcessingDate,LastInternalVin,RecordCreateDateTime)
VALUES('MJO','Japan',1,2,GETUTCDATE(),1,GETUTCDATE())
INSERT INTO [dbo].[VehicleDataDeletionManagement](Region,RegisteredCountry,DeletionPendingPeriod,DeleteTargetPeriod,NextProcessingDate,LastInternalVin,RecordCreateDateTime)
VALUES('MNAO','North American',1,2,GETUTCDATE(),1,GETUTCDATE())
INSERT INTO [dbo].[VehicleDataDeletionManagement](Region,RegisteredCountry,DeletionPendingPeriod,DeleteTargetPeriod,NextProcessingDate,LastInternalVin,RecordCreateDateTime)
VALUES('MCI','Canada',1,2,GETUTCDATE(),1,GETUTCDATE())
INSERT INTO [dbo].[VehicleDataDeletionManagement](Region,RegisteredCountry,DeletionPendingPeriod,DeleteTargetPeriod,NextProcessingDate,LastInternalVin,RecordCreateDateTime)
VALUES('MME','Europe',1,2,GETUTCDATE(),1,GETUTCDATE())
INSERT INTO [dbo].[VehicleDataDeletionManagement](Region,RegisteredCountry,DeletionPendingPeriod,DeleteTargetPeriod,NextProcessingDate,LastInternalVin,RecordCreateDateTime)
VALUES('MA','Australia',1,2,GETUTCDATE(),1,GETUTCDATE())

-- 5.7. Extract User List Last Extract Time Insert
-- File: cosmos_666.sql
INSERT INTO [dbo].[ExtractUserListLastExtractTime](id, date)
VALUES
(19,GETUTCDATE())

-- 5.8. IMEI Integration Data Insert
-- File: #10155-#10104.sql
INSERT INTO IMEIIntegrationDataTargetTable (
    Vin,
    Imei,
    Company,
    Type,
    CreatedDate
)
SELECT
    tmp.Vin AS Vin, 
    tmp.Imei AS Imei, 
    tmp.Company AS Company,
    tmp.Type AS Type,
    tmp.RecordCreatedAt AS RecordCreatedAt
  FROM
    IMEIInfoHistoryTable tmp WITH (NOLOCK)
  WHERE
    tmp.LinkageFlag = 0 AND
    tmp.Company IN ('MA', 'MNAO', 'MCI', 'MJO');

-- =====================================================
-- 6. UPDATE OPERATIONS
-- =====================================================

-- 6.1. Update Default Equipment
-- File: Script-25.sql
UPDATE 
	T_DEFAULT_SOCHI
SET
	DEF_SOCHI_ID = '26 SPW612A-61'
WHERE
    PC_CD = '0.0.0.1'

UPDATE 
	M_NOTES_INPUT
SET
	SOCHI_ID = '26 SPW612A-61'
WHERE
    SOCHI_ID <> '26 SPW612A-61'

-- 6.2. Update IMEI Info History Table
-- File: #10155-#10104.sql
UPDATE IMEIInfoHistoryTable
	SET
		LinkageFlag = 0,
		RecordUpdatedAt = SYSDATETIME()
FROM IMEIInfoHistoryTable TARGET
JOIN IMEIIntegrationDataTargetTable SOURCE
	ON (
        TARGET.Vin = SOURCE.Vin AND
        TARGET.Imei = SOURCE.Imei AND
        TARGET.Company = SOURCE.Company
    )

-- =====================================================
-- 7. ALTER TABLE OPERATIONS
-- =====================================================

-- 7.1. Add SimStatus Column
-- File: Script-14.sql
ALTER TABLE [dbo].[CvVehicle] ADD [SimStatus] [tinyint] NULL DEFAULT(0)

-- 7.2. Change Column Type
-- File: Script-14.sql
ALTER TABLE WarningAnalysisComplete 
ALTER COLUMN SortDate datetime NOT NULL

-- 7.3. Add AlexsaFlg Column
-- File: 10113.sql
ALTER TABLE VehicleMaster ADD AlexsaFlg varchar(1);

-- 7.4. Drop and Modify Column
-- File: Script-2.sql
ALTER TABLE UserTable DROP InternalUserId;
ALTER TABLE 'UserTable' MODIFY InternalUserId column increment int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

-- =====================================================
-- 8. DELETE AND DROP OPERATIONS
-- =====================================================

-- 8.1. Delete from IMEI Integration Data
-- File: #10155-#10104.sql
DELETE FROM  IMEIIntegrationDataTargetTable;

-- 8.2. Drop Tables
-- File: Script-14.sql
DROP TABLE IF EXISTS [dbo].[WarningAnalysisComplete]
DROP TABLE IF EXISTS [dbo].[BatteryCareAnalysisInformation]
DROP TABLE IF EXISTS [dbo].[BatteryCareAnalysisCalculationInformation]

-- 8.3. Oracle Drop All Tables
-- File: Script-25.sql
BEGIN
  FOR cur IN (SELECT table_name FROM user_tables) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ' || cur.table_name || ' CASCADE CONSTRAINTS';
  END LOOP;
END;
/

DROP TABLE M_ALARMID CASCADE CONSTRAINTS;

-- =====================================================
-- 9. DATE AND TIME OPERATIONS
-- =====================================================

-- 9.1. SYSDATETIME() Usage
-- Most INSERT and UPDATE operations use SYSDATETIME() for current timestamp

-- 9.2. GETUTCDATE() Usage
-- Used in table creation and insert operations for UTC time

-- 9.3. Date Formatting
-- File: 10256_Base.sql
FORMAT(PD.RecordCreateDateTime, 'yyyy-MM-ddTHH:mm:ssZ') 

-- 9.4. Date Conversion with STUFF
-- File: IMS10010502.sql, No3.sql
CONVERT(DATETIME, STUFF(STUFF(STUFF('20230315', 9, 0, ' '), 12, 0, ':'), 15, 0, ':'))

-- =====================================================
-- END OF CONSOLIDATED SQL TEMPLATES
-- =====================================================