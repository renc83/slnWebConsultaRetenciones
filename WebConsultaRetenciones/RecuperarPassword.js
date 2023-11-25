function xNombreCliente(correo) {
    var pCliente = document.getElementById("dCliente");
    var container = "";
    container = "<p style='font-size:14px'>Resetear la Contraseña y enviarla por correo a: "+correo+"</p>";
    pCliente.innerHTML = container;
}

function xNombreSoporte(correo) {
    var pSoporte = document.getElementById("dSoporte");
    var container = "";
    container = "<p  style='font-size:14px'>Enviar un correo a soporte tecnico: " + correo + "</p>";
    pSoporte.innerHTML = container;
}

function xLinkClientePassword() {
    var pCliente = document.getElementById("dCliente");
    var container = "";
    container = "<p style='font-size:14px'>Resetear la Contraseña y enviarla por correo a: " + correo + "</p>";
    pCliente.innerHTML = container;
}