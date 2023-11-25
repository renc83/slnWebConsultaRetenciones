using Controller;
using Controller.Login;
using Entities;
using Entities.System;
using Entities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Threading.Tasks;

namespace WebConsultaRetenciones
{
	public partial class RecuperarPassword : System.Web.UI.Page
	{
		cCorreoEnviar correo = new cCorreoEnviar();
		protected void Page_Load(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{
				rifusuario.Text = Request["rif"];
				validacliente();
				NombreSoporte();
			}
		}

		private void validacliente()
		{
			cLoginValidaSesion Sesion = new cLoginValidaSesion();
			int respuesta = Sesion.ValidaSesion(rifusuario.Text, "");
			if (String.IsNullOrEmpty(SesionUsuario.idusuario))
			{
				Muestramensaje("error", "Usuario no se encuentra Registrado");
			}
			else
			{
				List<eEmpresa> ListEmpresas = new List<eEmpresa>();
				cEmpresaBusca cEmpresa = new cEmpresaBusca();
				ListEmpresas = cEmpresa.BuscaEmpresasRif(rifusuario.Text);
				if (ListEmpresas.Count < 1)
				{
					Muestramensaje("error", "RIF No existe en nuestra empresa.");
				}
				else
				{
					string InterID = ListEmpresas[0].INTERID;
					string sCorreo = ListEmpresas[0].CORREO;
					correousuario.Text = sCorreo;
					nombreusuario.Text = SesionUsuario.nombreusuario;
					//btnCliente.Text = $"Resetear la Contraseña y enviarla por correo al correo:{correousuario.Text}";
					NombreCliente(correousuario.Text);
				}

			}
		}

		private void NombreCliente(string correo)
		{
			string script = $"NombreCliente('{correo}'); ";
			ClientScript.RegisterStartupScript(this.GetType(), "NombreCliente", script, true);
		}

		private void NombreSoporte()
		{
			string soporte = ConfigurationManager.AppSettings.Get("CorreoSoporte");
			string script = $"NombreSoporte('{soporte}'); ";
			ClientScript.RegisterStartupScript(this.GetType(), "NombreSoporte", script, true);
		}




		private void EnviaCorreo(string remitente,string clave) {
			//crea el registro
			msjRespuesta vRespuesta = new msjRespuesta();
			vRespuesta = correo.EnviaCorreo(remitente, rifusuario.Text, nombreusuario.Text,clave);
			if (vRespuesta.sError == "0")
			{
				Muestramensaje("success", "Correo Enviado Correctamente.");
				RemoveTaskAfterTime();
				Response.Redirect("Login.aspx", true);
			}
			else
			{
				Muestramensaje("error", "Error Interno.");
			}
		}

		private void CorreoCLiente()
		{
			string clave = String.Concat(DateTime.Now.Minute.ToString(), DateTime.Now.Second.ToString(), DateTime.Now.Millisecond.ToString());
			cLoginActualizaPSW contrasena = new cLoginActualizaPSW();
			msjRespuesta vrespuesta = new msjRespuesta();
			vrespuesta = contrasena.ActualizaPassword(rifusuario.Text, clave, "1");//cambio de clave
			EnviaCorreo(correousuario.Text,clave);
		}

		private void CorreoSoporte()
		{
			string soporte = ConfigurationManager.AppSettings.Get("CorreoSoporte");
			string clave = String.Concat(DateTime.Now.Minute.ToString(), DateTime.Now.Second.ToString(), DateTime.Now.Millisecond.ToString());
			cLoginActualizaPSW contrasena = new cLoginActualizaPSW();
			msjRespuesta vrespuesta = new msjRespuesta();
			vrespuesta = contrasena.ActualizaPassword(rifusuario.Text, clave, "1");//cambio de clave
			EnviaCorreo(soporte,clave);
		}





		private void Muestramensaje(string tipo, string Mensaje)
		{
			string script = $"ShowMensaje('{tipo}','{Mensaje}'); ";
			ClientScript.RegisterStartupScript(this.GetType(), "ShowMensaje", script, true);
		}
		private async Task RemoveTaskAfterTime()
		{
			await Task.Delay(2000);
		}



		protected void btnCliente_Click(object sender, EventArgs e)
		{
			CorreoCLiente();
		}

		protected void btnSoporte_Click(object sender, EventArgs e)
		{
			CorreoSoporte();
		}
	}
}