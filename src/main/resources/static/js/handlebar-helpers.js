/**
 * handlebar-helpers 
 */
	// 사용자 함수 inc 등록
	Handlebars.registerHelper("inc", function(value, options){
	        return parseInt(value) + 1;
	});
    Handlebars.registerHelper('formatComma', function (number) {
        // 숫자에 콤마 추가
        return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    });	
    Handlebars.registerHelper('formatYmdHms', function(date) {
        // date는 JavaScript Date 객체여야 함
        var year = date.getFullYear();
        var month = ('0' + (date.getMonth() + 1)).slice(-2);
        var day = ('0' + date.getDate()).slice(-2);
        var hours = ('0' + date.getHours()).slice(-2);
        var minutes = ('0' + date.getMinutes()).slice(-2);
        var seconds = ('0' + date.getSeconds()).slice(-2);

        return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes + ':' + seconds;
    });
    Handlebars.registerHelper('formatDateString', function(dateStr) {
        var months = [
            "Jan", "Feb", "Mar", "Apr", "May", "Jun",
            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
        ];

        var dateParts = dateStr.split(/[\s,]+/);
        var monthIndex = months.indexOf(dateParts[0]);
        var year = dateParts[2];
        var month = ('0' + (monthIndex + 1)).slice(-2);
        var day = ('0' + dateParts[1]).slice(-2);
        var timeParts = dateParts[3].split(':');
        var hours = ('0' + parseInt(timeParts[0])).slice(-2);
        var minutes = ('0' + parseInt(timeParts[1])).slice(-2);
        var seconds = ('0' + parseInt(timeParts[2])).slice(-2);
        var period = dateParts[4];

        return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes + ':' + seconds + ' ' + period;
    }); 