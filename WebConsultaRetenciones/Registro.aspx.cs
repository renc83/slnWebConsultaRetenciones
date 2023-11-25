using Controller;
using Controller.Login;
using Entities;
using Entities.System;
using System;
using System.Collections.Generic;
using System.Configuration;

namespace WebConsultaRetenciones
{
	public partial class Registro : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{
				Session.Clear();
				Session.Abandon();
			}
		}

		protected void btnIngresa_Click(object sender, EventArgs e)
		{
			string clave = String.Concat(DateTime.Now.Minute.ToString(), DateTime.Now.Second.ToString(), DateTime.Now.Millisecond.ToString());
			if (String.IsNullOrEmpty(rifusuario.Text) || String.IsNullOrEmpty(nombreusuario.Text)) //|| String.IsNullOrEmpty(reclave.Text)
			{
				Muestramensaje("error", "Datos Incompletos");
			}
			//else if (clave.Text!=reclave.Text) {
			//	Muestramensaje("error", "Contraseñas no Coincide");
			//}
			else
			{ //valida si existe
				cLoginValidaSesion Sesion = new cLoginValidaSesion();
				int respuesta = Sesion.ValidaSesion(rifusuario.Text, clave);
				if (!String.IsNullOrEmpty(SesionUsuario.idusuario))
				{
					Muestramensaje("error", "Usuario ya se encuentra Registrado");
				}
				else {
					List<eEmpresa> ListEmpresas = new List<eEmpresa>();
					cEmpresaBusca cEmpresa = new cEmpresaBusca();
					ListEmpresas = cEmpresa.BuscaEmpresasRif(rifusuario.Text);
					if (ListEmpresas.Count < 1)
					{
						Muestramensaje("error", "RIF No existe en nuestra empresa.");
					}
					else {
						string InterID = ListEmpresas[0].INTERID;
						string sCorreo = ListEmpresas[0].CORREO;						
						//crea el registro
						cLoginRegistro registra = new cLoginRegistro();
						msjRespuesta vRespuesta = new msjRespuesta();
						vRespuesta = registra.RegistrarUsuario(rifusuario.Text, clave, InterID);
						if (vRespuesta.sError == "0")
						{
							if (String.IsNullOrEmpty(sCorreo))
							{
								Muestramensaje("error", "No posee Correo Registrado, Se envia a Soporte.");
								sCorreo = ConfigurationManager.AppSettings.Get("CorreoSoporte");
							}
							EnviaCorreo(sCorreo, clave);						
							Muestramensaje("success", "Usuario Creado Correctamente.");
							rifusuario.Text = "";
							nombreusuario.Text = "";
							//reclave.Text = "";
						}
						else {
							Muestramensaje("error", "Error Interno.");
						}						
						//Response.Redirect("Login.aspx", true);
					}

				}
			}
		}
		private void Muestramensaje(string tipo, string Mensaje)
		{
			string script = $"ShowMensaje('{tipo}','{Mensaje}'); ";
			ClientScript.RegisterStartupScript(this.GetType(), "ShowMensaje", script, true);
		}


		private void EnviaCorreo(string remitente, string clave)
		{
			//crea el registro
			cCorreoEnviar correo = new cCorreoEnviar();
			msjRespuesta vRespuesta = new msjRespuesta();
			vRespuesta = correo.EnviaCorreo(remitente, rifusuario.Text,nombreusuario.Text, clave);
			if (vRespuesta.sError == "0")
			{
				Muestramensaje("success", "Correo Enviado.");
				//Response.Redirect("Login.aspx", true);
			}
			else
			{
				Muestramensaje("error", "Error Interno.");
			}
		}
	}
}