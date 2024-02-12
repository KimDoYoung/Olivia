      var $src = $('#src'), $des = $('#des');
       $('#btnRun').on('click', function () {
        var deli = $('#deli').val();
        if(deli == 'TAB'){
          deli = '\t';
        } 
        var trimmedSrc = $src.val().trim();
        var  t= [], m=0; 
        trimmedSrc.split('\n').forEach(function(line){
          var fields = line.split(deli);
          m = Math.max(fields.length, m);
          t.push(fields);
        });
        console.log(t);
        var r = '';
        // for(var i = 0 ; i < t.length; i++){
        //   var a = t[i];
        //   for(var j = 0; j < m ; j++){
        //      r += a[j].trim() + "\t";  
        //   }
        //   r += "\n";
        // }
        for(var i = 0 ; i < m; i++){
          for(var j = 0; j < t.length ; j++){
             r += ((t[j][i]) + "").trim() + deli;  
          }
          r += "\n";
        }
  
        $des.val(r);
  
      });
      $('#btnClear').on('click', function(){
          console.log('clear...');
          $src.empty(); $des.empty();
          $src.val('');
          $des.val('');
      });
      $('#btnCtc').on('click', function(){
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