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
   
 </style>
</head>
<body>
<!-- =================================================== -->
<jsp:include page="../common/top-menu.jsp" flush="false" />
<!-- =================================================== -->

<div class="container">
	<div class="row">
    <!-- 왼쪽 div -->
    <div class="col-4">
    	<form action="/filebox/add-folder" method="get">
    	 <input type="hidden" name="parentId" value="1"/>
    	 <div class="mb-3">
            <label for="name" class="form-label">폴더명</label>
            <input type="text" class="form-control" id="name" placeholder="폴더명을 입력하세요" required>
        </div>
    	 <div class="mb-3">
            <label for="name" class="form-label">설명</label>
            <input type="text" class="form-control" id="note" placeholder="폴더에 대한 간단설명" required>
        </div>
    	<button type="submit">add-folder</button>        
    	</form>
    </div>
    <!-- 오른쪽 div -->
    <div class="col-8">
    	Right
    </div>
    </div>
</div>

<!-- =================================================== -->
<jsp:include page="../common/footer.jsp" flush="false" />
<!-- -================================================== -->
<script>
$( document ).ready(function() {
	console.log('board list');
});
</script>	
</body>
</html>