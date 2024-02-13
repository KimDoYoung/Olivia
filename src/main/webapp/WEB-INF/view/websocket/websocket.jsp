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

 </style>
</head>
<body>
<!-- =================================================== -->
<jsp:include page="../common/top-menu.jsp" flush="false" />
<!-- =================================================== -->
<div class="container">
        <h1>Simple Chat</h1>
        <input type="text" id="messageInput" class="form-control" placeholder="Enter your message">
        <input type="hidden" id="username" value="${userName }"/>
        <button id="sendButton" class="btn btn-primary mt-2">Send</button>
<!--         <ul id="messageArea" class="list-group mt-3"></ul> -->
    </div>
 <div class="position-fixed bottom-0 end-0 p-3">
     <div id="toastSystemAlram" class="toast hide " role="alert" aria-live="assertive" aria-atomic="true" data-bs-autohide="false">
         <div class="toast-header text-danger bg-success-subtle">
             <strong class="me-auto">시스템 공지사항</strong>
             <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
         </div>
         <div class="toast-body bg-warning-subtle">
             <a href="https://naver.com" target="_blank" rel="noopener noreferrer">네이버</a>
             Lorem ipsum dolor sit amet consectetur adipisicing elit. Doloremque accusantium iste ea, nemo commodi repudiandae dicta molestias eius ducimus nisi iusto facilis cupiditate pariatur numquam aut vitae alias. Facere, laborum.
         </div>
     </div>
 </div> 
<!-- =================================================== -->
<jsp:include page="../common/footer.jsp" flush="false" />
<!-- -================================================== -->
 <script src="https://cdn.jsdelivr.net/npm/sockjs-client/dist/sockjs.min.js"></script>
 <script src="https://cdn.jsdelivr.net/npm/stompjs/lib/stomp.min.js"></script>
<script>
var socket = null;
var reconnectInterval = 1000; // 재연결 간격 (밀리초)
var maxReconnectInterval = 30000; // 최대 재연결 간격 (밀리초)

$(document).ready(function() {
	// 알림 권한 상태 확인
	if ("Notification" in window) {
	  if (Notification.permission === "blocked" || Notification.permission === "denied") {
	    // 알림 권한이 차단된 경우, 사용자에게 설정 변경을 안내
	    alert("알림 권한이 차단되었습니다. 알림을 받기 위해서는 브라우저 설정에서 알림 권한을 허용으로 변경해주세요.");
	  } else if (Notification.permission === "default") {
	    // 알림 권한이 아직 설정되지 않은 경우, 권한 요청
	    Notification.requestPermission().then(permission => {
	      if (permission === "granted") {
	        console.log("알림을 받을 준비가 되었습니다.");
	      }
	    });
	  }
	}
	
    $("#sendButton").click(function() {
        const messageContent = $("#messageInput").val();
        var username = $('#username').val();
        const message = {
        	sender : username,
            content: messageContent
        };
        socket.send(JSON.stringify(message));
        $("#messageInput").val(""); // Clear input after sending
    });
 
  connectWebSocket();
});
function connectWebSocket() {
    socket = new WebSocket("ws://localhost:8080/alram");

    socket.onopen = function(event) {
        console.log("Connected to WebSocket server");
    };

    socket.onmessage = function(event) {
   	  // 브라우저가 최소화되어 있거나 현재 탭이 아닐 때 알림 표시
   	  if (document.visibilityState === "hidden" && "Notification" in window && Notification.permission === "granted") {
   		  var receivedMsg = JSON.parse(event.data).content;
   		  var notification = new Notification("새로운 알림", {
	   	      	body: receivedMsg, // 실제 메시지 내용으로 교체
   	      		icon: "/image/alram.png" // 알림에 표시할 아이콘 (선택 사항)
   	    	});
   	    // 알림 클릭 이벤트
   	    notification.onclick = function() {
   	      // 사용자가 알림을 클릭하면 호출되는 함수
   	      window.open("http://localhost:8080/websocket/websocket", "_blank"); // 새 탭에서 특정 URL 열기
   	      window.focus(); // 현재 브라우저 창에 포커스 주기
   	    };   		  
   	  }else{
        showMessageOutput(JSON.parse(event.data));
   	  }
    };

    socket.onclose = function(event) {
        console.log("WebSocket connection closed");
        // 재연결 시도
        setTimeout(function() {
            reconnectWebSocket();
        }, reconnectInterval);
    };

    socket.onerror = function(error) {
        console.error("WebSocket error: ", error);
    };
} 
function reconnectWebSocket() {
    if (reconnectInterval < maxReconnectInterval) {
        reconnectInterval *= 2; // 재연결 간격을 지수적으로 증가시킴
    }
    console.log("Attempting to reconnect to WebSocket in " + reconnectInterval + " ms");
    connectWebSocket();
}
function showMessageOutput(messageOutput) {
	console.debug(messageOutput);
    var message = messageOutput.sender + ": " + messageOutput.content;
    $("#toastSystemAlram .toast-body").html(message);
    var toast = new bootstrap.Toast(document.getElementById('toastSystemAlram'));
    toast.show();
}   

</script>	
</body>
</html>