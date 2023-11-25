using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using Controller;
using Entities;

namespace WebConsultaRetenciones.Servicios
{
	/// <summary>
	/// Descripción breve de sUsuarios
	/// </summary>
	[WebService(Namespace = "http://tempuri.org/")]
	[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
	[System.ComponentModel.ToolboxItem(false)]
	// Para permitir que se llame a este servicio web desde un script, usando ASP.NET AJAX, quite la marca de comentario de la línea siguiente. 
	[System.Web.Script.Services.ScriptService]
	public class sUsuarios : System.Web.Services.WebService
	{

		[WebMethod]
		public List<eEmpresa> BuscaEmpresasRif(string RIF)
		{
			List<eEmpresa> ListEmpresas = new List<eEmpresa>();
			cEmpresaBusca cEmpresa = new cEmpresaBusca();
			ListEmpresas = cEmpresa.BuscaEmpresasRif(RIF);
			return ListEmpresas;
		}
	}
}
