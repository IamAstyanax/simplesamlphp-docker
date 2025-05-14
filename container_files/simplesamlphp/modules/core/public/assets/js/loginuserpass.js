ready(function () {
    window.onpageshow  = function () {
        var button = document.getElementById("submit_button");
        var replacement = document.createTextNode(button.getAttribute("data-default"));
        button.replaceChild(replacement, button.childNodes[0]);
        button.disabled = false;
        // look for an email cookie and default the username box to that
        setDefaultEmail()
    }

    var form = document.getElementById("f");
    form.onsubmit = function () {
        var button = document.getElementById("submit_button");
        var replacement = document.createTextNode(button.getAttribute("data-processing"));
        button.replaceChild(replacement, button.childNodes[0]);
        button.disabled = true;
    }

    document.getElementById("eyeIcon").addEventListener("click", function () {
        var passwordField = document.getElementById("password");
        if (passwordField.type === "password") {
            passwordField.type = "text";
            this.classList.remove("ph-eye-closed");
            this.classList.add("ph-eye");
        } else {
            passwordField.type = "password";
            this.classList.remove("ph-eye");
            this.classList.add("ph-eye-closed");
        }
    });
});

function setDefaultEmail(){

    let username=document.getElementById('username')
    let cookies = document.cookie.split(';')
    let emailCookie=cookies.find(c => c.search('email=') >0)
    let emailCookieValue= emailCookie.split('=')
    if (emailCookieValue.length>0){
        username.value=emailCookieValue[1]
    }
}