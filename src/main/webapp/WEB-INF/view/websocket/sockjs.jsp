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
     <h1>메세지 전송</h1>
     <div class="row">
         <div class="col-md-6 offset-md-3">
             <div class="card">
                 <div class="card-body">
                     <div id="messages" class="mb-3"></div>
                     <input type="text" id="messageInput" class="form-control" placeholder="Enter a message">
                     <button class="btn btn-primary mt-3" id="sendButton">Send</button>
                 </div>
             </div>
         </div>
     </div>
 </div>
<!-- =================================================== -->
<jsp:include page="../common/footer.jsp" flush="false" />
<!-- -================================================== -->
 <script src="https://cdn.jsdelivr.net/npm/sockjs-client/dist/sockjs.min.js"></script>
 <script src="https://cdn.jsdelivr.net/npm/stompjs/lib/stomp.min.js"></script>
<script>
$( document ).ready(function() {
	console.log('sockjs & STOMP - test...');
    var stompClient = null;

    function connect() {
        var socket = new SockJS('/gongji');
        stompClient = Stomp.over(socket);
        stompClient.connect({}, function(frame) {
            console.log('Connected: ' + frame);
            stompClient.subscribe('/topic/messages', function(message) {
                showMessage(message.body);
            });
        });
    }

    function sendMessage() {
        var message = $('#messageInput').val();
        stompClient.send("/app/message", {}, message);
        $('#messageInput').val('');
    }

    function showMessage(message) {
        $('#messages').append('<div class="alert alert-secondary">' + message + '</div>');
    }

    $('#sendButton').click(function() { sendMessage(); });

    connect();
	
});
</script>	
</body>
</html>