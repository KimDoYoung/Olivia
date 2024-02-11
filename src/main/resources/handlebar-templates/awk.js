      var $src = $('#src'), $des = $('#des');
      //Run 버튼
      $('#btnRun').on('click', function () {

        var format = $('#format').val().trim();
        var ls = $('#ls').val();
        var fs = $('#fs').val();

        if(ls.length < 1) { alert('Line Seperator is empty');return;}
        if(fs.length < 1) { alert('Filed Seperator is empty');return;}
        if(format.length < 1) { alert('Format is empty');return;}
        
        awk.setLS(ls);
        awk.setFS(fs);
        awk.setSource($src.val().trim());
        awk.setFormat(format);
        var r = awk.run();

        $des.val(r);
      });
      //Clear버튼
      $('#btnClear').on('click', function () {
        console.log('clear...');
        $src.empty(); $des.empty();
        $src.val('');
        $des.val('');
        $('#format').val('');
      });
      //Copy to clipboard 버튼
      $('#btnCtc').on('click', function () {
        var text = $des.get(0);
        text.select();
        try {
          var ok = document.execCommand('copy');
          if (!ok) {
            alert('fail to copy to clipboard');
          }
          $des.focus();
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
      //초기 value
      $('#ls').val('CR');
      $('#fs').val('TAB');
