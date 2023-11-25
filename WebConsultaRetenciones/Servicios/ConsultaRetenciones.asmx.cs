using Controller;
using Entities;
using System.Collections.Generic;
using System.Web.Services;

namespace WebConsultaRetenciones.Servicios
{
	/// <summary>
	/// Descripción breve de ConsultaRetenciones
	/// </summary>
	[WebService(Namespace = "http://tempuri.org/")]
	[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
	[System.ComponentModel.ToolboxItem(false)]
	// Para permitir que se llame a este servicio web desde un script, usando ASP.NET AJAX, quite la marca de comentario de la línea siguiente. 
	[System.Web.Script.Services.ScriptService]
	public class ConsultaRetenciones : System.Web.Services.WebService
	{

		[WebMethod]
		public List<eDocumentos> ListadoRetenciones(eFiltroDocumentos filtrodocumento)
		{
			List<eDocumentos> documentos = new List<eDocumentos>();
			cListadoRetenciones listado = new cListadoRetenciones();
			documentos = listado.ListadoRetenciones(filtrodocumento);
			return documentos;
		}

	}
}
