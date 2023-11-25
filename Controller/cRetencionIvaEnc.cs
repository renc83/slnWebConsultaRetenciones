using DataAccess;
using Entities;

namespace Controller
{
	public class cRetencionIvaEnc
	{
		public eRetencionIvaEnc BuscarRetencionIvaEnc(eFiltroDocumentos filtroDoc) {
			eRetencionIvaEnc encabezado = new eRetencionIvaEnc();
			dRetencionIvaEnc dEncabezado = new dRetencionIvaEnc();
			encabezado = dEncabezado.BuscarRetencionIvaEnc(filtroDoc);
			return encabezado;
		}
	}
}
