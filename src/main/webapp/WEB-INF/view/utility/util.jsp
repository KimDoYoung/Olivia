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
	<h1>javascript utilities</h1>
</div>
<!-- =================================================== -->
<jsp:include page="../common/footer.jsp" flush="false" />
<!-- -================================================== -->
<script>
$( document ).ready(function() {
	console.log('javascript utilities');
});
</script>	
</body>
</html>