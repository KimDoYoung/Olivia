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
<title><c:out value="${pageTitle }" default="board-view" /></title>
</head>
<body>
<!-- =================================================== -->
<jsp:include page="../common/top-menu.jsp" flush="false" />
<!-- =================================================== -->
<article class="container">
	<header class="mt-3">
		<h2>${board.title }</h2>
		<p class="m-0">작성자: <span class="author">${board.createBy }</span>
		<time datetime="${board.createOn }">게시일 : ${board.createOn }</time>
		<p>
	</header>
	<section class="bg-light mt-3">
		<h2>글의 내용</h2>
		<div>
			<c:out value="${board.content }" escapeXml="false"/>
		</div>
	</section>
	<section class="mt-3">
		<h2>태그</h2>
		<ul class="tags">
			<c:forEach var="tag" items="${board.tagSet}" varStatus="status">
				<li><span class="badge bg-success rounded-pill mr-2">${tag.name }</span>
			</c:forEach>
		</ul>
	</section>
	<section class="mt-3">
		<h2>첨부파일</h2>
		<ul class="attached-file list-group">
			<c:forEach var="file" items="${board.fileList}" varStatus="status">
				<li><a href="/download">${file.orgName }</a>
			</c:forEach>
		</ul>
	</section>	
	<footer class="mt-5">
		<div>
			<button id="btnGoList" class="btn btn-primary mr-2">리스트로 돌아가기</button>
			<button id="btnDelete" data-board-id="${board.boardId }" class="btn btn-danger mr-2">삭제</button>
			<button id="btnEdit"  data-board-id="${board.boardId }"  class="btn btn-warning" >수정</button>
		</div>		
	</footer>
</article>

<!-- =================================================== -->
<jsp:include page="../common/footer.jsp" flush="false" />
<!-- -================================================== -->
<script>
$( document ).ready(function() {
	console.log('board view...');
	$('#btnGoList').on('click', function(){
		JuliaUtil.submitGet("/board");
	});
	$('#btnDelete').on('click', function(){
		var boardId = $(this).data('board-id');
		if(confirm("삭제하시겠습니까?") == false) return;
		JuliaUtil.submitGet("/board/delete/"+boardId);
	});
	$('#btnEdit').on('click', function(){
		var boardId = $(this).data('board-id');
		JuliaUtil.submitGet("/board/update/"+boardId);		
	});

});
</script>	
</body>
</html>