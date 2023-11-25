/*====================================================================
Author: Rafael Niño
Create date: 07/07/2023
Description SP: Busca Usuarios App Web de consultas de Retenciones
Cliente: GENERAL
Tablas: WEBUSERS_VOG  - USUARIO APP WEB
SP Asociados: 
Ejemplo:
EXEC PL_WEBListRetencionesARCVVOG_S 
		 @INTERID			='ALIB5'
		,@RIF				='J298387211'
		,@FECHADESDE		='20210101'
		,@FECHAHASTA		='20230531'
		,@DOCUMENTO			=''
Cambios en tablas:
=======================================================================*/

IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[PL_WEBListRetencionesARCVVOG_S]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].PL_WEBListRetencionesARCVVOG_S
go
CREATE PROCEDURE PL_WEBListRetencionesARCVVOG_S
(@INTERID			NVARCHAR(15)
,@RIF				NVARCHAR(12)
,@FECHADESDE		DATE
,@FECHAHASTA		DATE
,@DOCUMENTO			VARCHAR(25)
) AS
BEGIN
SET NOCOUNT ON;
  DECLARE @I INT=1,@TOTALFILAS INT=0
  DECLARE @SQLSTR    NVARCHAR(MAX)='',@Parametro nvarchar(500)
  
if (OBJECT_ID('tempdb.dbo.##DOCUMENTOS','U')) is not null
	DROP TABLE ##DOCUMENTOS

  CREATE TABLE ##DOCUMENTOS (
	 NRODOCUMENTO		CHAR(25)	
	,FECHADOC			DATETIME
	,FECHACON			DATETIME
	,ALICUOTA			NUMERIC(18,2)
	,TIPO				VARCHAR(20)
  )
  --------------------ISLR----------------------------
  --REGISTROS ABIERTOS  -- IMPP3000
  SET @SQLSTR=CONCAT(' INSERT INTO ##DOCUMENTOS
					SELECT  RIGHT(RTRIM(IMP_nc_open3_period),4) NRODOCUMENTO
						   ,CONVERT(DATETIME,CONCAT(RIGHT(RTRIM(IMP_nc_open3_period),4),''1231'')) FECHADOC
						   ,CONVERT(DATETIME,CONCAT(RIGHT(RTRIM(IMP_nc_open3_period),4),''1231'')) FECHACON
						   ,0 ALICUOTA
						   ,''ARCV'' TIPO 
					FROM ',@INTERID,'.DBO.IMPP3000 I
					INNER JOIN ',@INTERID,'.DBO.IMPP0161 P ON P.PV_MI_idprov=I.open3_p
				   WHERE RIGHT(RTRIM(IMP_nc_open3_period),4) BETWEEN YEAR(@FECHADESDE) AND YEAR(@FECHAHASTA)
					 AND P.PV_MI_rif000=@RIF
				   GROUP BY RIGHT(RTRIM(IMP_nc_open3_period),4)')

   SET @Parametro = N'@FECHADESDE DATE,@FECHAHASTA DATE,@RIF NVARCHAR(12)';  
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
                      @FECHADESDE = @FECHADESDE,@FECHAHASTA=@FECHAHASTA,@RIF=@RIF;

  --REGISTROS HISTORICOS ISLR -- IMPP3200
  SET @SQLSTR=CONCAT(' INSERT INTO ##DOCUMENTOS
					SELECT  RIGHT(RTRIM(IMP_nc_hist3_period),4) NRODOCUMENTO
						   ,CONVERT(DATETIME,CONCAT(RIGHT(RTRIM(IMP_nc_hist3_period),4),''1231'')) FECHADOC
						   ,CONVERT(DATETIME,CONCAT(RIGHT(RTRIM(IMP_nc_hist3_period),4),''1231'')) FECHACON
						   ,0 ALICUOTA
						   ,''ARCV'' TIPO 
					FROM ',@INTERID,'.DBO.IMPP3200 I
					INNER JOIN ',@INTERID,'.DBO.IMPP0161 P ON P.PV_MI_idprov=I.hist3_p
				   WHERE RIGHT(RTRIM(IMP_nc_hist3_period),4) BETWEEN YEAR(@FECHADESDE) AND YEAR(@FECHAHASTA)
					 AND P.PV_MI_rif000=@RIF
				   GROUP BY RIGHT(RTRIM(IMP_nc_hist3_period),4)')
 
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
                      @FECHADESDE = @FECHADESDE,@FECHAHASTA=@FECHAHASTA,@RIF=@RIF;

   SELECT ROW_NUMBER() OVER(ORDER BY FECHADOC) ID
		  ,* 
   FROM ##DOCUMENTOS
   ORDER BY FECHADOC
SET NOCOUNT OFF;
END