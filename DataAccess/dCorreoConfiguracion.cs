using Entities.Email;
using Newtonsoft.Json;
using System;
using System.IO;

namespace DataAccess
{
	public class dCorreoConfiguracion
    {
        public cEmail LeeConfiguracionJson()
        {
            cEmail data = new cEmail();
            string RutaJson = Environment.CurrentDirectory + "\\Correoconfig.json";
            try
            {
                data = JsonConvert.DeserializeObject<cEmail>(File.ReadAllText(RutaJson));
            }
            catch (Exception ex)
            {
                string error= ex.Message;
            }
            return data;
        }
}
}
