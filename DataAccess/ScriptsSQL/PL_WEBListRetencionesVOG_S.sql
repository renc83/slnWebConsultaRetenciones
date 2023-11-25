/*====================================================================
Author: Rafael Niño
Create date: 07/07/2023
Description SP: Busca Usuarios App Web de consultas de Retenciones
Cliente: GENERAL
Tablas: WEBUSERS_VOG  - USUARIO APP WEB
SP Asociados: 
Ejemplo:
EXEC PL_WEBListRetencionesVOG_S 
		 @INTERID			='ALIB5'
		,@RIF				='V036248161'
		,@FECHADESDE		='20220101'
		,@FECHAHASTA		='20230531'
		,@DOCUMENTO			=''
Cambios en tablas:
=======================================================================*/
USE DYNAMICS;
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[PL_WEBListRetencionesVOG_S]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].PL_WEBListRetencionesVOG_S
go
CREATE PROCEDURE PL_WEBListRetencionesVOG_S
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
					  SELECT   IMP_nc_open3_numdoc DOCUMENTO
							  ,IMP_nc_open3_fecdoc FECHADOC
							  ,IMP_nc_open3_feccon FECHACON
							  ,ABS(IMP_nc_open3_porimp) ALICUOTA
							  ,''ISLR'' TIPO 
					    FROM ',@INTERID,'.DBO.IMPP3000 I
					   INNER JOIN ',@INTERID,'.DBO.IMPP0161 P ON P.PV_MI_idprov=I.open3_p
					   WHERE IMP_nc_open3_fecdoc BETWEEN (@FECHADESDE) AND (@FECHAHASTA)
					   AND P.PV_MI_rif000=@RIF   AND I.IMP_nc_open3_numnc='''' ')
	IF @DOCUMENTO<>'' SET @SQLSTR =CONCAT(@SQLSTR , ' AND IMP_nc_open3_numdoc=''',@DOCUMENTO,'''')

   SET @Parametro = N'@FECHADESDE DATE,@FECHAHASTA DATE,@RIF NVARCHAR(12)';  
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
                      @FECHADESDE = @FECHADESDE,@FECHAHASTA=@FECHAHASTA,@RIF=@RIF;

  --REGISTROS HISTORICOS ISLR -- IMPP3200
  SET @SQLSTR=CONCAT(' INSERT INTO ##DOCUMENTOS
					  SELECT   IMP_nc_hist3_numdoc DOCUMENTO
							  ,IMP_nc_hist3_fecdoc FECHADOC
							  ,IMP_nc_hist3_feccon FECHACON
							  ,ABS(IMP_nc_hist3_porimp) ALICUOTA
							  ,''ISLR'' TIPO 
					    FROM ',@INTERID,'.DBO.IMPP3200 I
					   INNER JOIN ',@INTERID,'.DBO.IMPP0161 P ON P.PV_MI_idprov=I.hist3_p
					   WHERE IMP_nc_hist3_fecdoc BETWEEN (@FECHADESDE) AND (@FECHAHASTA)
					   AND P.PV_MI_rif000=@RIF  AND I.IMP_nc_hist3_numnc='''' ')
	IF @DOCUMENTO<>'' SET @SQLSTR =CONCAT(@SQLSTR , ' AND I.IMP_nc_hist3_numdoc=''',@DOCUMENTO,'''')
 
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
                      @FECHADESDE = @FECHADESDE,@FECHAHASTA=@FECHAHASTA,@RIF=@RIF;

  ---------------------IVA----------------------------
  --REGISTROS ABIERTOS  -- IMPP2001
  SET @SQLSTR=CONCAT(' INSERT INTO ##DOCUMENTOS
					  SELECT   IMP_nc_open_docnum as DOCUMENTO
							  		,IMP_nc_open_fecdoc AS FECHADOC
									,IMP_nc_open_feccon AS FECHACON
									,CASE
										WHEN IMP_porcrete_alicgene  != 0 THEN ABS(CONVERT(NUMERIC(18,2),IMP_porcrete_alicgene))
										WHEN IMP_porcrete_alicreduc != 0 THEN ABS(CONVERT(NUMERIC(18,2),IMP_porcrete_alicreduc))
										WHEN IMP_porcrete_alicadic  != 0 THEN ABS(CONVERT(NUMERIC(18,2),IMP_porcrete_alicadic))
										END AS ALICUOTA
							  ,''IVA'' TIPO 
					    FROM ',@INTERID,'.DBO.IMPP2001 I
					   INNER JOIN ',@INTERID,'.DBO.IMPP0161 P ON P.PV_MI_idprov=I.open_p
					   WHERE IMP_nc_open_fecdoc BETWEEN (@FECHADESDE) AND (@FECHAHASTA)
					   AND P.PV_MI_rif000=@RIF  AND I.IMP_nc_open_numntc=''''  ')
	IF @DOCUMENTO<>'' SET @SQLSTR =CONCAT(@SQLSTR , ' AND I.IMP_nc_open_docnum=''',@DOCUMENTO,'''')

   SET @Parametro = N'@FECHADESDE DATE,@FECHAHASTA DATE,@RIF NVARCHAR(12)';  
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
                      @FECHADESDE = @FECHADESDE,@FECHAHASTA=@FECHAHASTA,@RIF=@RIF;

  --REGISTROS HISTORICOS  -- IMPP2201
  SET @SQLSTR=CONCAT(' INSERT INTO ##DOCUMENTOS
					  SELECT   IMP_nc_hist_docnum as DOCUMENTO
							  		,IMP_nc_hist_fecdoc AS FECHADOC
									,IMP_nc_hist_feccon AS FECHACON
									,CASE
										WHEN IMP_porcrete_alicgene  != 0 THEN ABS(CONVERT(NUMERIC(18,2),IMP_porcrete_alicgene))
										WHEN IMP_porcrete_alicreduc != 0 THEN ABS(CONVERT(NUMERIC(18,2),IMP_porcrete_alicreduc))
										WHEN IMP_porcrete_alicadic  != 0 THEN ABS(CONVERT(NUMERIC(18,2),IMP_porcrete_alicadic))
										END AS ALICUOTA
							  ,''IVA'' TIPO 
					    FROM ',@INTERID,'.DBO.IMPP2201 I
					   INNER JOIN ',@INTERID,'.DBO.IMPP0161 P ON P.PV_MI_idprov=I.hist_p
					   WHERE IMP_nc_hist_fecdoc BETWEEN (@FECHADESDE) AND (@FECHAHASTA)
					     AND P.PV_MI_rif000=@RIF AND I.IMP_nc_hist_numntc=''''  ')
	IF @DOCUMENTO<>'' SET @SQLSTR =CONCAT(@SQLSTR , ' AND IMP_nc_hist_docnum=''',@DOCUMENTO,'''')

   SET @Parametro = N'@FECHADESDE DATE,@FECHAHASTA DATE,@RIF NVARCHAR(12)';  
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
                      @FECHADESDE = @FECHADESDE,@FECHAHASTA=@FECHAHASTA,@RIF=@RIF;

  ---------------------ADICIONAL----------------------------
  --REGISTROS ABIERTOS  -- IMPP4000
  SET @SQLSTR=CONCAT(' INSERT INTO ##DOCUMENTOS
					  SELECT   IMP_gene_numdoc   AS DOCUMENTO
									,IMP_gene_fecdoc  AS FECHADOC
									,IMP_gene_feccon  AS FECHACON
									,ABS(IMP_gene_porimp)   AS ALICUOTA
							  ,''MUN'' TIPO 
					    FROM ',@INTERID,'.DBO.IMPP4000 I
					   INNER JOIN ',@INTERID,'.DBO.IMPP0161 P ON P.PV_MI_idprov=I.IMP_gene_idprov
					   WHERE IMP_gene_fecdoc BETWEEN (@FECHADESDE) AND (@FECHAHASTA)
					     AND P.PV_MI_rif000=@RIF AND I.IMP_gene_numntc=''''  ')
	IF @DOCUMENTO<>'' SET @SQLSTR =CONCAT(@SQLSTR , ' AND IMP_gene_numdoc=''',@DOCUMENTO,'''')

   SET @Parametro = N'@FECHADESDE DATE,@FECHAHASTA DATE,@RIF NVARCHAR(12)';  
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
                      @FECHADESDE = @FECHADESDE,@FECHAHASTA=@FECHAHASTA,@RIF=@RIF;

  --REGISTROS HISTORICO  -- IMPP4100
  SET @SQLSTR=CONCAT(' INSERT INTO ##DOCUMENTOS
					  SELECT   IMP_gene_numdoch   AS DOCUMENTO
									,IMP_gene_fecdoch  AS FECHADOC
									,IMP_gene_fecconh  AS FECHACON
									,ABS(IMP_gene_porimph)   AS ALICUOTA
							  ,''MUN'' TIPO 
					    FROM ',@INTERID,'.DBO.IMPP4100 I
					   INNER JOIN ',@INTERID,'.DBO.IMPP0161 P ON P.PV_MI_idprov=I.IMP_gene_idprovh
					   WHERE IMP_gene_fecdoch BETWEEN (@FECHADESDE) AND (@FECHAHASTA)
					     AND P.PV_MI_rif000=@RIF AND I.IMP_gene_numntch='''' ')
	IF @DOCUMENTO<>'' SET @SQLSTR =CONCAT(@SQLSTR , ' AND IMP_gene_numdoch=''',@DOCUMENTO,'''')

   SET @Parametro = N'@FECHADESDE DATE,@FECHAHASTA DATE,@RIF NVARCHAR(12)';  
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
                      @FECHADESDE = @FECHADESDE,@FECHAHASTA=@FECHAHASTA,@RIF=@RIF;


   SELECT ROW_NUMBER() OVER(ORDER BY NRODOCUMENTO DESC) ID
		  ,* 
   FROM ##DOCUMENTOS
   ORDER BY NRODOCUMENTO DESC
SET NOCOUNT OFF;
END