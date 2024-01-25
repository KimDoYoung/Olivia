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
<main>
	<section id="search-area" class="container">
	    <div class="row mt-5">
          <!-- 검색 텍스트 입력란 -->
          <div class="col-md-6 mb-3">
             <div class="input-group">
              <!-- 버튼에 아이콘 추가 -->
              <button class="btn btn-warning" type="button" id="button-addon1">
                <i class="bi bi-list"></i>
              </button>
              
              <!-- 텍스트 입력란 -->
              <input type="text" class="form-control" placeholder="사용자 이름" aria-label="사용자 이름" aria-describedby="button-addon1">
            </div>
          </div>
          
          <!-- 검색, 초기화, 추가 버튼 -->
          <div class="col-md-6">
            <button type="button" class="btn btn-primary me-2">
              <i class="bi bi-search"></i> 검색
            </button>
            
            <button type="button" class="btn btn-secondary me-2">
              <i class="bi bi-arrow-counterclockwise"></i> 초기화
            </button>
            
            <button type="button" class="btn btn-success">
              <i class="bi bi-plus"></i> 추가
            </button>
          </div>
        </div>
	</section>
	<section id="list-area" class="container">
	<table class="table table-sm table-hover mt-3 userTable font-size-small">
	  <thead class="table-light">
	    <tr>
	      <th scope="col" class="text-center" style="width:50px">No</th>
	      <th scope="col" class="text-center">제목</th>
	      <th scope="col" class="text-center">게시기간</th>
	      <th scope="col" class="text-center">작성일</th>
	      <th scope="col" class="text-center">작성자</th>
	      <th scope="col" class="text-center">상태</th>
	      <th scope="col" class="text-center">첨부파일</th>
	      <th scope="col" class="text-center">수정</th>
	    </tr>
	  </thead>
	  <tbody class="table-group-divider text-center">
	  	<c:forEach var="board" items="${list}" varStatus="status">
		    <tr class="align-middle">
		      <td scope="row" class="text-center fw-bold">${status.count }</td>
		      <td class="text-start"><a href="/board/view/${board.boardId}">${board.title}</a></td>
		      <td>${board.startYmd } ~ ${board.endYmd } </td>
		      <td>${board.createOn}</td>
		      <td>${board.createBy}</td>
		      <td>
		      	<c:if test="${board.status == '1' }">
		      		<i class="bi bi-check-square text-success"></i>
		      	</c:if>
		      	<c:if test="${board.status == '0' }">
		      		<i class="bi bi-pencil-square text-danger"></i>
		      	</c:if>
		      </td>
		      <td>
		      	<c:if test="${board.attachedFileCount > 0}">
			      	<span class="badge bg-secondary">
	        			<i class="bi bi-floppy"></i> ${board.attachedFileCount}
	    			</span>
		      	</c:if>
		      </td>
		      <td class="d-flex justify-content-around">
		      	<c:choose>
		      		<c:when test="${currentUser.userId eq board.createBy}">
				      	<a href="#" class="btnUpdate" data-board-id="${board.boardId }"><i class="bi bi-pencil"></i></a>
				      	<a href="#" class="btnDelete" data-board-id="${board.boardId }"><i class="bi bi-trash"></i></a>
		      		</c:when>
		      		<c:otherwise>
		      			-
		      		</c:otherwise>
		      	</c:choose>
		      </td>
		    </tr>
	    </c:forEach>
	  </tbody>
	</table>	
	</section>
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
		JuliaUtil.submitGet("/board/update/" + boardId);			
	});
	$('.btnDelete').on('click', function(){
		if(confirm('삭제하시겠습니까?')){
			var boardId = $(this).data('board-id');
			JuliaUtil.submitGet("/board/delete/" + boardId);			
		}
	});
});
</script>	
</body>
</html>