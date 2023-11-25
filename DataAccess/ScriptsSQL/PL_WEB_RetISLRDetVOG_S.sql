/*====================================================================
Author: Rafael Niño
Create date: 07/07/2023
Description SP: Busca Usuarios App Web de consultas de Retenciones
Cliente: GENERAL
Tablas: WEBUSERS_VOG  - USUARIO APP WEB
SP Asociados: 
Ejemplo:
EXEC PL_WEB_RetISLRDetVOG_S 
		 @RIF			='V123917967'
		 ,@DOCUMENTO ='001283'
		 ,@interid   ='ALIB5'
Cambios en tablas:
=======================================================================*/
USE DYNAMICS;
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[PL_WEB_RetISLRDetVOG_S]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].PL_WEB_RetISLRDetVOG_S
go
CREATE PROCEDURE PL_WEB_RetISLRDetVOG_S
(@INTERID		VARCHAR(5)
,@RIF			VARCHAR(15)
,@DOCUMENTO		VARCHAR(25)
) AS
BEGIN
SET NOCOUNT ON;
DECLARE @SQLSTR    NVARCHAR(MAX)='',@Parametro nvarchar(500)

  if (OBJECT_ID('tempdb.dbo.##DETALLE','U')) is not null
	DROP TABLE ##DETALLE

  CREATE TABLE ##DETALLE (
 RIF						VARCHAR(11)
,FECHADOC					DATE
,NUMFACTURA					VARCHAR(21)
,NUMCONTROL					VARCHAR(31)
,NUMNTD						VARCHAR(21)
,NUMNTC						VARCHAR(21)
,DETIMP						VARCHAR(31)
,BASEIMP					NUMERIC(19,5)
,ALICUOTA					NUMERIC(19,5)
,ISLRRETENIDO				NUMERIC(19,5)
,MONTOPAGADO				NUMERIC(19,5)
,NUMDOC						VARCHAR(21)
,NUMOPERA					SMALLINT
,FACTURAAFEC				VARCHAR(21)
,ESTATUS					VARCHAR(31)
,TIPOTRX					SMALLINT
,VENDORID					VARCHAR(21)
)

  if (OBJECT_ID('tempdb.dbo.##CXPIMP','U')) is not null
	DROP TABLE ##CXPIMP

  CREATE TABLE ##CXPIMP (
 RIF						VARCHAR(11) COLLATE SQL_Latin1_General_CP1_CI_AS
,MONTOPAGADO				NUMERIC(19,5)
,NUMDOC						VARCHAR(21) COLLATE SQL_Latin1_General_CP1_CI_AS
)

  --TRABAJO--
	SET @SQLSTR=CONCAT(' INSERT INTO ##DETALLE
				SELECT	 IMP_nc_open3_rif000	RIF
						,IMP_nc_open3_fecdoc	FECHADOC
						,IMP_nc_open3_numfac	NUMFACTURA
						,IMP_nc_open3_ncontro	NUMCONTROL
						,IMP_nc_open3_numnd		NUMNTD
						,IMP_nc_open3_numnc		NUMNTC
						,IMP_nc_open3_detimp	DETIMP
						,IMP_nc_open3_basimp	BASEIMP
						,IMP_nc_open3_porimp	ALICUOTA
						,IMP_nc_open3_monimp	ISLRRETENIDO
						,ISNULL(PMT.DOCAMNT,PMH.DOCAMNT)			MONTOPAGADO
						,IMP_nc_open3_numdoc	NUMDOC
						,IMP_nc_open3_nopera	NUMOPERA
						,IMP_nc_open3_numfaf	FACTURAAFEC
						,IMP_nc_open3_status	ESTATUS
						,IMP_nc_open3_tiptra	TIPOTRX
						,IM.open3_p				VENDORID
				FROM ',@INTERID,'.DBO.IMPP3000 IM
			 left JOIN ',@INTERID,'.DBO.IMPP0161 PV  ON PV.PV_MI_idprov=IM.open3_p
			 LEFT JOIN ',@INTERID,'.DBO.PM20000 PMT ON IM.IMP_nc_open3_numdoc=PMT.DOCNUMBR AND PMT.VENDORID=IM.open3_p
			 LEFT JOIN ',@INTERID,'.DBO.PM30200 PMH ON IM.IMP_nc_open3_numdoc=PMH.DOCNUMBR AND PMH.VENDORID=IM.open3_p
			   WHERE PV.PV_MI_rif000 = @RIF
				 AND IMP_nc_open3_numdoc = @DOCUMENTO')

   SET @Parametro = N'@RIF NVARCHAR(12),@DOCUMENTO		VARCHAR(25)';  
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
						 @RIF=@RIF,@DOCUMENTO=@DOCUMENTO;

--NOTAS DE CREDITO
	SET @SQLSTR=CONCAT(' INSERT INTO ##DETALLE
				SELECT	 IMP_nc_open3_rif000d	RIF
						,IMP_nc_open3_fecdocd	FECHADOC
						,IMP_nc_open3_numfacd	NUMFACTURA
						,IMP_nc_open3_ncontrod	NUMCONTROL
						,IMP_nc_open3_numndd		NUMNTD
						,IMP_nc_open3_numncd		NUMNTC
						,IMP_nc_open3_detimpd	DETIMP
						,IMP_nc_open3_basimpd	BASEIMP
						,IMP_nc_open3_porimpd	ALICUOTA
						,IMP_nc_open3_monimpd	ISLRRETENIDO
						,ISNULL(PMT.DOCAMNT,PMH.DOCAMNT)			MONTOPAGADO
						,IMP_nc_open3_numdocd	NUMDOC
						,IMP_nc_open3_noperad	NUMOPERA
						,IMP_nc_open3_numfafd	FACTURAAFEC
						,IMP_nc_open3_statusd	ESTATUS
						,IMP_nc_open3_tiptrad	TIPOTRX
						,IM.open3_pd			VENDORID
				FROM ',@INTERID,'.DBO.IMPP3100 IM
			 left JOIN ',@INTERID,'.DBO.IMPP0161 PV  ON PV.PV_MI_idprov=IM.open3_pd
			 LEFT JOIN ',@INTERID,'.DBO.PM20000 PMT ON IM.IMP_nc_open3_numdocd=PMT.DOCNUMBR AND PMT.VENDORID=IM.open3_pd
			 LEFT JOIN ',@INTERID,'.DBO.PM30200 PMH ON IM.IMP_nc_open3_numdocd=PMH.DOCNUMBR AND PMH.VENDORID=IM.open3_pd
			   WHERE PV.PV_MI_rif000 = @RIF
				 AND IMP_nc_open3_numdocd = @DOCUMENTO')

   SET @Parametro = N'@RIF NVARCHAR(12),@DOCUMENTO		VARCHAR(25)';  
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
						 @RIF=@RIF,@DOCUMENTO=@DOCUMENTO;
  --TRABAJO ASOCIADO--
	SET @SQLSTR=CONCAT(' INSERT INTO ##DETALLE
				SELECT	 IMP_nc_open3_rif000	RIF
						,IMP_nc_open3_fecdoc	FECHADOC
						,IMP_nc_open3_numfac	NUMFACTURA
						,IMP_nc_open3_ncontro	NUMCONTROL
						,IMP_nc_open3_numnd		NUMNTD
						,IMP_nc_open3_numnc		NUMNTC
						,IMP_nc_open3_detimp	DETIMP
						,IMP_nc_open3_basimp	BASEIMP
						,IMP_nc_open3_porimp	ALICUOTA
						,IMP_nc_open3_monimp	ISLRRETENIDO
						,ISNULL(PMT.DOCAMNT,PMH.DOCAMNT)			MONTOPAGADO
						,IMP_nc_open3_numdoc	NUMDOC
						,IMP_nc_open3_nopera	NUMOPERA
						,IMP_nc_open3_numfaf	FACTURAAFEC
						,IMP_nc_open3_status	ESTATUS
						,IMP_nc_open3_tiptra	TIPOTRX
						,IM.open3_p				VENDORID
				FROM ',@INTERID,'.DBO.IMPP3000 IM
			 left JOIN ',@INTERID,'.DBO.IMPP0161 PV  ON PV.PV_MI_idprov=IM.open3_p
			 LEFT JOIN ',@INTERID,'.DBO.PM20000 PMT ON IM.IMP_nc_open3_numdoc=PMT.DOCNUMBR AND PMT.VENDORID=IM.open3_p
			 LEFT JOIN ',@INTERID,'.DBO.PM30200 PMH ON IM.IMP_nc_open3_numdoc=PMH.DOCNUMBR AND PMH.VENDORID=IM.open3_p
			   WHERE PV.PV_MI_rif000 = @RIF and IMP_nc_open3_numnd=''''
				 AND IMP_nc_open3_numfaf = @DOCUMENTO')

   SET @Parametro = N'@RIF NVARCHAR(12),@DOCUMENTO		VARCHAR(25)';  
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
						 @RIF=@RIF,@DOCUMENTO=@DOCUMENTO;
--NC ASOCIADAS
	SET @SQLSTR=CONCAT(' INSERT INTO ##DETALLE
				SELECT	 IMP_nc_open3_rif000d	RIF
						,IMP_nc_open3_fecdocd	FECHADOC
						,IMP_nc_open3_numfacd	NUMFACTURA
						,IMP_nc_open3_ncontrod	NUMCONTROL
						,IMP_nc_open3_numndd		NUMNTD
						,IMP_nc_open3_numncd		NUMNTC
						,IMP_nc_open3_detimpd	DETIMP
						,IMP_nc_open3_basimpd	BASEIMP
						,IMP_nc_open3_porimpd	ALICUOTA
						,IMP_nc_open3_monimpd	ISLRRETENIDO
						,ISNULL(PMT.DOCAMNT,PMH.DOCAMNT)			MONTOPAGADO
						,IMP_nc_open3_numdocd	NUMDOC
						,IMP_nc_open3_noperad	NUMOPERA
						,IMP_nc_open3_numfafd	FACTURAAFEC
						,IMP_nc_open3_statusd	ESTATUS
						,IMP_nc_open3_tiptrad	TIPOTRX
						,IM.open3_pd				VENDORID
				FROM ',@INTERID,'.DBO.IMPP3100 IM
			 left JOIN ',@INTERID,'.DBO.IMPP0161 PV  ON PV.PV_MI_idprov=IM.open3_pd
			 LEFT JOIN ',@INTERID,'.DBO.PM20000 PMT ON IM.IMP_nc_open3_numdocd=PMT.DOCNUMBR AND PMT.VENDORID=IM.open3_pd
			 LEFT JOIN ',@INTERID,'.DBO.PM30200 PMH ON IM.IMP_nc_open3_numdocd=PMH.DOCNUMBR AND PMH.VENDORID=IM.open3_pd
			   WHERE PV.PV_MI_rif000 = @RIF
				 AND IMP_nc_open3_numfafd = @DOCUMENTO')

   SET @Parametro = N'@RIF NVARCHAR(12),@DOCUMENTO		VARCHAR(25)';  
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
						 @RIF=@RIF,@DOCUMENTO=@DOCUMENTO;
  --HISTORICO--
	SET @SQLSTR=CONCAT(' INSERT INTO ##DETALLE
				SELECT	 IMP_nc_hist3_rif000	RIF
						,IMP_nc_hist3_fecdoc	FECHADOC
						,IMP_nc_hist3_numfac	NUMFACTURA
						,IMP_nc_hist3_ncontro	NUMCONTROL
						,IMP_nc_hist3_numnd		NUMNTD
						,IMP_nc_hist3_numnc		NUMNTC
						,IMP_nc_hist3_detimp	DETIMP
						,IMP_nc_hist3_basimp	BASEIMP
						,IMP_nc_hist3_porimp	ALICUOTA
						,IMP_nc_hist3_monimp	ISLRRETENIDO
						,ISNULL(PMT.DOCAMNT,PMH.DOCAMNT)			MONTOPAGADO
						,IMP_nc_hist3_numdoc	NUMDOC
						,IMP_nc_hist3_nopera	NROPERA
						,IMP_nc_hist3_numfaf	FACTURAAFEC
						,IMP_nc_hist3_status	ESTATUS
						,IMP_nc_hist3_tiptra	TIPOTRX
						,IM.HIST3_p				VENDORID
				FROM ',@INTERID,'.DBO.IMPP3200 IM
			 left JOIN ',@INTERID,'.DBO.IMPP0161 PV  ON PV.PV_MI_idprov=IM.hist3_p
			 LEFT JOIN ',@INTERID,'.DBO.PM20000 PMT ON IM.IMP_nc_hist3_numdoc=PMT.DOCNUMBR AND PMT.VENDORID=IM.hist3_p
			 LEFT JOIN ',@INTERID,'.DBO.PM30200 PMH ON IM.IMP_nc_hist3_numdoc=PMH.DOCNUMBR AND PMH.VENDORID=IM.hist3_p
			   WHERE PV.PV_MI_rif000 = @RIF
				 AND IMP_nc_hist3_numdoc = @DOCUMENTO')

   SET @Parametro = N'@RIF NVARCHAR(12),@DOCUMENTO		VARCHAR(25)';  
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
						 @RIF=@RIF,@DOCUMENTO=@DOCUMENTO;

 --HISTORICO AFECTA--
	SET @SQLSTR=CONCAT(' INSERT INTO ##DETALLE
				SELECT	 IMP_nc_hist3_rif000	RIF
						,IMP_nc_hist3_fecdoc	FECHADOC
						,IMP_nc_hist3_numfac	NUMFACTURA
						,IMP_nc_hist3_ncontro	NUMCONTROL
						,IMP_nc_hist3_numnd		NUMNTD
						,IMP_nc_hist3_numnc		NUMNTC
						,IMP_nc_hist3_detimp	DETIMP
						,IMP_nc_hist3_basimp	BASEIMP
						,IMP_nc_hist3_porimp	ALICUOTA
						,IMP_nc_hist3_monimp	ISLRRETENIDO
						,ISNULL(PMT.DOCAMNT,PMH.DOCAMNT)			MONTOPAGADO
						,IMP_nc_hist3_numdoc	NUMDOC
						,IMP_nc_hist3_nopera	NROPERA
						,IMP_nc_hist3_numfaf	FACTURAAFEC
						,IMP_nc_hist3_status	ESTATUS
						,IMP_nc_hist3_tiptra	TIPOTRX
						,IM.HIST3_p				VENDORID
				FROM ',@INTERID,'.DBO.IMPP3200 IM
			 left JOIN ',@INTERID,'.DBO.IMPP0161 PV  ON PV.PV_MI_idprov=IM.hist3_p
			 LEFT JOIN ',@INTERID,'.DBO.PM20000 PMT ON IM.IMP_nc_hist3_numdoc=PMT.DOCNUMBR AND PMT.VENDORID=IM.hist3_p
			 LEFT JOIN ',@INTERID,'.DBO.PM30200 PMH ON IM.IMP_nc_hist3_numdoc=PMH.DOCNUMBR AND PMH.VENDORID=IM.hist3_p
			   WHERE PV.PV_MI_rif000 = @RIF and IMP_nc_hist3_numnd=''''
				 AND IMP_nc_hist3_numfaf = @DOCUMENTO')

   SET @Parametro = N'@RIF NVARCHAR(12),@DOCUMENTO		VARCHAR(25)';  
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
						 @RIF=@RIF,@DOCUMENTO=@DOCUMENTO;
	

--SALIDA 
	SELECT  RIF						
		   ,FECHADOC					
		   ,NUMFACTURA					
		   ,NUMCONTROL					
		   ,NUMNTD						
		   ,NUMNTC						
		   ,DETIMP						
		   ,IIF(NUMNTC='',ABS(BASEIMP		),ABS(BASEIMP		)*-1) BASEIMP					
		   ,ABS(ALICUOTA		) ALICUOTA					
		   ,IIF(NUMNTC='',ABS(ISLRRETENIDO	),ABS(ISLRRETENIDO	)*-1) ISLRRETENIDO				
		   ,IIF(NUMNTC='',ABS(MONTOPAGADO	),ABS(MONTOPAGADO	)*-1) MONTOPAGADO				
		   ,NUMDOC						
		   ,NUMOPERA					
		   ,FACTURAAFEC				
		   ,ESTATUS					
		   ,TIPOTRX					
		   ,VENDORID
	  FROM ##DETALLE

SET NOCOUNT OFF;
END

/*

EXEC PL_WEB_RetISLRDetVOG_S 
		 @RIF			='V036248161'
		 ,@DOCUMENTO ='002316'
		 ,@interid   ='ALIB5'
		 */