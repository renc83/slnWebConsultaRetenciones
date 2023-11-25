<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RecuperarPassword.aspx.cs" Inherits="WebConsultaRetenciones.RecuperarPassword" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" href="./Local_Resources/Images/favicon.ico" type="image/x-icon">


    <!-- jQuery -->
    <script src="/Scripts/plugins/code.jquery.com_jquery-3.7.0.min.js"></script>

    <script src="./Scripts/js/sysfunctions.js"></script>
    <title>Inicio de Sesion</title>

    <!-- Bootstrap 4 -->
    <script src="/Scripts/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <link href="/Scripts/plugins/bootstrap/css/bootstrap.css" rel="stylesheet" />

    <link rel="stylesheet" href="./Scripts/css/styles.css">
        <!-- Toast -->
    <link href="/Scripts/plugins/toastr/toastr.css" rel="stylesheet" />
    <script src="/Scripts/plugins/toastr/toastr.js"></script>


</head>

<body class="bgg">
    <div class="wrapper">
        <div class="empresa">
        </div>
        <div id="formContent">
            <!-- Tabs Titles -->
            <h2 class="active"><a href="./RecuperarPassword.aspx">Cambio de Contraseña</a></h2>
            <!-- Icon -->
            <div>
                <img src="./Local_Resources/Images/VOG-horiz-blue.png" height="40px">
                <br>
                <span>Comprobantes de Retención Online v1.0</span>
                <br>
            </div>

            <!-- Login Form -->
            <form id="login" runat="server">

                <div style="width: 80%; margin: auto;">
                    <hr />
                    <div  style="margin: auto;display:flex">
                        <img src="./Local_Resources/Images/Email.png" height="40px"> 
                        <div id="dSoporte"></div>
                   
                    </div>
                       <asp:Button ID="btnSoporte" runat="server"  class="btn btn-primary btn-s" Text="Enviar" OnClick="btnSoporte_Click" Style="margin:0px" />                  
                    <hr />
                </div>
                <div style="width: 80%; margin: auto">
                    <div  style="margin: auto;display:flex">
                    <img src="./Local_Resources/Images/Email.png" height="40px">                     
                    <div id="dCliente"></div>
                        </div>
                    <asp:Button ID="btnCliente" runat="server"  class="bton" Text="Enviar" OnClick="btnCliente_Click" Style="margin:0px" />
                    <hr />
                </div>

                <!-- Remind Passowrd -->
                <div id="formFooter">
                    <img src="./Local_Resources/Images/MS Dynamics.jpg" height="45px">
                    <div>
                        <a href="login.aspx">¿Intentarlo Nuevamente?</a>
                    </div>
                </div>
                <asp:TextBox runat="server" class="form-control" ID="rifusuario" name="rifusuario" type="text" value="" hidden></asp:TextBox>
                <asp:TextBox runat="server" class="form-control" ID="nombreusuario" name="nombreusuario" type="text" value="" hidden></asp:TextBox>
                <asp:TextBox runat="server" class="form-control" ID="correousuario" name="correousuario" type="text" value="" hidden></asp:TextBox>
            </form>
            
        </div>
    </div>




</body>

</html>
