using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebConsultaRetenciones.Modulos
{
	public partial class pgSeleccionEmpresa : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{
            if (Session["Usuario"] == null)
            {
                Response.Redirect("../login.aspx");
            }
            if (Request.QueryString["Usuario"] == null) { return; }

            
        }
        public String F_Usuario()
        {
            var nombre = Session["Usuario"].ToString();
            return nombre;
        }
        public String F_Nombre_Usuario()
        {
            var nombre = Session["NombreUsuario"].ToString();
            return nombre;
        }

        private void BuscaEmpresasRif(string RIF)
        {
            string script = $"BuscaEmpresasRif('{RIF}'); ";
            ClientScript.RegisterStartupScript(this.GetType(), "BuscaEmpresasRif", script, true);
        }


    }
}