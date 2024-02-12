<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
   
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
    
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- =================================================== -->
<jsp:include page="../common/meta_css.jsp" flush="false" />
<!-- =================================================== -->
<title><c:out value="${pageTitle }" default="filebox" /></title>
    <style>
 body, html {
            height: 100%;
            margin: 10px;
        }

        .container-left-right {
            display: flex;
            border: 1px solid #cbd5e0;
            height: calc(100% - 10%);
            width: 100%;
            margin-bottom: 20px;
        }

        .container__left {
            display: flex;
            flex-direction: column; /* 세로 방향으로 아이템을 정렬 */
            align-items: flex-start; /* 왼쪽 정렬 */
            justify-content: flex-start; /* 상단 정렬 */
            min-width: 150px; /* 최소 너비 설정 */
            padding: 10px; /* 좌우 패딩 추가 */
        }

        .container__left ul {
            padding: 0;
            margin: 0; /* 기본 마진 제거 */
            list-style-type: none; /* 기본 리스트 스타일 제거 */
            width: calc(100% - 20px); /* ul의 너비를 container__left의 패딩을 고려하여 조정 */
        }
        .container__left ul li {
            margin-bottom: 15px; /* 항목 간 간격 조정 */
            list-style-type: none; /* 기본 리스트 스타일 제거 */
        }

        .container__left ul li a {
            display: block; /* 블록 레벨 요소로 만들어 너비를 100%로 설정 가능하게 함 */
            width: 100%; /* 너비를 부모의 100%로 설정 */
            padding: 0.5rem; /* 내부 패딩 추가 */
            text-decoration: none; /* 링크 밑줄 제거 */
            color: #495057; /* 텍스트 색상 설정 */
        }

        .container__left ul li a:hover {
            background-color: #e9ecef; /* 호버 시 배경색 변경 */
            color: #007bff; /* 호버 시 텍스트 색상 변경 */
        }


        .resizer {
            background-color: #cbd5e0;
            cursor: ew-resize;
            height: 100%;
            width: 3px;
        }

        .container__right {
            flex: 1;
            align-items: start;
            display: flex;
            justify-content: start;
        }
  
        /* ---- 탭부분 ---- */
		 #tab-area .nav-item {
		    width: 200px;
		    margin-right: 0px;
		    border: 1px solid #ccc;
		    border-radius: 0.5rem 0.5rem 0 0;
		    background-color: #f1f1f1;
		    overflow: hidden;
		    position: relative;
		}
		
		#tab-area .nav-link {
		    display: flex;
		    justify-content: space-between;
		    align-items: center;
		    padding: 5px;
		    white-space: nowrap;
		    overflow: hidden;
		    text-overflow: ellipsis;
		}
		
		#tab-area .nav-link span { /* 탭 제목을 위한 스타일 */
		    overflow: hidden;
		    white-space: nowrap;
		    text-overflow: ellipsis;
		}
		
		#tab-area .close {
		    visibility: hidden; /* 기본적으로 숨김 */
		    color: #dc3545; /* Bootstrap danger 색상 */
		}
		
		#tab-area .nav-item:hover .close {
		    visibility: visible; /* 호버 시 보임 */
		}
		
		#tab-area .nav-tabs .nav-link.active, 
		#tab-area .nav-tabs .nav-item.show .nav-link {
		    background-color: white; /* 선택된 탭의 배경색 변경 */
		    color: black; /* 선택된 탭의 텍스트 색상 변경 */
		    border-color: #dedce8 #dedce8 #f1f1f1; /* 경계선 색상 조정 */
		}        
        
    </style>
</head>
<body>
<!-- =================================================== -->
<jsp:include page="../common/top-menu.jsp" flush="false" />
<!-- =================================================== -->
    <div class="container">
        <h1>Utilities</h1>
    </div>
    <div class="container container-left-right">
        <!-- 왼쪽 div -->
        <div class="container__left">
            <ul class="mt-5">
                <li><a href="#none" class="menu"  id="btnPivot" data-menu-id="pivot">Pivot</a></li>
                <li><a href="#none" class="menu"  id="btnAwk" data-menu-id="awk">Awk</a></li>
                <li><a href="#none" class="menu"  id="btnSqlFormat"  data-menu-id="sqlformat">Sql format</a></li>
                <li><a href="#none" class="menu"  id="btnEncrypt"  data-menu-id="encrypt">Encrypt</a></li>
            </ul>
        </div>
        <div class="resizer" id="dragMe"></div>
        <!-- 오른쪽 div -->
        <div class="container__right">
        	    <div id="tab-area">
			        <ul class="nav nav-tabs" id="tabList" role="tablist">
			            <!-- Tabs will be dynamically added here -->
			        </ul>
			        <div class="tab-content" id="tabContent">
			            <!-- Tab content will be dynamically added here -->
			        </div>
			    </div>
        </div>
    </div>
<!-- =================================================== -->
<jsp:include page="../common/footer.jsp" flush="false" />
<!-- -================================================== -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/3.1.2/rollups/aes.js"></script>
<script src="js/tabManager.js"></script>
<script>
$( document ).ready(function() {
	console.log('javascript utilities');
    // 변수설정
    const $resizer = $('#dragMe');
    const $leftSide = $resizer.prev();
    const $rightSide = $resizer.next();

    // 초기 왼쪽 div의 넓이 설정
    //$leftSide.width($rightSide.width() / 2);
    $leftSide.width(300);

    // 마우스의 현재 위치
    let x = 0;
    let leftWidth = 0;

    // 마우스 다운 이벤트를 처리하는 핸들러
    const mouseDownHandler = function (e) {
        // 현재 마우스 위치를 얻습니다
        x = e.clientX;
        leftWidth = $leftSide.width();

        // document에 이벤트 리스너를 추가합니다
        $(document).on('mousemove', mouseMoveHandler);
        $(document).on('mouseup', mouseUpHandler);
    };

    const mouseMoveHandler = function (e) {
        // 마우스가 움직인 거리
        const dx = e.clientX - x;

        const newLeftWidth = leftWidth + dx;
        const containerWidth = $resizer.parent().width();

        // 최소 너비 제한
        if (newLeftWidth > 75 && newLeftWidth < containerWidth - 75) {
            $leftSide.width(newLeftWidth);
            $rightSide.width(containerWidth - newLeftWidth);
        }

        $resizer.css('cursor', 'col-resize');
        $('body').css('cursor', 'col-resize');

        $leftSide.css({
            'user-select': 'none',
            'pointer-events': 'none'
        });

        $rightSide.css({
            'user-select': 'none',
            'pointer-events': 'none'
        });
    };

    const mouseUpHandler = function () {
        $resizer.css('cursor', '');
        $('body').css('cursor', '');

        $leftSide.css({
            'user-select': '',
            'pointer-events': ''
        });

        $rightSide.css({
            'user-select': '',
            'pointer-events': ''
        });

        // 마우스 이동 및 마우스 업 핸들러 제거
        $(document).off('mousemove', mouseMoveHandler);
        $(document).off('mouseup', mouseUpHandler);
    };

    // 핸들러를 연결합니다
    $resizer.on('mousedown', mouseDownHandler);
    
    //tabManager
    var tabManager = new TabManager("#tab-area");
    $('.menu').on('click', function(e){
    	e.preventDefault();
		var $this = $(this);
		var id = $this.data('menu-id');
		var title = $this.text();
		//tabManager.addTab(id, title);
		tabManager.selectTab(id, title, function(id,title){
			var url = '/template/' + id.toLowerCase();
			JuliaUtil.ajax(url, undefined, {
				success: function(response){
					debugger;
					console.debug(response);
					$('#' + id).html(response.template);
					$('body').append($('<script>').text(response.javascript));
				}
			})
		});
    });
    
	
});
</script>	
</body>
</html>