const CalendarMaker = (function() {
    let currentYear, currentMonth;

    // 주어진 날짜의 요일을 반환하는 함수 (0: 일요일, 6: 토요일)
    const getDayOfWeek = (year, month, day) => new Date(year, month - 1, day).getDay();

    // 한 자리 숫자 앞에 0을 붙여 두 자리 문자열로 만드는 함수
    const zeroPad = (value) => value.toString().padStart(2, '0');

    // 주어진 날짜에 일수를 더하거나 뺀 결과를 반환하는 함수
    const adjustDate = (ymd, days) => {
        const date = new Date(ymd.slice(0, 4), parseInt(ymd.slice(4, 6)) - 1, ymd.slice(6));
        date.setDate(date.getDate() + days);
        return `${date.getFullYear()}${zeroPad(date.getMonth() + 1)}${zeroPad(date.getDate())}`;
    };

    // 주어진 년월의 마지막 날을 반환하는 함수
    const getMonthEndDay = (year, month) => {
        const lastDay = new Date(year, month, 0).getDate();
        return `${year}${zeroPad(month)}${zeroPad(lastDay)}`;
    };

    // 달력 HTML 문자열을 생성하는 함수
    const generateCalendarHTML = (year, month) => {
        currentYear = year;
        currentMonth = month;
        
        const startDayOfWeek = getDayOfWeek(year, month, 1);
        let endDay = getMonthEndDay(year, month);
        let startDay = `${year}${zeroPad(month)}01`;

        // 시작일과 종료일을 주의 시작과 끝으로 조정
        startDay = adjustDate(startDay, -startDayOfWeek);
        endDay = adjustDate(endDay, 6 - getDayOfWeek(year, month, parseInt(endDay.slice(6))));

        // 달력의 요일 헤더를 생성
        let html = '<div class="row">';
        const daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"];
        daysOfWeek.forEach((day, index) => {
            html += `<div class="col bg-light text-center ${index === 0 ? 'text-danger' : index === 6 ? 'text-primary' : ''} week">${day}</div>`;
        });
        html += '</div>';

        // 달력의 날짜를 생성
        for (let ymd = startDay; ymd <= endDay; ymd = adjustDate(ymd, 1)) {
            const dayOfWeek = getDayOfWeek(ymd.slice(0, 4), parseInt(ymd.slice(4, 6)), parseInt(ymd.slice(6)));
            if (dayOfWeek === 0) html += '<div class="row">'; // 새로운 주의 시작
            html += `<div class="col day ${dayOfWeek === 0 ? 'text-danger' : dayOfWeek === 6 ? 'text-primary' : ''}">${parseInt(ymd.slice(6))}</div>`;
            if (dayOfWeek === 6) html += '</div>'; // 주의 끝
        }

        return html;
    };

    // 년월을 조정하는 함수 (다음 또는 이전 년월 계산)
    const adjustYearMonth = (year, month, adjustment) => {
        const newDate = new Date(year, month - 1 + adjustment, 1);
        return [newDate.getFullYear(), newDate.getMonth() + 1];
    };

    // 공개 메서드 및 속성
    return {
        generateCalendarHTML,
        nextYearMonth: (year, month) => adjustYearMonth(year, month, 1),
        prevYearMonth: (year, month) => adjustYearMonth(year, month, -1),
        currentYearMonth: () => [currentYear, currentMonth]
    };
})();
