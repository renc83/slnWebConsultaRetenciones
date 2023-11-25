using DataAccess;
using Entities;

namespace Controller
{
	public class cRetencionAdicEnc
	{
		public eRetencionAdicEnc BuscarRetencionAdicEnc(eFiltroDocumentos filtroDoc)
		{
			eRetencionAdicEnc encabezado = new eRetencionAdicEnc();
			dRetencionAdicEnc dEncabezado = new dRetencionAdicEnc();
			encabezado = dEncabezado.BuscarRetencionAdicEnc(filtroDoc);
			return encabezado;
		}
	}
}
