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
<title><c:out value="${pageTitle }" default="board-추가" /></title>
</head>
<body>
<!-- =================================================== -->
<jsp:include page="../common/top-menu.jsp" flush="false" />
<!-- =================================================== -->
<main class="container">
  <h2 class="mb-4 fw-bold">게시판 입력</h2>
  
  <form action="/board/insert" method="post" enctype="multipart/form-data">
    <div class="mb-3">
      <label for="title" class="form-label fw-bold">제목</label>
      <input type="text" class="form-control" id="title" name="title" required>
    </div>
    
    <!-- Quill.js를 사용한 HTML 편집기 -->
    <div class="mb-3">
        <label for="content" class="form-label fw-bold">내용</label>
        <div id="editor" style="height: 300px;"></div>
        <input type="hidden" name="content" id="content" required>
      </div>
    
    <div class="mb-3">
        <label for="boardType" class="form-label fw-bold">게시판 유형</label>
        <div class="form-check form-check-inline">
          <input class="form-check-input" type="radio" name="boardType" id="notice" value="9" >
          <label class="form-check-label" for="notice">
            공지
          </label>
        </div>
        <div class="form-check form-check-inline">
          <input class="form-check-input" type="radio" name="boardType" id="general" value="1" checked>
          <label class="form-check-label" for="general">
            일반게시물
          </label>
        </div>
      </div>
    
    <!-- 게시 시작일과 종료일 -->
    <div class="row">
        <div class="col-md-6 mb-3 fw-bold">
          <label for="startDate" class="form-label">게시 시작일</label>
          <input type="text" class="form-control datepicker" id="startDate" name="startDate" autocomplete="off" required>
        </div>
        <div class="col-md-6 mb-3 fw-bold">
          <label for="endDate" class="form-label">게시 종료일</label>
          <input type="text" class="form-control datepicker" id="endDate" name="endDate" autocomplete="off" required>
        </div>
      </div>
    
    <div class="mb-3 fw-bold">
      <label for="attachment" class="form-label">파일 첨부(여러개 선택 가능)</label>
      <input type="file" class="form-control" id="attachment" name="attachment">
    </div>
    
    <button type="submit" class="btn btn-primary">글쓰기</button>
  </form>
</main>
<!-- =================================================== -->
<jsp:include page="../common/footer.jsp" flush="false" />
<!-- -================================================== -->
<script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>
<script>
$( document ).ready(function() {
	console.log('board list');
	$('#btnInsertPage').on('click', function(){
		JuliaUtil.submitGet("/board/insert");
	});
});
</script>	
</body>
</html>