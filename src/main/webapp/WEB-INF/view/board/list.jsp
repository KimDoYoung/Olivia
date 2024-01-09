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
<title><c:out value="${pageTitle }" default="board" /></title>
</head>
<body>
<!-- =================================================== -->
<jsp:include page="../common/top-menu.jsp" flush="false" />
<!-- =================================================== -->
<main class="container">
	<button id="btnInsertPage">추가</button>
	<table class="table table-sm table-hover mt-3 userTable" style="font-size:small">
	  <thead class="table-light">
	    <tr>
	      <th scope="col" class="text-center" style="width:50px">No</th>
	      <th scope="col">제목</th>
	      <th scope="col">수정</th>
	    </tr>
	  </thead>
	  <tbody class="table-group-divider">
	  	<c:forEach var="board" items="${list}" varStatus="status">
		    <tr class="align-middle">
		      <td scope="row" class="text-center fw-bold">${status.count }</td>
		      <td>${board.title}</td>
		      <td><a href="#" class="btnUpdate" data-board-id="${board.boardId }"><i class="bi bi-pencil"></i></a></td>
		    </tr>
	    </c:forEach>
	  </tbody>
	</table>	
</main>
<!-- =================================================== -->
<jsp:include page="../common/footer.jsp" flush="false" />
<!-- -================================================== -->
<script>
$( document ).ready(function() {
	console.log('board list');
	$('#btnInsertPage').on('click', function(){
		JuliaUtil.submitGet("/board/insert");
	});
	$('.btnUpdate').on('click', function(){
		var boardId = $(this).data('board-id');
		JuliaUtil.submitGet("/board/update", {boardId: boardId});
	});
});
</script>	
</body>
</html>