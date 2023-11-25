using DataAccess;
using Entities;
using System.Collections.Generic;

namespace Controller
{
	public class cRetencionIvaDet
	{
		public List<eRetencionIvaDet> BuscarRetencionIvaDet(eFiltroDocumentos filtroDoc)
		{
			List<eRetencionIvaDet> detalle = new List<eRetencionIvaDet>();
			dRetencionIvaDet dDetalle = new dRetencionIvaDet();
			detalle = dDetalle.BuscarRetencionIvaDet(filtroDoc);
			return detalle;
		}
	}
}
