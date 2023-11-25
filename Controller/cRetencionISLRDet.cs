using DataAccess;
using Entities;
using System.Collections.Generic;

namespace Controller
{
	public class cRetencionISLRDet
	{
		public List<eRetencionISLRDet> BuscarRetencionISLRDet(eFiltroDocumentos filtroDoc)
		{
			List<eRetencionISLRDet> detalle = new List<eRetencionISLRDet>();
			dRetencionISLRDet dDetalle = new dRetencionISLRDet();
			detalle = dDetalle.BuscarRetencionISLRDet(filtroDoc);
			return detalle;
		}
	}
}
