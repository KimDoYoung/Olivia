//class AwkProcessor {
//    constructor() {
//        this.sourceLines = [];
//        this.outputFormat = "";
//        this.fieldSeparator = " ";
//        this.lineSeparator = "\n";
//    }
//
//    setSource(source) {
//        this.sourceLines = source.split(this.lineSeparator).map(line => line.split(this.fieldSeparator));
//    }
//
//    setFormat(format) {
//        this.outputFormat = format;
//    }
//
//    setFieldSeparator(fs) {
//        this.fieldSeparator = fs === "TAB" ? "\t" : fs;
//    }
//
//    setLineSeparator(ls) {
//        this.lineSeparator = ls === "CR" ? "\r" : ls;
//    }
//
//    run() {
//        let resultLines = this.sourceLines.map((lineArray, index) => this.#parseLine(lineArray, index + 1));
//        let combinedResult = resultLines.join(this.lineSeparator);
//        return this.outputFormat.includes("^") ? this.#adjustFieldPositions(combinedResult) : combinedResult;
//    }
//
//    #parseLine(lineArray, lineNumber) {
//        let resultString = this.outputFormat;
//        lineArray.forEach((value, index) => {
//            const regex = new RegExp(`\\$${index + 1}`, "g");
//            resultString = resultString.replace(regex, value.trim());
//        });
//        resultString = resultString
//            .replace(/\$\#/g, lineNumber)
//            .replace(/\$0/g, lineArray.join(this.fieldSeparator));
//        return resultString;
//    }
//
//    #adjustFieldPositions(source) {
//        let maxFieldLengths = [];
//        source.split(this.lineSeparator).forEach(line => {
//            const fields = line.split(this.fieldSeparator);
//            fields.forEach((field, index) => {
//                const length = field.trim().length;
//                maxFieldLengths[index] = Math.max(maxFieldLengths[index] || 0, length);
//            });
//        });
//
//        return source.split(this.lineSeparator).map(line => {
//            return line.split(this.fieldSeparator).map((field, index) => {
//                return field.trim().padEnd(maxFieldLengths[index] + 1);
//            }).join(this.fieldSeparator);
//        }).join(this.lineSeparator).trim();
//    }
//}
const awk = (function(){
    var srcArray  = [];
    var format = undefined;
    var FS = undefined; // "\t";
    var LS = undefined; // "\n";


    var parse =  function (lineObject, lineNo){
      var toProperty = function(columnName){
        if(columnName === null || columnName === undefined ) return '';
        var ss = columnName.split('_'), r = '';
        for(var i=0; i < ss.length; i++){
          if( i === 0){
              r += ss[i].toLowerCase();
          }else {
              r += ss[i].substring(0, 1).toUpperCase() + ss[i].substring(1).toLowerCase();
          }
        }
        return r;
      }  
  

        var format = lineObject.format;
        var array = lineObject.array;
        var FS = lineObject.FS;
        console.log(array);
        debugger;
        var r = format;
        for(var i=1; i <= array.length ; i++){
          var re = new RegExp("\\$" +i, 'g');
          var v = array[i-1].trim();
          var p = toProperty(array[0]);
           r = r.replace(/\$\#/gi, lineNo).replace(re, v).replace(/\$P/,p)
        }
        var re = new RegExp("\\$0");
        r = r.replace(re, array.join(FS));
        
        return r;
      }
      var pad = function(str, len, chr, leftJustify){
        var padding = (str.length >= len) ? '' : Array(1 + len - str.length >>> 0).join(chr);
        return leftJustify ? str + padding : padding  + str;
      }      
      var fixPosition = function(src){
        var maxLen = [];
        src.split('\n').forEach(function(line){
          var fields = line.split('^');
          for(var i=0; i < fields.length; i++){
            if(!maxLen[i]){
              maxLen[i] = Math.max(-1, ((fields[i])).trim().length);
            } else {
              maxLen[i] = Math.max(maxLen[i], ((fields[i])).trim().length);
            }
          }
        });
        var r = '';
        src.split('\n').forEach(function(line){
          var fields = line.split('^');
          for(var i=0; i < fields.length; i++){
            r += pad((fields[i]).trim(), maxLen[i] + 1, ' ', true);
          }
          r += '\n';
        });
        return r.replace(/\s\s*$/, '');
      }
          
      var run = function (){
          var r = [];
          var lineNo=0;
          srcArray.forEach(function(a){
            var o = {
                format : format,
                FS : FS,
                array : a
            };
            r.push( parse(o, ++lineNo) );
          });
          var s = r.join("\n");
          if(format.indexOf("^")>-1){
              return fixPosition(s);
          }
          return s;
      }
      return {
          setSource : function(src){
            srcArray  = [];
            debugger;
            var lines = src.split(LS);
            let i = 1;
            lines.forEach(function(line){
                console.log(line);
                var a = line.split(FS);
                console.log(a);
                srcArray.push(a);
            });
          },
          setFormat : function(f) {
              format = f;
          },
          setFS : function(fs){
            if(fs === "TAB") {
              FS = "\t";
            }else{
              FS = fs;
            }
            // FS = fs;
            // FS = fs.charCodeAt(0)
            // FS = fs.fromChar
          },
          setLS : function(ls) {
            // LS = ls;
            // LS = ls.charCodeAt();
            if(ls === 'CR'){
              LS = "\n";
            }else{
              LS = ls;
            }
          },
          run :  run
      }  
})();
//-----------------------------------------------------
  var $src = $('#src'), $des = $('#des');
  //Run 버튼
  $('#btnRun').on('click', function () {

    var format = $('#format').val().trim();
    var ls = $('#ls').val();
    var fs = $('#fs').val();

    if(ls.length < 1) { alert('Line Seperator is empty');return;}
    if(fs.length < 1) { alert('Filed Seperator is empty');return;}
    if(format.length < 1) { alert('Format is empty');return;}
 
 
    //const awk = new AwkProcessor();
    //awk.setLineSeparator(ls);
    //awk.setFieldSeparator(fs);
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
