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

  .border-icon {
    border: 1px solid #007bff; /* 보더 색상 */
    padding: 8px 12px; /* 보더 주변의 여백을 조절할 수 있습니다 */
    border-radius: 5px; /* 보더의 모서리를 둥글게 만들기 위해 사용 */
  }

 </style>
</head>
<body>
<!-- =================================================== -->
<jsp:include page="../common/top-menu.jsp" flush="false" />
<!-- =================================================== -->
<main>
	<section id="calendar-area" class="container">
		<div id="headerCalendar" class="mt-5 text-center d-flex align-items-center">
			<a href="#" id="prevYear" class="text-decoration-none border-icon"  title="prev year"><i class="bi bi-caret-left-fill"></i></a>
		    <a href="#" id="prevMonth"  class="text-decoration-none  border-icon mx-2" title="prev month"><i class="bi bi-caret-left"></i></a>
		    <h3 class="d-inline"><span id="currentYyyy"></span>년 <span id="currentMm"></span>월</h3>
		    <a href="#" id="nextMonth" class="text-decoration-none  border-icon mx-2"  title="next month"><i class="bi bi-caret-right"></i></a>
		    <a href="#" id="nextYear" class="text-decoration-none  border-icon me-2" title="next year"><i class="bi bi-caret-right-fill"></i></a>
		    <a href="#" id="todayYearMonth" class="text-decoration-none  border-icon me-2" title="today"><i class="bi bi-calendar-check today-icon" title="오늘"></i></a>
		    <a href="#" id="btnSpecialDay" class="text-decoration-none  border-icon me-1" title="공휴일정보"><i class="bi bi-box2-heart"></i></a>
		    <a href="#" id="btnEditSchedule" class="text-decoration-none  border-icon" title="schedule"><i class="bi bi-pencil" title="일정추가"></i></a>
		    <button class="btn btn-primary" id="btnOpenApiDbInsert">openapi휴일정보db저장</button>
		</div>
		<div id="mainCalendar" class="mt-2 vh-100"></div>
	</section>
<!-- 왼쪽 Offcanvas 휴일정보-->
<div class="offcanvas offcanvas-start" tabindex="-1" id="specialDayOffcanvas">
    <div class="offcanvas-header">
        <h5 class="offcanvas-title" id="leftOffcanvasLabel">휴일정보</h5>
        <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body">
        <!-- 왼쪽 Offcanvas 내용 -->
	    <form id="formSpecialDay">
	        <div class="mb-3">
	            <label for="locdate" class="form-label">날짜 (YYYYMMDD)</label>
	            <input type="date" class="form-control" id="locDate" name="locDate" required maxlength="8">
	            <input type="hidden" class="form-control" id="dateKind" name="dateKind" value="01">
	        </div>
<!-- 	        <div class="mb-3"> -->
<!-- 	            <label for="dateKind" class="form-label">종류</label> -->
<!-- 	            <input type="text" class="form-control" id="dateKind" name="dateKind"> -->
<!-- 	        </div> -->
			<div class="mb-3">
			    <label class="form-label">공공기관 휴일여부</label>
			    <div class="form-check form-check-inline">
			        <input class="form-check-input" type="radio" name="holidayYn" id="holidayYnY" value="Y" required checked>
			        <label class="form-check-label" for="holidayYnY">Y</label>
			    </div>
			    <div class="form-check form-check-inline">
			        <input class="form-check-input" type="radio" name="holidayYn" id="holidayYnN" value="N" required>
			        <label class="form-check-label" for="holidayYnN">N</label>
			    </div>
			</div>
	        <div class="mb-3">
	            <label for="dateName" class="form-label">명칭</label>
	            <input type="text" class="form-control" id="dateName" name="dateName">
	        </div>
	        <button type="submit" id="btnSecialDayInsert" class="btn btn-primary">저장</button>
	    </form>
	    
    </div>
</div>

<!-- 오른쪽 Offcanvas -->
<div class="offcanvas offcanvas-end" tabindex="-1" id="scheduleOffcanvas" >
    <div class="offcanvas-header">
        <h5 class="offcanvas-title" id="rightOffcanvasLabel">스케줄 입력</h5>
        <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body">
        <!-- 오른쪽 Offcanvas 내용 -->
        <form id="formSchedule">
            <!-- 스케줄 입력 폼 -->
	        <div class="mb-3">
	            <label class="form-label me-5 fw-bold">양/음력</label>
	            <div class="form-check form-check-inline">
	                <input class="form-check-input" type="radio" name="lunar_or_solar" id="solar" value="S" checked>
	                <label class="form-check-label" for="solar">양력</label>
	            </div>
	            <div class="form-check form-check-inline">
	                <input class="form-check-input" type="radio" name="lunar_or_solar" id="lunar" value="M">
	                <label class="form-check-label" for="lunar">음력</label>
	            </div>
	        </div>
	        <div class="mb-3">
	            <label class="form-label fw-bold me-5">주기</label>
	            <div class="form-check form-check-inline">
	                <input class="form-check-input" type="radio" name="repeat_option" id="yearly" value="Y" >
	                <label class="form-check-label" for="yearly">매년</label>
	            </div>
	            <div class="form-check form-check-inline">
	                <input class="form-check-input" type="radio" name="repeat_option" id="monthly" value="M" >
	                <label class="form-check-label" for="monthly">매달</label>
	            </div>
	            <div class="form-check form-check-inline">
	                <input class="form-check-input" type="radio" name="repeat_option" id="specific" value="S"  checked>
	                <label class="form-check-label" for="specific">특정일</label>
	            </div>
	        </div>
	        <div class="mb-3">
	            <label for="ymd" class="form-label fw-bold">날짜</label>
	            <input type="text" class="form-control" id="ymd" name="ymd" required maxlength="8">
	        </div>        
	        <div class="mb-3">
	            <label for="content" class="form-label fw-bold">내용</label>
	            <input type="text" class="form-control" id="content" name="content" required>
	        </div>
	        <button type="button" id="btnSchedulaInsert" class="btn btn-primary">저장</button>
	        <button type="button" id="btnSchedulaClose" class="btn btn-secondary">취소</button>
       </form>
    </div>
</div>

</main>
<!-- =================================================== -->
<jsp:include page="../common/footer.jsp" flush="false" />
<!-- -================================================== -->
<script src="js/olivia-calendar-utility.js"></script>
<script>
$( document ).ready(function() {
	console.log('calendar.... ');
	var scheduleOffcanvas = new bootstrap.Offcanvas(document.getElementById('scheduleOffcanvas'));
	var specialDayOffcanvas= new bootstrap.Offcanvas(document.getElementById('specialDayOffcanvas'));
	
	function drawCalendar(yyyy,mm){
		$('#currentYyyy').text(yyyy);
		$('#currentMm').text(mm);		
		var html = CalendarMaker.calendarHtml(yyyy, mm);
		$('#mainCalendar').html(html);
		$('#mainCalendar').find('.week').addClass('calendar-border-week');
		$('#mainCalendar').find('.day').addClass('calendar-border-day');
	}
	
	$("#prevMonth").on('click', function(){
		let ym = CalendarMaker.currentYearMonth();
		ym  = CalendarMaker.prevYearMonth(ym[0], ym[1]);
		drawCalendar(ym[0], ym[1]);
	});
	$("#prevYear").on('click', function(){
		let ym = CalendarMaker.currentYearMonth();
		drawCalendar(ym[0]-1, ym[1]);		
	});
	$("#nextMonth").on('click', function(){
		let ym = CalendarMaker.currentYearMonth();
		ym  = CalendarMaker.nextYearMonth(ym[0], ym[1]);
		drawCalendar(ym[0], ym[1]);
	});
	$("#nextYear").on('click', function(){
		let ym = CalendarMaker.currentYearMonth();
		drawCalendar(ym[0]+1, ym[1]);					
	});
	$('#todayYearMonth').on('click', function(){
		let today = new Date();
		let y = today.getFullYear();
		let m= today.getMonth() + 1;
		drawCalendar(y,m);
	});
	$("#btnSchedulaInsert").on('click', function(){
		let $form = $('#formSchedule');
		let lunarOrSolar =  $form.find('input[name=lunar_or_solar]:checked').val();
		let repeatOption =  $form.find('input[name=repeat_option]:checked').val();
		let ymd =  $form.find('input[name=ymd]').val();
		let content =  $form.find('input[name=content]').val();
		if(ymd.length < 1){
			alert('날짜를 넣어주세요');
			return ;
		}
		if(content.length < 1){
			alert('내용을 넣어주세요');
			return ;
		}
		if(repeatOption == 'Y' && ymd.length != 4){
			alert("매년 옵션에서는 월일(숫자4자리)를 넣어주셔야합니다");
			return ;
		}else if(repeatOption == 'M' && ymd.length != 2){
			alert("매월 옵션에서는 일(숫자2자리)를 넣어주셔야합니다");
			return ;
		}else if(repeatOption == 'S' && ymd.length != 8){
			alert("특정일 옵션에서는 년월일(숫자8자리)를 넣어주셔야합니다");
			return ;			
		}
		var data = {
				lunarOrSolar: lunarOrSolar,
				repeatOption: repeatOption,
				ymd: ymd,
				content: content
			};
		
		JuliaUtil.ajax("/insert", data, {
			method:'POST',
			success : (response) => {
				console.log(response);
				if(response.result == 'OK'){
					$form.find('input[name=ymd]').val('');
					$form.find('input[name=content]').val('');
					alert('저장되었습니다');
				}
			},
		} );
	});
	$('#btnSecialDayInsert').on('click', function(){
		let $form = $('#formSpecialDay');
		let locDate =  $form.find('#locDate').val();
		let dateKind =  $form.find('#dateKind').val();
		let holidayYn =  $form.find('input[name=holidayYn]:checked').val();
		let dateName =  $form.find('#dateName').val();
		if(dateName.length < 1){
			alert('명칭을 넣어주세요');
			return ;
		}
		var data = {
				locDate: locDate,
				dateKind: dateKind,
				holidayYn: holidayYn,
				dateName: dateName
			};
		
		JuliaUtil.ajax("/sepcialday/insert", data, {
			method:'POST',
			success : (response) => {
				console.log(response);
				if(response.result == 'OK'){
					$form.find('#locDate').val('');
					$form.find('#dateName').val('');
					alert('저장되었습니다');
				}
			},
		} );
	});
	//-------------------------------------------------
	//offcanva show hide
	$('#btnEditSchedule').on('click', function(){
		scheduleOffcanvas.show();
	});
	$('#btnSchedulaClose').on('click', function(){
		scheduleOffcanvas.hide();
	});
	$('#btnSpecialDay').on('click', function(){
		specialDayOffcanvas.show();
	});
	//-------------------------------------------------
	$('#btnOpenApiDbInsert').on('click', function(){
		JuliaUtil.ajax('/openApi/holiday',null,{
			success : (response)=>{
				console.log(response);
			}
		})
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