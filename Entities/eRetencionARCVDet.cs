using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities
{
	public class eRetencionARCVDet
	{
		public string RIF { get; set; }
		public Int32 ANIO { get; set; }
		public string MES { get; set; }
		public DateTime FECHADOC { get; set; }
		public string DOCUMENTO { get; set; }
		public Decimal BASEIMP { get; set; }
		public Decimal ALICUOTA { get; set; }
		public Decimal ISLRRETENIDO { get; set; }
		public Decimal MONTOPAGADO { get; set; }
		public string DETIMP { get; set; }
	}
}
