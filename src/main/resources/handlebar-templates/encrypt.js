//암호
$('#eBtn').on('click', function () {
    var message = $('#text1').val();
    var key = $('#password').val();
    var hint = $('#hint').val();
    var encrypted = CryptoJS.AES.encrypt(message, key);
    var eText = encrypted.toString();
    var text = "{" + hint + "[" + eText + "]}";
    $('#text2').val(text);
});
$('#dBtn').on('click', function () {
    var eText = $('#text1').val();
    var key = $('#password').val();

    var p1 = eText.indexOf('[');
    var p2 = eText.lastIndexOf(']');

    if(p1!=-1 && p2!=-1 && p2>=p1){
        eText=eText.substr(p1+1, p2-p1-1);
    }
  
    var pText = CryptoJS.AES.decrypt(eText, key);
    console.log(pText);
    pText = pText.toString(CryptoJS.enc.Utf8);
    console.log(pText);
    p1 = pText.indexOf('"');
    p2 = pText.lastIndexOf('"');
    if(p1!=-1 && p2!=-1&&p2>=p1){
        pText=pText.substr(p1+1, p2-p1-1);
    }
    $('#text2').val(pText);
});
$('#clearBtn').on('click', function(){
    $('#text1').val('');
    $('#text2').val('');

});
$('#copyToClipboardBtn').on('click', function(){
    var text = $('#text2').get(0);
    text.select();
    try {
      var ok = document.execCommand('copy');
      if (!ok) {
        alert('fail to copy to clipboard');
      }
    } catch (e) {
      alert('not support');
    } finally {
        if(document.selection){
             document.selection.empty();
        }else{
            window.getSelection().removeAllRanges();
        }
    }
});