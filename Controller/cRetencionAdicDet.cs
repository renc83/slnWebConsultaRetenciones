using DataAccess;
using Entities;
using System.Collections.Generic;

namespace Controller
{
	public class cRetencionAdicDet
	{
		public List<eRetencionAdicDet> BuscarRetencionAdicDet(eFiltroDocumentos filtroDoc)
		{
			List<eRetencionAdicDet> detalle = new List<eRetencionAdicDet>();
			dRetencionAdicDet dDetalle = new dRetencionAdicDet();
			detalle = dDetalle.BuscarRetencionAdicDet(filtroDoc);
			return detalle;
		}
	}
}
