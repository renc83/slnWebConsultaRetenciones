function ValidaRIF(rif) {
	const regexpRIF = /\b[jJvVgG]\d{9}/;
	var Respuesta = rif.match(regexpRIF);
	if (Respuesta === null) {
        ShowMensaje("error","Rif No Cumple con la estructura.(J000000000)");
	}
}

function right(str, chr) {
    return str.slice(str.length - chr, str.length);
}

function left(str, chr) {
    return str.slice(0, chr - str.length);
}

function ShowMensaje(tipo, mensaje) {
    //   ShowMensaje("error", "naguara ramon");
    //   ShowMensaje("warning", "naguara ramon");
    //   ShowMensaje("success", "naguara ramon");
    toastr.options = {
        "closeButton": false,
        "debug": false,
        "newestOnTop": true,
        "progressBar": true,
        "positionClass": "toast-top-center",
        "preventDuplicates": false,
        "onclick": null,
        "showDuration": "500",
        "hideDuration": "500",
        "timeOut": "2500",
        "extendedTimeOut": "1000",
        "showEasing": "swing",
        "hideEasing": "linear",
        "showMethod": "fadeIn",
        "hideMethod": "fadeOut"
    }
    switch (tipo) {
        case "error":
            Command: toastr["error"](mensaje)
            break;
        case "warning":
            Command: toastr["warning"](mensaje)
            break;
        case "success":
            Command: toastr["success"](mensaje)
            break;
        default:
            Command: toastr["info"](mensaje)
            break;
    }
}

function generacodigo() {
    var now = new Date();
    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var today = ("0" + now.getFullYear()).slice(-2) + (month) + (day) + now.getHours() + now.getMinutes() + now.getSeconds();
    var numero = today; //+ Math.floor(Math.random() * 1000)

    return numero;
}

function roundToTwo(num) {
    return +(Math.round(num + "e+2") + "e-2");
}

function alerta(mensaje) {
    alert(mensaje);
}

function NombreCliente(correo) {
    var pCliente = document.getElementById("dCliente");
    var container = "";
    container = "<p style='font-size:14px'>Resetear la Contraseña y enviarla por correo a: " + correo + "</p>";
    pCliente.innerHTML = container;
}

function NombreSoporte(correo) {
    var pSoporte = document.getElementById("dSoporte");
    var container = "";
    container = "<p  style='font-size:14px'>Enviar un correo a soporte tecnico: " + correo + "</p>";
    pSoporte.innerHTML = container;
}

function LinkClientePassword(rif) {
    var pCliente = document.getElementById("aCliente");
    var container = "";
    container = "<a href='RecuperarPassword.aspx?rif="+rif+">¿Olvidaste la Contraseña?</a>";
    pCliente.innerHTML = container;
}