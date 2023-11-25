using Controller;
using Controller.Login;
using Entities;
using Entities.System;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Threading.Tasks;

namespace WebConsultaRetenciones
{
	public partial class CambioClave : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{
			if (!IsPostBack)
			{
				rifusuario.Text = Request["rif"];
				validacliente();
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
					//
				}

			}
		}

		protected void btnActualiza_Click(object sender, EventArgs e)
		{
			ActualizaCliente();
		}

		private void ActualizaCliente() {
			if (clave.Text != reclave.Text)
			{
				Muestramensaje("error", "Las Contraseñas no Coinciden.");
			}
			else
			{
				cLoginActualizaPSW contrasena = new cLoginActualizaPSW();
				msjRespuesta vrespuesta = new msjRespuesta();
				vrespuesta = contrasena.ActualizaPassword(rifusuario.Text, clave.Text, "0");//cambio de clave
				if (vrespuesta.sError=="0") {
					Muestramensaje("success", "Clave Actualizada. Inicie Sesion.");
				}
				else
				{
					Muestramensaje("error", vrespuesta.Mensaje);
				}
				
			}
		}

		private void Muestramensaje(string tipo, string Mensaje)
		{
			string script = $"ShowMensaje('{tipo}','{Mensaje}'); ";
			ClientScript.RegisterStartupScript(this.GetType(), "ShowMensaje", script, true);
		}
	}
}