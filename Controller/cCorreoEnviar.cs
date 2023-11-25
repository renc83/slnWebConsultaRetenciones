using Entities;
using Entities.System;
using DataAccess;
using System;
using System.Configuration;

namespace Controller
{
	public class cCorreoEnviar
	{
		public msjRespuesta EnviaCorreo(string remitente,string rif,string cliente, string clave)
		{
			msjRespuesta respuesta=new msjRespuesta();
			string strTipo=ConfigurationManager.AppSettings.Get("TipoCorreo");

			if (strTipo == "SQL")
			{
				dCorreoSQL correo=new dCorreoSQL();				
				respuesta=correo.EnviaCorreoSQL(remitente,  rif,  cliente,clave);
			}
			else if (strTipo == "SMTP")
			{
				dCorreoSMTP correo=new dCorreoSMTP();
				SMTPData confCorreo=new SMTPData();
				confCorreo.Server= ConfigurationManager.AppSettings.Get("SMTPServer");
				confCorreo.Username=ConfigurationManager.AppSettings.Get("SMTPUsername");
				confCorreo.Password=ConfigurationManager.AppSettings.Get("SMTPPassword");
				confCorreo.Port =Convert.ToInt32(ConfigurationManager.AppSettings.Get("SMTPPort"));
				confCorreo.RemitenteText=ConfigurationManager.AppSettings.Get("SMTPRemitenteText");

				string mensaje=PreparaMensajeSMTP(remitente, rif, cliente, clave);
				string asunto=$"Solicitud de Cambio de Contraseña: {cliente}";
				bool flgCorreo=correo.sendMail(remitente, asunto, mensaje,"", confCorreo);
				if (flgCorreo)
				{
					respuesta.sError="0";
					respuesta.Mensaje="Correo Enviado";
				}
				else
				{
					respuesta.sError="1";
					respuesta.Mensaje="Error Envio Correo";
				}
			}
			else { 
				//no hizo nada
			}
			return respuesta;
		}

		internal string PreparaMensajeSMTP(string remitente, string rif, string cliente, string clave) {
			string BodyMail="";

			BodyMail=$"<div style='text-align: center;width: 80%;margin: 0 auto;border: 2px solid grey;background-color:white;'>" +
					  "<section id='encabezado'>" +
			 "<div style ='display: flex;flex-direction: column;'>" +
			"<strong> NOMBRE EMPRESA </strong></div></section>";
			BodyMail += "<section id='cuerpo'><div style='text-align: center'><hr/>" +
			$"<p> Señores: <b>{rif}: {cliente}</b><br>Su Nueva clave de acceso es:,<br>" +
			$"<h1>{clave}</h1><br>Con esta contraseña temporal podra hacer el cambio de su contraseña.<br></p><hr/></div></section></div>";
			BodyMail += "<section id='footer'><div><div style=font-size:larger;><div>" +
				"Desarrollado por: <strong> Virtual Office Group</strong><br>" +
				"<img src='https://www.vog365.com/wp-content/uploads/2022/06/Logo-text.png' width='50px' height='50px' "+
				"style='align-content: center;'></div></div></div></section>";

			return BodyMail;
		}
	}
}
