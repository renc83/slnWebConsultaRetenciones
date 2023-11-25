using Controller.Login;
using Entities.System;
using System;

namespace WebConsultaRetenciones
{
	public partial class Login : System.Web.UI.Page
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
			if (String.IsNullOrEmpty(rifusuario.Text) || String.IsNullOrEmpty(clave.Text))
			{
				Muestramensaje("error", "Credenciales Incorrectas");
			}
			else
			{
				cLoginValidaSesion Sesion = new cLoginValidaSesion();
				int respuesta = Sesion.ValidaSesion(rifusuario.Text, clave.Text);
				if (respuesta == 1)
				{
					if (SesionUsuario.estatus == 0 || SesionUsuario.flg_cambioclave == 1)
					{
						if (SesionUsuario.flg_cambioclave == 1)
						{
							string URL = $"./CambioClave.aspx?rif={rifusuario.Text}";
							Response.Redirect(URL, true);
						}
						else
						{
							Session.Add("Usuario", SesionUsuario.idusuario);
							Session.Add("IDPerfil", SesionUsuario.idperfil);
							Session.Add("Perfil", SesionUsuario.perfil);
							Session.Add("NombreUsuario", SesionUsuario.nombreusuario);
							Muestramensaje("success", "Usuario Logeado Correctamente");
							Response.Redirect("/Modulos/pgSeleccionEmpresa.aspx", true);
						}
					}
					else {
						Muestramensaje("error", "Usuario Inactivo, Contactar a Soporte Tecnico.");
					}
				}
				else
				{
					//txtRespuesta.Text = ($"{rifusuario.Text} , {clave.Text}");
					Muestramensaje("error","Credenciales Incorrectas");
				}
			}
        }

		private void Muestramensaje(string tipo,string Mensaje) {
			string script = $"ShowMensaje('{tipo}','{Mensaje}'); ";
			ClientScript.RegisterStartupScript(this.GetType(), "ShowMensaje", script, true);
		}

		protected void rifusuario_TextChanged(object sender, EventArgs e)
		{
			//link1.HRef = String.Format("LeadInformation.aspx?refNo={0}",rifusuario.Text);
			//link1.InnerHtml = "My link";
			//LinkCliente(rifusuario.Text);
		}

		private void LinkCliente(string rif)
		{
			string script = $"LinkClientePassword('{rif}'); ";
			ClientScript.RegisterStartupScript(this.GetType(), "LinkClientePassword", script, true);
		}

		protected void btnRecupera_Click(object sender, EventArgs e)
		{
			if (String.IsNullOrEmpty(rifusuario.Text)) {
				Muestramensaje("error", "Ingrese Rif Cliente");
			}
			else {
				string URL = $"./RecuperarPassword.aspx?rif={rifusuario.Text}";
				Response.Redirect(URL, true);
			}
			
			// < a href = "RecuperarPassword.aspx?rif=" >¿Olvidaste la Contraseña ?</ a >
		}
	}
}