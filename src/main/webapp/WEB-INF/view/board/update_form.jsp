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
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<title><c:out value="${pageTitle }" default="board-추가" /></title>
</head>
<body>
<!-- =================================================== -->
<jsp:include page="../common/top-menu.jsp" flush="false" />
<!-- =================================================== -->
<main class="container">
  <h2 class="mb-4 fw-bold">게시판 수정</h2>
  
  <form id="form1" action="/board/update" method="post"  enctype="multipart/form-data">
  	<input type="hidden" id="boardId" name="boardId" value="${board.boardId }" />
    <div class="mb-3">
        <label for="boardType" class="form-label fw-bold">게시판 유형</label>
        <c:if test="${board.boardType == '9'}"><c:set var="check9" value="checked"/></c:if>
        <c:if test="${board.boardType == '1'}"><c:set var="check1" value="checked"/></c:if>
        <div class="form-check form-check-inline">
          <input class="form-check-input" type="radio" name="boardType" id="notice" value="9" ${check9 } >
          <label class="form-check-label" for="notice">
            공지
          </label>
        </div>
        <div class="form-check form-check-inline">
          <input class="form-check-input" type="radio" name="boardType" id="general" value="1" ${check1 }>
          <label class="form-check-label" for="general">
            일반게시물
          </label>
        </div>
      </div>  
    <div class="mb-3">
      <label for="title" class="form-label fw-bold">제목</label>
      <input type="text" class="form-control" id="title" name="title" value="${board.title }" required>
    </div>
    
    <!-- Quill.js를 사용한 HTML 편집기 -->
    <div class="mb-3">
        <label for="contentQuill" class="form-label fw-bold">내용</label>
        <div id="editor" style="height: 300px;"><c:out value="${board.content }" escapeXml="false" /></div>
	    <input type="hidden" id="content" name="content" />
      </div>
    <div class="mb-3">
      <label for="tags" class="form-label fw-bold">태그</label>
      <input type="text" class="form-control" id="tags" name="tags" value="${board.tags }" >
    </div>    

    <!-- 게시 시작일과 종료일 -->
    <div class="row">
        <div class="col-md-6 mb-3 fw-bold">
          <label for="startDate" class="form-label">게시 시작일</label>
          <input type="text" class="form-control datepicker" id="startYmd" name="startYmd" autocomplete="off" value="${board.startYmd}" required>
        </div>
        <div class="col-md-6 mb-3 fw-bold">
          <label for="endDate" class="form-label">게시 종료일</label>
          <input type="text" class="form-control datepicker" id="endYmd" name="endYmd" autocomplete="off" value="${board.endYmd}" required>
        </div>
      </div>
    
    <div class="mb-3 fw-bold">
      <label for="attachment" class="form-label">파일 첨부(여러개 선택 가능)</label>
      <input type="file" class="form-control" id="attachment" name="files" multiple>
    </div>

    <div class="mb-3 ">
      <table class="table">
      	<tr><th colspan="3">기존 첨부되어 있는 파일들 </th></tr>
      	<tr>
      		<th>파일명</th>
      		<th>크기</th>
      		<th>삭제</th>
      	</tr>
		<c:forEach var="boardFile" items="${board.fileList}" varStatus="status">
      	<tr>
      		<td>${boardFile.orgName }</td>
      		<td>${boardFile.fileSize }</td>
      		<td><input type="checkbox" name="deletefiles" class="chkDeleteFile form-check" value="${boardFile.boardFileId }"/></td>
      	</tr>
		</c:forEach>
      </table>      
    </div>

    <div class="d-flex form-switch mb-5">
    	<c:if test="${board.status == 1 }"><c:set var="checkStatus" value="checked"/></c:if>
        <input class="form-check-input" type="checkbox" role="switch" id="switchStatus" name="status" value="1" ${checkStatus} />&nbsp;
        <label class="form-check-label mx-2" for="switchStatus" id="lblStatus">게시 여부</label>
    </div>
          
    <input type="hidden" name="viewCount" value="${board.viewCount }"/>
    <button type="submit" class="btn btn-primary mx-1">수정 </button>
    <button type="button" id="btnDelete" class="btn btn-danger mx-1" >삭제 </button>
    <a href="/board" role="button" class="btnGoList btn btn-warning">취소, 리스트로 돌아가기</a>
  </form>
</main>
<!-- =================================================== -->
<jsp:include page="../common/footer.jsp" flush="false" />
<!-- -================================================== -->
<script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>
<script>
$( document ).ready(function() {
	console.log('board list');
	
    // Quill.js 초기화
    var quill = new Quill('#editor', {
        theme: 'snow'
    });
	//작성중->게시로
//     $("#switchStatus").change(function () {
//         // 스위치가 on 상태인 경우
//         if ($(this).is(":checked")) {
//           $("#lblStatus").text("게시");
//         } else {
//           // 스위치가 off 상태인 경우
//           $("#lblStatus").text("작성중");
//         }
//     });
    //submit시 html의 content에 넣는다.
    $("#form1").submit(function(){
    	$('#content').val(quill.root.innerHTML);
    });
	$('#btnDelete').on('click', function(){
		if(confirm('삭제하시겠습니까?')){
			var boardId = $('#boardId').val();
			JuliaUtil.submitGet("/board/delete/" + boardId, {});
		}
	});
});
</script>	
</body>
</html>