/*====================================================================
Author: Rafael Niño
Create date: 07/07/2023
Description SP: Busca Usuarios App Web de consultas de Retenciones
Cliente: GENERAL
Tablas: WEBUSERS_VOG  - USUARIO APP WEB
SP Asociados: 
Ejemplo:
EXEC PL_WEB_RetARCVDetVOG_S 
		 @RIF			='V036248161'
		 ,@ANIO		 ='2023'
		 ,@interid   ='ALIB5'
Cambios en tablas:
=======================================================================*/
USE DYNAMICS;
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[PL_WEB_RetARCVDetVOG_S]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].PL_WEB_RetARCVDetVOG_S
go
CREATE PROCEDURE PL_WEB_RetARCVDetVOG_S
(@INTERID		VARCHAR(5)
,@RIF			VARCHAR(15)
,@ANIO		    varchar(4)
) AS
BEGIN
SET NOCOUNT ON;
DECLARE @SQLSTR    NVARCHAR(MAX)='',@Parametro nvarchar(500)

  if (OBJECT_ID('tempdb.dbo.##DETALLE','U')) is not null
	DROP TABLE ##DETALLE

  CREATE TABLE ##DETALLE (
 RIF						VARCHAR(11)
,ANIO						INT
,MES						INT
,FECHADOC					DATETIME
,NUMDOC						VARCHAR(21)
,BASEIMP					NUMERIC(19,5)
,ALICUOTA					NUMERIC(19,5)
,ISLRRETENIDO				NUMERIC(19,5)
,MONTOPAGADO				NUMERIC(19,5)
,DETIMP						VARCHAR(31)
)


  --TRABAJO--
	SET @SQLSTR=CONCAT(' INSERT INTO ##DETALLE
				SELECT	 IMP_nc_open3_rif000	RIF
						,RIGHT(RTRIM(IM.IMP_nc_open3_period),4)		ANIO
						--,REPLACE(LEFT(IMP_nc_open3_period,3),''M'','''')	MES
						,MONTH(IMP_nc_open3_feccon) MES
						,IMP_nc_open3_feccon	FECHADOC
						,IMP_nc_open3_numdoc	NUMDOC
						,sum(IMP_nc_open3_basimp)	BASEIMP
						,max(IMP_nc_open3_porimp)	ALICUOTA
						,sum(IMP_nc_open3_monimp)	ISLRRETENIDO
						,SUM(ISNULL(PMT.DOCAMNT,PMH.DOCAMNT))							MONTOPAGADO
						,IMP_nc_open3_detimp		DETIMP
				FROM ',@INTERID,'.DBO.IMPP3000 IM
				left JOIN ',@INTERID,'.DBO.IMPP0161 PV  ON PV.PV_MI_idprov=IM.open3_p
			 LEFT JOIN ',@INTERID,'.DBO.PM20000 PMT ON IM.IMP_nc_open3_numdoc=PMT.DOCNUMBR AND PMT.VENDORID=IM.open3_p
			 LEFT JOIN ',@INTERID,'.DBO.PM30200 PMH ON IM.IMP_nc_open3_numdoc=PMH.DOCNUMBR AND PMH.VENDORID=IM.open3_p
			   WHERE PV.PV_MI_rif000 = @RIF
				 AND RIGHT(RTRIM(IM.IMP_nc_open3_period),4) = @ANIO
				 GROUP BY IMP_nc_open3_period,IMP_nc_open3_rif000,IMP_nc_open3_feccon,IMP_nc_open3_numdoc,IMP_nc_open3_detimp ')

   SET @Parametro = N'@RIF NVARCHAR(12),@ANIO		INT';  
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
						 @RIF=@RIF,@ANIO=@ANIO;

  --HISTORICO--
	SET @SQLSTR=CONCAT(' INSERT INTO ##DETALLE
				SELECT	 IMP_nc_hist3_rif000	RIF
						,RIGHT(RTRIM(IM.IMP_nc_hist3_period),4)		ANIO
						--,REPLACE(LEFT(IMP_nc_hist3_period,3),''M'','''')	MES
						,MONTH(IMP_nc_hist3_feccon) MES
						,IMP_nc_hist3_feccon	FECHADOC
						,IMP_nc_hist3_numdoc	NUMDOC
						,sum(IMP_nc_hist3_basimp)	BASEIMP
						,max(IMP_nc_hist3_porimp)	ALICUOTA
						,sum(IMP_nc_hist3_monimp)	ISLRRETENIDO
						,SUM(ISNULL(PMT.DOCAMNT,PMH.DOCAMNT))			MONTOPAGADO
						,IMP_nc_hist3_detimp	DETIMP
				FROM ',@INTERID,'.DBO.IMPP3200 IM
				left JOIN ',@INTERID,'.DBO.IMPP0161 PV  ON PV.PV_MI_idprov = IM.hist3_p
			 LEFT JOIN ',@INTERID,'.DBO.PM20000 PMT ON IM.IMP_nc_hist3_numdoc=PMT.DOCNUMBR AND PMT.VENDORID=IM.hist3_p
			 LEFT JOIN ',@INTERID,'.DBO.PM30200 PMH ON IM.IMP_nc_hist3_numdoc=PMH.DOCNUMBR AND PMH.VENDORID=IM.hist3_p
			   WHERE PV.PV_MI_rif000 = @RIF
				 AND RIGHT(RTRIM(IM.IMP_nc_hist3_period),4) = @ANIO
				 GROUP BY IMP_nc_hist3_period,IMP_nc_hist3_feccon,IMP_nc_hist3_rif000,IMP_nc_hist3_numdoc,IMP_nc_hist3_detimp')

   SET @Parametro = N'@RIF NVARCHAR(12),@ANIO		INT';  
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
						 @RIF=@RIF,@ANIO=@ANIO;

	SELECT  RIF			
		   ,ANIO			
		   ,right(concat('0',MES),2) MES			
		   ,FECHADOC		
		   ,NUMDOC		DOCUMENTO	
		   ,ABS(BASEIMP)	 BASEIMP
		   ,ABS(ALICUOTA)		ALICUOTA
		   ,ABS(ISLRRETENIDO) ISLRRETENIDO	
		   ,ABS(MONTOPAGADO	) MONTOPAGADO	
		   ,DETIMP	
	FROM ##DETALLE





SET NOCOUNT OFF;
END