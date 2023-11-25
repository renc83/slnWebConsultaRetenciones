using System;
using System.Net;
using System.Net.Mail;
using Entities;

namespace DataAccess
{
	public class dCorreoSMTP
    {
        public bool sendMail(
          string para,
          string asunto,
          string mensaje,
          string fileToAttach,
          SMTPData smtp)
        {
            bool flag = false;
            try
            {
                SmtpClient smtpClient1 = new SmtpClient();
                SmtpClient smtpClient2 = new SmtpClient(smtp.Server);
                smtpClient2.Credentials = (ICredentialsByHost)new NetworkCredential(smtp.Username, smtp.Password);
                MailMessage message = new MailMessage();
                message.From = new MailAddress(smtp.RemitenteText);
                message.To.Add(para);
                message.Subject = asunto;
                message.Body = mensaje;
                message.IsBodyHtml = true;
                smtpClient2.Port = smtp.Port;
                smtpClient2.EnableSsl = true;
                if (fileToAttach != "")
                {
                    using (Attachment attachment = new Attachment(fileToAttach))
                    {
                        message.Attachments.Add(attachment);
                        smtpClient2.Send(message);
                    }
                }
                else
                    smtpClient2.Send(message);
                flag = true;
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception caught in process: {0}", (object)ex.ToString());
            }
            return flag;
        }
    }
}
