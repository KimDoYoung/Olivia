<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
   
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="kfs" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="olivia"  uri="/WEB-INF/olivia-tags/olivia.tld"%>

<!DOCTYPE html>
<html lang="en">
<head>
<!-- =================================================== -->
<jsp:include page="../common/meta_css.jsp" flush="false" />
<!-- =================================================== -->
<title><c:out value="${pageTitle }" default="board" /></title>
</head>
    <style>
        /* 사용자 정의 CSS 스타일 */
        .calendar-border-day {
            border: 1px solid #dee2e6; /* 테두리 스타일 및 색상 지정 */
            padding: 10px; /* 선택적으로 패딩 추가 */
            height : 150px;
        }
        .calendar-border-week {
            border: 1px solid #dee2e6; /* 테두리 스타일 및 색상 지정 */
            padding: 10px; /* 선택적으로 패딩 추가 */
        }        
    </style>
<body>
<!-- =================================================== -->
<jsp:include page="../common/top-menu.jsp" flush="false" />
<!-- =================================================== -->
<main>
	<section id="calendar-area" class="container">
		<div id="headerCalendar" class="mt-5 text-center d-flex align-items-center">
			<a href="#" id="prevYear" class="text-decoration-none"  title="prev year"><i class="bi bi-caret-left-fill"></i></a>
		    <a href="#" id="prevMonth"  class="text-decoration-none mx-2" title="prev month"><i class="bi bi-caret-left"></i></a>
		    <h3 class="d-inline"><span id="currentYyyy"></span>년 <span id="currentMm"></span>월</h3>
		    <a href="#" id="nextMonth" class="text-decoration-none mx-2"  title="next month"><i class="bi bi-caret-right"></i></a>
		    <a href="#" id="nextYear" class="text-decoration-none" title="next year"><i class="bi bi-caret-right-fill"></i></a>
		</div>
		<div id="mainCalendar" class="mt-2 vh-100"></div>
	</section>
	<section id="input-area" class="container d-none">
	    <h2>스케줄 입력</h2>
	    <form>
	        <div class="mb-3">
	            <label class="form-label">양력 음력 구분</label>
	            <div class="form-check form-check-inline">
	                <input class="form-check-input" type="radio" name="lunar_or_solar" id="lunar" value="M">
	                <label class="form-check-label" for="lunar">Lunar</label>
	            </div>
	            <div class="form-check form-check-inline">
	                <input class="form-check-input" type="radio" name="lunar_or_solar" id="solar" value="S">
	                <label class="form-check-label" for="solar">Solar</label>
	            </div>
	        </div>
	        <div class="mb-3">
	            <label class="form-label">주기</label>
	            <div class="form-check form-check-inline">
	                <input class="form-check-input" type="radio" name="repeat_option" id="yearly" value="Y" required>
	                <label class="form-check-label" for="yearly">매년</label>
	            </div>
	            <div class="form-check form-check-inline">
	                <input class="form-check-input" type="radio" name="repeat_option" id="monthly" value="M" required>
	                <label class="form-check-label" for="monthly">매달</label>
	            </div>
	            <div class="form-check form-check-inline">
	                <input class="form-check-input" type="radio" name="repeat_option" id="specific" value="S" required>
	                <label class="form-check-label" for="specific">특정일</label>
	            </div>
	        </div>
	        <div class="mb-3">
	            <label for="ymd" class="form-label">날짜</label>
	            <input type="text" class="form-control" id="ymd" name="ymd" required maxlength="8">
	        </div>        
	        <div class="mb-3">
	            <label for="content" class="form-label">내용</label>
	            <input type="text" class="form-control" id="content" name="content" required>
	        </div>
	
	        <button type="submit" class="btn btn-primary">Submit</button>
	    </form>
	</section>
</main>
<!-- =================================================== -->
<jsp:include page="../common/footer.jsp" flush="false" />
<!-- -================================================== -->
<script src="js/olivia-calendar-utility.js"></script>
<script>
$( document ).ready(function() {
	console.log('calendar.... ');

	function drawCalendar(yyyy,mm){
		$('#currentYyyy').text(yyyy);
		$('#currentMm').text(mm);		
		var html = CalendarMaker.calendarHtml(yyyy, mm);
		$('#mainCalendar').html(html);
		$('#mainCalendar').find('.week').addClass('calendar-border-week');
		$('#mainCalendar').find('.day').addClass('calendar-border-day');
	}
	
	$("#prevMonth").on('click', function(){
		
	});
	$("#prevYear").on('click', function(){
		
	});
	$("#nextMonth").on('click', function(){

	});
	$("#nextYear").on('click', function(){
			
	});
	
	//로딩시 수행
	var date = new Date();
	var yyyy = date.getFullYear();
	var mm = date.getMonth() + 1;
	drawCalendar(yyyy,mm);
	
});
</script>	
</body>
</html>