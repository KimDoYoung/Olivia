// 상수를 정의하여 코드의 가독성과 유지보수성을 높입니다.
const CONTAINER_SELECTOR = '#pivotContainer';
const SRC_PIVOT_SELECTOR = `${CONTAINER_SELECTOR} #src`;
const DES_PIVOT_SELECTOR = `${CONTAINER_SELECTOR} #des`;
const DELI_SELECTOR = `${CONTAINER_SELECTOR} #deli`;
const BTN_RUN_SELECTOR = `${CONTAINER_SELECTOR} #btnRun`;
const BTN_CLEAR_SELECTOR = `${CONTAINER_SELECTOR} #btnClear`;
const BTN_CTC_SELECTOR = `${CONTAINER_SELECTOR} #btnCtc`;
const TAB_DELIMITER = 'TAB';

$(document).ready(function() {
    // 변수 이름 변경으로 명확성 향상
    const $srcPivot = $(SRC_PIVOT_SELECTOR), $desPivot = $(DES_PIVOT_SELECTOR);
    
    $(BTN_RUN_SELECTOR).on('click', function () {
        const delimiter = $(DELI_SELECTOR).val() === TAB_DELIMITER ? '\t' : $(DELI_SELECTOR).val();
        const trimmedSrc = $srcPivot.val().trim();
        let maxFields = 0; 
        const rows = trimmedSrc.split('\n').map(line => {
            const fields = line.split(delimiter);
            maxFields = Math.max(fields.length, maxFields);
            return fields;
        });
        
        const result = [];
        for(let i = 0; i < maxFields; i++){
            const row = rows.map(fields => (fields[i] || "").trim()).join(delimiter);
            result.push(row);
        }
  
        $desPivot.val(result.join("\n"));
    });

    $(BTN_CLEAR_SELECTOR).on('click', function() {
        $srcPivot.val('');
        $desPivot.val('');
    });

    $(BTN_CTC_SELECTOR).on('click', function() {
        const textElement = $desPivot.get(0);
        textElement.select();
        copyToClipboard1(textElement);
    });
});


function copyToClipboard1(textElement) {
    try {
        const successful = document.execCommand('copy');
        if (!successful) throw new Error('Failed to copy');
    } catch (err) {
        alert(err.message);
    } finally {
        if (document.selection) document.selection.empty();
        else window.getSelection().removeAllRanges();
    }
}
