/*====================================================================
Author: Rafael Niño
Create date: 07/07/2023
Description SP: Busca Usuarios App Web de consultas de Retenciones
Cliente: GENERAL
Tablas: WEBUSERS_VOG  - USUARIO APP WEB
SP Asociados: 
Ejemplo:
EXEC PL_WEB_RetIvaDetVOG_S 
		 @RIF		 ='V123917967'
		 ,@DOCUMENTO ='00517'
		 ,@interid   ='ALIB5'
Cambios en tablas:
=======================================================================*/
USE DYNAMICS;
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[PL_WEB_RetIvaDetVOG_S]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].PL_WEB_RetIvaDetVOG_S
go
CREATE PROCEDURE PL_WEB_RetIvaDetVOG_S
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
numope						SMALLINT
,RIF						VARCHAR(11)
,FECHADOC					DATE
,NUMFACTURA					VARCHAR(21)
,NUMCONTROL					VARCHAR(31)
,NUMNTD						VARCHAR(21)
,NUMNTC						VARCHAR(21)
,TIPOTRANS					VARCHAR(9)
,FACAFEC					VARCHAR(21)
,COCIVA						NUMERIC(19,5)
,COSIVA						NUMERIC(19,5)
,IMP_basimp_alicgene		NUMERIC(19,5)
,IMP_porceimp_alicgene		NUMERIC(19,5)
,IMP_montoimp_alicgene		NUMERIC(19,5)
,IMP_basimp_alicreduc		NUMERIC(19,5)
,IMP_porceimp_alicreduc		NUMERIC(19,5)
,IMP_montoimp_alicreduc		NUMERIC(19,5)
,IMP_basimp_alicadic		NUMERIC(19,5)
,IMP_porceimp_alicadic		NUMERIC(19,5)
,IMP_montoimp_alicadic		NUMERIC(19,5)
,alicuota					NUMERIC(19,5)
,IVARET						NUMERIC(19,5)
)


  --TRABAJO--
	SET @SQLSTR=CONCAT(' INSERT INTO ##DETALLE
					SELECT	IMP_nc_open_numope     numope
						,IMP_nc_open_rif000	   RIF
						,IMP_nc_open_fecdoc		FECHADOC
						,IMP_nc_open_numfac		NUMFACTURA
						,IMP_nc_open_ncontro	NUMCONTROL
						,IMP_nc_open_numntd		NUMNTD
						,IMP_nc_open_numntc		NUMNTC
						,CASE
							WHEN IMP_nc_open_tiptra = 1 THEN ''01-Reg''
							WHEN IMP_nc_open_tiptra = 2 THEN ''02-Comp''
							WHEN IMP_nc_open_tiptra = 3 THEN ''03-Anul''
							ELSE ''04-Ajuste'' END TIPOTRANS
						,IMP_nc_open_facafe		 FACAFEC
						,IIF(IMP_nc_open_tipdoc = 4, IMP_nc_open_cociva * -1, IMP_nc_open_cociva) COCIVA
						,IMP_nc_open_cosiva														  COSIVA
						,IIF(IMP_nc_open_tipdoc = 4, IMP_basimp_alicgene * -1, IMP_basimp_alicgene) IMP_basimp_alicgene 
						,IMP_porceimp_alicgene
						,IIF(IMP_nc_open_tipdoc = 4, IMP_montoimp_alicgene * -1, IMP_montoimp_alicgene) IMP_montoimp_alicgene  
						,IIF(IMP_nc_open_tipdoc = 4, IMP_basimp_alicreduc * -1, IMP_basimp_alicreduc) IMP_basimp_alicreduc
						,IMP_porceimp_alicreduc
						,IIF(IMP_nc_open_tipdoc = 4, IMP_montoimp_alicreduc * -1, IMP_montoimp_alicreduc) IMP_montoimp_alicreduc
						,IIF(IMP_nc_open_tipdoc = 4, IMP_basimp_alicadic * -1, IMP_basimp_alicadic) IMP_basimp_alicadic
						,IMP_porceimp_alicadic
						,IIF(IMP_nc_open_tipdoc = 4, IMP_montoimp_alicadic * -1, IMP_montoimp_alicadic) IMP_montoimp_alicadic
						,CASE
							WHEN IMP_porcrete_alicgene  != 0 THEN ABS(IMP_porcrete_alicgene)
							WHEN IMP_porcrete_alicreduc != 0 THEN ABS(IMP_porcrete_alicreduc)
							ELSE ABS(IMP_porcrete_alicadic) END AS alicuota
						,IMP_nc_open_ivaret  IVARET
				FROM ',@INTERID,'.DBO.IMPP2001	I
			   INNER JOIN ',@INTERID,'.DBO.IMPP0161 P ON P.PV_MI_idprov=I.open_p
			   WHERE P.PV_MI_rif000 = @RIF
				 AND IMP_nc_open_docnum = @DOCUMENTO')

   SET @Parametro = N'@RIF NVARCHAR(12),@DOCUMENTO		VARCHAR(25)';  
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
						 @RIF=@RIF,@DOCUMENTO=@DOCUMENTO;
  --TRABAJO AFECTADO--
	SET @SQLSTR=CONCAT(' INSERT INTO ##DETALLE
					SELECT	IMP_nc_open_numope     numope
						,IMP_nc_open_rif000	   RIF
						,IMP_nc_open_fecdoc		FECHADOC
						,IMP_nc_open_numfac		NUMFACTURA
						,IMP_nc_open_ncontro	NUMCONTROL
						,IMP_nc_open_numntd		NUMNTD
						,IMP_nc_open_numntc		NUMNTC
						,CASE
							WHEN IMP_nc_open_tiptra = 1 THEN ''01-Reg''
							WHEN IMP_nc_open_tiptra = 2 THEN ''02-Comp''
							WHEN IMP_nc_open_tiptra = 3 THEN ''03-Anul''
							ELSE ''04-Ajuste'' END TIPOTRANS
						,IMP_nc_open_facafe		 FACAFEC
						,IIF(IMP_nc_open_tipdoc = 4, IMP_nc_open_cociva * -1, IMP_nc_open_cociva) COCIVA
						,IMP_nc_open_cosiva														  COSIVA
						,IIF(IMP_nc_open_tipdoc = 4, IMP_basimp_alicgene * -1, IMP_basimp_alicgene) IMP_basimp_alicgene 
						,IMP_porceimp_alicgene
						,IIF(IMP_nc_open_tipdoc = 4, IMP_montoimp_alicgene * -1, IMP_montoimp_alicgene) IMP_montoimp_alicgene  
						,IIF(IMP_nc_open_tipdoc = 4, IMP_basimp_alicreduc * -1, IMP_basimp_alicreduc) IMP_basimp_alicreduc
						,IMP_porceimp_alicreduc
						,IIF(IMP_nc_open_tipdoc = 4, IMP_montoimp_alicreduc * -1, IMP_montoimp_alicreduc) IMP_montoimp_alicreduc
						,IIF(IMP_nc_open_tipdoc = 4, IMP_basimp_alicadic * -1, IMP_basimp_alicadic) IMP_basimp_alicadic
						,IMP_porceimp_alicadic
						,IIF(IMP_nc_open_tipdoc = 4, IMP_montoimp_alicadic * -1, IMP_montoimp_alicadic) IMP_montoimp_alicadic
						,CASE
							WHEN IMP_porcrete_alicgene  != 0 THEN ABS(IMP_porcrete_alicgene)
							WHEN IMP_porcrete_alicreduc != 0 THEN ABS(IMP_porcrete_alicreduc)
							ELSE ABS(IMP_porcrete_alicadic) END AS alicuota
						,IMP_nc_open_ivaret  IVARET
				FROM ',@INTERID,'.DBO.IMPP2001	I
			   INNER JOIN ',@INTERID,'.DBO.IMPP0161 P ON P.PV_MI_idprov=I.open_p
			   WHERE P.PV_MI_rif000 = @RIF and I.IMP_nc_open_numntd=''''
				 AND IMP_nc_open_facafe = @DOCUMENTO')

   SET @Parametro = N'@RIF NVARCHAR(12),@DOCUMENTO		VARCHAR(25)';  
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
						 @RIF=@RIF,@DOCUMENTO=@DOCUMENTO;
  --HISTORICO--
	SET @SQLSTR=CONCAT(' INSERT INTO ##DETALLE
					SELECT	 IMP_nc_hist_numope     numope
							,IMP_nc_hist_rif000	   RIF
							,IMP_nc_hist_fecdoc		FECHADOC
							,IMP_nc_hist_numfac		NUMFACTURA
							,IMP_nc_hist_ncontro	NUMCONTROL
							,IMP_nc_hist_numntd		NUMNTD
							,IMP_nc_hist_numntc		NUMNTC
						,CASE
							WHEN IMP_nc_hist_tiptra = 1 THEN ''01-Reg''
							WHEN IMP_nc_hist_tiptra = 2 THEN ''02-Comp''
							WHEN IMP_nc_hist_tiptra = 3 THEN ''03-Anul''
							ELSE ''04-Ajuste'' END TIPOTRANS
						,IMP_nc_hist_facafe		 FACAFEC
						,IIF(IMP_nc_hist_tipdoc = 4, IMP_nc_hist_cociva * -1, IMP_nc_hist_cociva) COCIVA
						,IMP_nc_hist_cosiva														  COSIVA
						,IIF(IMP_nc_hist_tipdoc = 4, IMP_basimp_alicgene * -1, IMP_basimp_alicgene) IMP_basimp_alicgene 
						,IMP_porceimp_alicgene
						,IIF(IMP_nc_hist_tipdoc = 4, IMP_montoimp_alicgene * -1, IMP_montoimp_alicgene) IMP_montoimp_alicgene  
						,IIF(IMP_nc_hist_tipdoc = 4, IMP_basimp_alicreduc * -1, IMP_basimp_alicreduc) IMP_basimp_alicreduc
						,IMP_porceimp_alicreduc
						,IIF(IMP_nc_hist_tipdoc = 4, IMP_montoimp_alicreduc * -1, IMP_montoimp_alicreduc) IMP_montoimp_alicreduc
						,IIF(IMP_nc_hist_tipdoc = 4, IMP_basimp_alicadic * -1, IMP_basimp_alicadic) IMP_basimp_alicadic
						,IMP_porceimp_alicadic
						,IIF(IMP_nc_hist_tipdoc = 4, IMP_montoimp_alicadic * -1, IMP_montoimp_alicadic) IMP_montoimp_alicadic
						,CASE
							WHEN IMP_porcrete_alicgene  != 0 THEN ABS(IMP_porcrete_alicgene)
							WHEN IMP_porcrete_alicreduc != 0 THEN ABS(IMP_porcrete_alicreduc)
							ELSE ABS(IMP_porcrete_alicadic) END AS alicuota
						,IMP_nc_hist_ivaret  IVARET
				FROM ',@INTERID,'.DBO.IMPP2201	I
			   INNER JOIN ',@INTERID,'.DBO.IMPP0161 P ON P.PV_MI_idprov=I.hist_p
			   WHERE P.PV_MI_rif000 = @RIF
				 AND IMP_nc_hist_docnum = @DOCUMENTO')

   SET @Parametro = N'@RIF NVARCHAR(12),@DOCUMENTO		VARCHAR(25)';  
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
						 @RIF=@RIF,@DOCUMENTO=@DOCUMENTO;

						   --HISTORICO--
	SET @SQLSTR=CONCAT(' INSERT INTO ##DETALLE
					SELECT	 IMP_nc_hist_numope     numope
							,IMP_nc_hist_rif000	   RIF
							,IMP_nc_hist_fecdoc		FECHADOC
							,IMP_nc_hist_numfac		NUMFACTURA
							,IMP_nc_hist_ncontro	NUMCONTROL
							,IMP_nc_hist_numntd		NUMNTD
							,IMP_nc_hist_numntc		NUMNTC
						,CASE
							WHEN IMP_nc_hist_tiptra = 1 THEN ''01-Reg''
							WHEN IMP_nc_hist_tiptra = 2 THEN ''02-Comp''
							WHEN IMP_nc_hist_tiptra = 3 THEN ''03-Anul''
							ELSE ''04-Ajuste'' END TIPOTRANS
						,IMP_nc_hist_facafe		 FACAFEC
						,IIF(IMP_nc_hist_tipdoc = 4, IMP_nc_hist_cociva * -1, IMP_nc_hist_cociva) COCIVA
						,IMP_nc_hist_cosiva														  COSIVA
						,IIF(IMP_nc_hist_tipdoc = 4, IMP_basimp_alicgene * -1, IMP_basimp_alicgene) IMP_basimp_alicgene 
						,IMP_porceimp_alicgene
						,IIF(IMP_nc_hist_tipdoc = 4, IMP_montoimp_alicgene * -1, IMP_montoimp_alicgene) IMP_montoimp_alicgene  
						,IIF(IMP_nc_hist_tipdoc = 4, IMP_basimp_alicreduc * -1, IMP_basimp_alicreduc) IMP_basimp_alicreduc
						,IMP_porceimp_alicreduc
						,IIF(IMP_nc_hist_tipdoc = 4, IMP_montoimp_alicreduc * -1, IMP_montoimp_alicreduc) IMP_montoimp_alicreduc
						,IIF(IMP_nc_hist_tipdoc = 4, IMP_basimp_alicadic * -1, IMP_basimp_alicadic) IMP_basimp_alicadic
						,IMP_porceimp_alicadic
						,IIF(IMP_nc_hist_tipdoc = 4, IMP_montoimp_alicadic * -1, IMP_montoimp_alicadic) IMP_montoimp_alicadic
						,CASE
							WHEN IMP_porcrete_alicgene  != 0 THEN ABS(IMP_porcrete_alicgene)
							WHEN IMP_porcrete_alicreduc != 0 THEN ABS(IMP_porcrete_alicreduc)
							ELSE ABS(IMP_porcrete_alicadic) END AS alicuota
						,IMP_nc_hist_ivaret  IVARET
				FROM ',@INTERID,'.DBO.IMPP2201 I
			   INNER JOIN ',@INTERID,'.DBO.IMPP0161 P ON P.PV_MI_idprov=I.hist_p
			   WHERE P.PV_MI_rif000 = @RIF and IMP_nc_hist_numntd=''''
				 AND IMP_nc_hist_facafe = @DOCUMENTO')

   SET @Parametro = N'@RIF NVARCHAR(12),@DOCUMENTO		VARCHAR(25)';  
   EXECUTE sp_executesql @SQLSTR, @Parametro,  
						 @RIF=@RIF,@DOCUMENTO=@DOCUMENTO;
	SELECT  numope						
		   ,RIF						
		   ,FECHADOC					
		   ,NUMFACTURA					
		   ,NUMCONTROL					
		   ,NUMNTD						
		   ,NUMNTC						
		   ,TIPOTRANS					
		   ,FACAFEC					
		   ,COCIVA						
		   ,COSIVA						
		   ,IIF(NUMNTC='',abs(IMP_basimp_alicgene	),-1*abs(IMP_basimp_alicgene	)) IMP_basimp_alicgene		
		   ,abs(IMP_porceimp_alicgene	) IMP_porceimp_alicgene		
		   ,IIF(NUMNTC='',abs(IMP_montoimp_alicgene	),-1*abs(IMP_montoimp_alicgene	)) IMP_montoimp_alicgene		
		   ,IIF(NUMNTC='',abs(IMP_basimp_alicreduc	),-1*abs(IMP_basimp_alicreduc	)) IMP_basimp_alicreduc		
		   ,abs(IMP_porceimp_alicreduc) IMP_porceimp_alicreduc		
		   ,IIF(NUMNTC='',abs(IMP_montoimp_alicreduc),-1*abs(IMP_montoimp_alicreduc	)) IMP_montoimp_alicreduc		
		   ,IIF(NUMNTC='',abs(IMP_basimp_alicadic	),-1*abs(IMP_basimp_alicadic	)) IMP_basimp_alicadic		
		   ,abs(IMP_porceimp_alicadic	) IMP_porceimp_alicadic		
		   ,IIF(NUMNTC='',abs(IMP_montoimp_alicadic	),-1*abs(IMP_montoimp_alicadic	)) IMP_montoimp_alicadic		
		   ,abs(alicuota				) alicuota					
		   ,IIF(NUMNTC='',abs(IVARET)				 ,-1*abs(IVARET)				)		IVARET
	FROM ##DETALLE

SET NOCOUNT OFF;
END