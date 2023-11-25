using DataAccess;
using Entities;

namespace Controller
{
	 public class cRetencionISLREnc
	{
		public eRetencionISLREnc BuscarRetencionISLREnc(eFiltroDocumentos filtroDoc)
		{
			eRetencionISLREnc encabezado = new eRetencionISLREnc();
			dRetencionISLREnc dEncabezado = new dRetencionISLREnc();
			encabezado = dEncabezado.BuscarRetencionISLREnc(filtroDoc);
			return encabezado;
		}
	}
}
