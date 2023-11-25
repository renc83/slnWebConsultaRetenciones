using System;

namespace Entities
{
	public class eRetencionIvaDet
	{
		public int numope				 {get; set;}
		public string RIF					 {get; set;}
		public DateTime FECHADOC				 {get; set;}
		public string NUMFACTURA			 {get; set;}
		public string NUMCONTROL			 {get; set;}
		public string NUMNTD				 {get; set;}
		public string NUMNTC				 {get; set;}
		public string TIPOTRANS				 {get; set;}
		public string FACAFEC { get; set;}
		public Decimal COCIVA				 {get; set;}
		public Decimal COSIVA				 {get; set;}
		public Decimal IMP_basimp_alicgene	 {get; set;}
		public Decimal IMP_porceimp_alicgene	 {get; set;}
		public Decimal IMP_montoimp_alicgene	 {get; set;}
		public Decimal IMP_basimp_alicreduc	 {get; set;}
		public Decimal IMP_porceimp_alicreduc {get; set;}
		public Decimal IMP_montoimp_alicreduc {get; set;}
		public Decimal IMP_basimp_alicadic	 {get; set;}
		public Decimal IMP_porceimp_alicadic	 {get; set;}
		public Decimal IMP_montoimp_alicadic	 {get; set;}
		public Decimal alicuota				 {get; set;}
		public Decimal IVARET { get; set; }
	}
}
