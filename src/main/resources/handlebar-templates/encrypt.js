////암호
//$('#eBtn').on('click', function () {
//    var message = $('#text1').val();
//    var key = $('#password').val();
//    var hint = $('#hint').val();
//    var encrypted = CryptoJS.AES.encrypt(message, key);
//    var eText = encrypted.toString();
//    var text = "{" + hint + "[" + eText + "]}";
//    $('#text2').val(text);
//});
//$('#dBtn').on('click', function () {
//    var eText = $('#text1').val();
//    var key = $('#password').val();
//
//    var p1 = eText.indexOf('[');
//    var p2 = eText.lastIndexOf(']');
//
//    if(p1!=-1 && p2!=-1 && p2>=p1){
//        eText=eText.substr(p1+1, p2-p1-1);
//    }
//  
//    var pText = CryptoJS.AES.decrypt(eText, key);
//    console.log(pText);
//    pText = pText.toString(CryptoJS.enc.Utf8);
//    console.log(pText);
//    p1 = pText.indexOf('"');
//    p2 = pText.lastIndexOf('"');
//    if(p1!=-1 && p2!=-1&&p2>=p1){
//        pText=pText.substr(p1+1, p2-p1-1);
//    }
//    $('#text2').val(pText);
//});
//$('#clearBtn').on('click', function(){
//    $('#text1').val('');
//    $('#text2').val('');
//
//});
//$('#copyToClipboardBtn').on('click', function(){
//    var text = $('#text2').get(0);
//    text.select();
//    try {
//      var ok = document.execCommand('copy');
//      if (!ok) {
//        alert('fail to copy to clipboard');
//      }
//    } catch (e) {
//      alert('not support');
//    } finally {
//        if(document.selection){
//             document.selection.empty();
//        }else{
//            window.getSelection().removeAllRanges();
//        }
//    }
//});
// CryptoJS 라이브러리가 필요합니다.
$(document).ready(function () {
    const encryptMessage = () => {
        const message = $('#text1').val();
        const key = $('#password').val();
        const hint = $('#hint').val();
        const encrypted = CryptoJS.AES.encrypt(message, key).toString();
        const text = `{${hint}[${encrypted}]}`;
        $('#text2').val(text);
    };

    const decryptMessage = () => {
        let eText = $('#text1').val();
        const key = $('#password').val();

        const p1 = eText.indexOf('[');
        const p2 = eText.lastIndexOf(']');
        if (p1 !== -1 && p2 !== -1 && p2 >= p1) {
            eText = eText.substring(p1 + 1, p2);
        }

        let pText = CryptoJS.AES.decrypt(eText, key).toString(CryptoJS.enc.Utf8);

        const firstQuote = pText.indexOf('"');
        const lastQuote = pText.lastIndexOf('"');
        if (firstQuote !== -1 && lastQuote !== -1 && lastQuote >= firstQuote) {
            pText = pText.substring(firstQuote + 1, lastQuote);
        }
        $('#text2').val(pText);
    };

    const clearFields = () => {
        $('#text1').val('');
        $('#text2').val('');
    };

    const copyToClipboard = () => {
        const textElement = $('#text2').get(0);
        textElement.select();
        try {
            const successful = document.execCommand('copy');
            if (!successful) throw new Error('Fail to copy to clipboard');
        } catch (err) {
            alert(err.message || 'Not supported');
        } finally {
            if (document.selection) {
                document.selection.empty();
            } else {
                window.getSelection().removeAllRanges();
            }
        }
    };

    $('#eBtn').on('click', encryptMessage);
    $('#dBtn').on('click', decryptMessage);
    $('#clearBtn').on('click', clearFields);
    $('#copyToClipboardBtn').on('click', copyToClipboard);
});
