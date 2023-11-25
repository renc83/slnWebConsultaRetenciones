using DataAccess;
using Entities;
using System.Collections.Generic;

namespace Controller
{
	public class cRetencionARCVDet
	{
		public List<eRetencionARCVDet> BuscarRetencionARCVDet(eFiltroDocumentos filtroDoc)
		{
			List<eRetencionARCVDet> detalle = new List<eRetencionARCVDet>();
			dRetencionARCVDet dDetalle = new dRetencionARCVDet();
			detalle = dDetalle.BuscarRetencionARCVDet(filtroDoc);
			return detalle;
		}
	}
}
