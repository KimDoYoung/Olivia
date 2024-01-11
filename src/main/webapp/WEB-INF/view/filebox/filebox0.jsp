<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
   
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
    
<!DOCTYPE html>
<html lang="en">
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

     .container {
         display: flex;
         border: 1px solid #cbd5e0;
         height: calc(100% - 70px);
         width: 100%;
         margin-bottom: 20px;
         margin-top: 50px;
     }

     .container__left {
         align-items: center;
         display: flex;
         justify-content: center;
         min-width: 75px; /* 최소 너비 설정 */
     }

     .resizer {
         background-color: #cbd5e0;
         cursor: ew-resize;
         height: 100%;
         width: 2px;
     }

     .container__right {
         flex: 1;
         align-items: center;
         display: flex;
         justify-content: center;
     }
 </style>
</head>
<body>
<!-- =================================================== -->
<jsp:include page="../common/top-menu.jsp" flush="false" />
<!-- =================================================== -->

<div class="container">
    <!-- 왼쪽 div -->
    <div class="container__left">
        <div style="width:500px; background-color: lightcyan;">1111</div>
    </div>
    <div class="resizer" id="dragMe"></div>
    <!-- 오른쪽 div -->
    <div class="container__right">Right</div>
</div>

<!-- =================================================== -->
<jsp:include page="../common/footer.jsp" flush="false" />
<!-- -================================================== -->
<script>
$( document ).ready(function() {
	console.log('board list');
        // Query the elements
        const $resizer = $('#dragMe');
        const $leftSide = $resizer.prev();
        const $rightSide = $resizer.next();

        // 초기 왼쪽 div의 넓이 설정
        $leftSide.width($rightSide.width() / 2);

        // The current position of the mouse
        let x = 0;
        let leftWidth = 0;

        // Handle the mousedown event
        // that's triggered when the user drags the resizer
        const mouseDownHandler = function (e) {
            // Get the current mouse position
            x = e.clientX;
            leftWidth = $leftSide.width();

            // Attach the listeners to document
            $(document).on('mousemove', mouseMoveHandler);
            $(document).on('mouseup', mouseUpHandler);
        };

        const mouseMoveHandler = function (e) {
            // How far the mouse has been moved
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

            // Remove the handlers of mousemove and mouseup
            $(document).off('mousemove', mouseMoveHandler);
            $(document).off('mouseup', mouseUpHandler);
        };

        // Attach the handler
        $resizer.on('mousedown', mouseDownHandler);
    });
</script>	
</body>
</html>