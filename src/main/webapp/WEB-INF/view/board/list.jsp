<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
   
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="kfs" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="olivia"  uri="/WEB-INF/olivia-tags/olivia.tld"%>

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
              <input type="hidden" id="pageSize" value="${param.pageSize}" >
              <input type="hidden" id="currentPageNumber"  value="${param.currentPageNumber}">
              <input type="text" id="searchText"  value="${param.searchText }" class="form-control" placeholder="검색어, 태그명 입력...">
            </div>
          </div>
          
          <!-- 검색, 초기화, 추가 버튼 -->
          <div class="col-md-6">
            <button type="button" class="btn btn-primary me-2" id="btnSearch">
              <i class="bi bi-search"></i> 검색
            </button>
            
            <button type="button" class="btn btn-secondary me-2" id="btnInit">
              <i class="bi bi-arrow-counterclockwise"></i> 초기화
            </button>
            
            <button type="button" class="btn btn-success" id="btnInsertPage">
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
		      <td scope="row" class="text-center fw-bold">${(pageAttr.currentPageNumber -1 ) * pageAttr.pageSize + status.count }</td>
		      <td class="text-start"><a href="/board/view/${board.boardId}"><c:out value="${board.title}"/></a></td>
		      <td><olivia:displayYmd ymd="${board.startYmd }"/> ~ <olivia:displayYmd ymd="${board.endYmd }"/></td>
		      <td><olivia:displayDate date="${board.createOn}"/></td>
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
	<div class="page-information mt-2">
	    <div class="row">
	        <div class="col"><kfs:Pagination pageAttr="${pageAttr }" id="pageAttr"></kfs:Pagination> </div>
	        <div class="col"><kfs:PageInfo pageAttr="${pageAttr }" id="pageAttr"></kfs:PageInfo> </div>
	    </div>
	</div>
	</section>
</main>
<!-- =================================================== -->
<jsp:include page="../common/footer.jsp" flush="false" />
<!-- -================================================== -->
<script>
$( document ).ready(function() {
	console.log('board list');
// 	function parameterData(){
		
// 		var pageSize = $('#pageSize').val();
// 		var currentPageNumber = $('#currentPageNumber').val();
// 		var searchText = $('#searchText').val();
// 		return {
// 			pageSize: pageSize,
// 			currentPageNumber : currentPageNumber,
// 			searchText : searchText
// 		}
// 	}

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
	$('.btnDelete').on('click', function(){
		if(confirm('삭제하시겠습니까?')){
			var boardId = $(this).data('board-id');
			JuliaUtil.submitGet("/board/delete/" + boardId);			
		}
	});
	//검색창에서 enter이면 조회
	$("#searchText").on("keyup",function(key){
        if(key.keyCode==13) { //enter
        	$('#btnSearch').trigger('click');
        }else if(key.keyCode == 46){ //DEL
        	$(this).val('');
        }
	});	
	$('#btnSearch').on('click', function(){
		console.log('search ...');
		$('#currentPageNumber').val(1);
		var data = parameterData();
		JuliaUtil.submitGet("/board",data);
	});
	$('#btnInit').on('click', function(){
		console.log('init ...');
		$('#searchText').val('');
		$('#currentPageNumber').val(1);
		var data = parameterData();
		JuliaUtil.submitGet("/board",data);
	});
});
function parameterData(){
	
	var pageSize = $('#pageSize').val();
	var currentPageNumber = $('#currentPageNumber').val();
	var searchText = $('#searchText').val();
	return {
		pageSize: pageSize,
		currentPageNumber : currentPageNumber,
		searchText : searchText
	}
}
function goPageClick(pageNo){
	$('#currentPageNumber').val(pageNo);
	var data = parameterData();
	JuliaUtil.submitGet("/board",data);
}

</script>	
</body>
</html>