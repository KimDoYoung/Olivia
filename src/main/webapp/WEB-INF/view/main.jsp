<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
    
<!DOCTYPE html>
<html>
<head>
<!-- =================================================== -->
<jsp:include page="common/meta_css.jsp" flush="false" />
<!-- =================================================== -->
<title><c:out value="${pageTitle }" default="Olivia" /></title>
</head>
<body>
<!-- =================================================== -->
<jsp:include page="common/top-menu.jsp" flush="false" />
<!-- =================================================== -->
<main class="container-flud text-center">
<h1>Main</h1>
<ul>
	<li>게시판에 검색어 넣기</li>
	<li>페이징처리</li>
</ul>
</main>
<!-- =================================================== -->
<jsp:include page="common/footer.jsp" flush="false" />
<!-- -================================================== -->
<script>
$( document ).ready(function() {
});
</script>	
</body>
</html>