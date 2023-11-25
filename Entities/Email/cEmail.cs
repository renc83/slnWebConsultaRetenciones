using Entities.Email;

namespace Entities.Email
{
	public class cEmail
	{
            public string TipoCorreo { get; set; }
            public cSMTP SMTP { get; set; }
            public cSQLProfile SQLProfile { get; set; }
    }
}
