/*====================================================================
Author: Rafael Niño
Create date: 07/07/2023
Description SP: Busca Usuarios App Web de consultas de Retenciones
Cliente: GENERAL
Tablas: WEBUSERS_VOG  - USUARIO APP WEB
SP Asociados: 
Ejemplo:
EXEC pr_SysSendMail_Cliente 
		 @CustomerNumber='rafael'
		 ,@CustomerName	=' cliente nombre'
		 ,@customermail	='ren'
		 ,@profile		='SQLMail'
		 ,@clave		='123456'	 




Cambios en tablas:
=======================================================================*/
USE DYNAMICS;
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[pr_SysSendMail_Cliente]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].pr_SysSendMail_Cliente
go
GO
CREATE PROCEDURE pr_SysSendMail_Cliente
(@CustomerNumber VARCHAR(50)
,@CustomerName	 VARCHAR(150)
,@customermail	 VARCHAR(150)
,@profile		 varchar(50)
,@clave			 varchar(100)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Subject VARCHAR(250);
	DECLARE @mensaje VARCHAR(MAX);
	DECLARE @header VARCHAR(MAX), @body VARCHAR(MAX), @footer VARCHAR(MAX), @LINEA VARCHAR(MAX)
	DECLARE @RECIPIENTS VARCHAR(100);
	DECLARE @MensajeR NVARCHAR(100)='Correo en Cola',@ERROR INT=0



	 set @Subject = 'Solicitud de Cambio de Contraseña: $CustomerName'

set @header='<div style="text-align: center;width: 80%;margin: 0 auto;border: 2px solid grey;background-color:white;">
	<section id="encabezado">		
			<div style="display: flex;flex-direction: column;">
				<strong>NOMBRE EMPRESA</strong>
			</div>
	</section>'

set @body='		<section id="cuerpo">
			<div style="text-align: center">
				<hr/>
				<p>Señores: <b>$CustomerNumber : $CustomerName </b> <br>
						Su Nueva clave de acceso es:,<br>
						<h1>$clave</h1><br>
						Con esta contraseña temporal podra hacer el cambio de su contraseña.<br>
				</p>
				<hr/>
			</div>
		</section>
	</div>'

set @footer='<section id="footer">
				<div>
					<div style="font-size:larger;">
						<div>
							Desarrollado por: <strong>Virtual Office Group </strong><br>
							<img src="https://www.vog365.com/wp-content/uploads/2022/06/Logo-text.png" width="50px" height="50px"
								style="align-content: center;">
						</div>
					</div>
				</div>
			</section>'
	 						

		SET @Body = REPLACE(@Body, '$CustomerNumber', @CustomerNumber);
		SET @Body = REPLACE(@Body, '$CustomerName', @CustomerName);
		SET @Body = REPLACE(@Body, '$clave', @clave);
		

		SET @Subject = REPLACE(@Subject, '$CustomerName',  @CustomerName);

		SET @RECIPIENTS =CONCAT(@customermail,';renc83@gmail.com');

		set @mensaje=CONCAT(@header,@body,@footer)

BEGIN TRY
		EXEC msdb.dbo.sp_send_dbmail @profile_name=@profile,
		@recipients= @RECIPIENTS,
		@subject= @Subject,
		@body= @mensaje,
		@body_format = 'HTML' ;
		

		
END TRY
BEGIN CATCH
			SET @MensajeR=ERROR_MESSAGE()
			SET @ERROR=ERROR_NUMBER()
END CATCH

		SELECT @MensajeR AS MENSAJE,@ERROR AS ERROR

END