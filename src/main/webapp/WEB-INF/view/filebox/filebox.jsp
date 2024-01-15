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
    	<div class="list mt-2">
    		<ul>
    			<c:forEach var="filebox" items="${list}" varStatus="status"> 
    			<li><a href="#" class="filebox-item" data-box-id="${filebox.boxId}">${filebox.folderNm }</a> </li>
    			</c:forEach>
    		</ul>
    	</div>
    	<div id="div-filebox" class="mt-2"></div>
    	
    	<div class="form mt-2">	
	    	<form action="/filebox/add-folder" method="post">
	    	 <input type="hidden" name="parentId" id="parentId" value="1"/>
	    	 <div class="mb-3">
	            <label for="name" class="form-label">폴더명</label>
	            <input type="text" class="form-control" id="folderNm" name="folderNm" placeholder="폴더명을 입력하세요" required>
	        </div>
	    	 <div class="mb-3">
	            <label for="note" class="form-label">설명</label>
	            <input type="text" class="form-control" id="note" name="note" placeholder="폴더에 대한 간단설명" required>
	        </div>
	    	<button type="submit">add-folder</button>
	    	</form>
	    	<button id="btnSendAjax">add-folder(ajax)</button>        
    	</div>
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
	
	
	
	$('#btnSendAjax').on('click', function(){
		var parentId = $('#parentId').val();
		var folderNm = $('#folderNm').val();
		var note = $('#note').val();
		addFolder({parentId:parentId, folderNm:folderNm, note:note});
	});
	
	function addFolder(data){
		var dataToSend = data;
	    $.ajax({
            url: '/filebox/add-folder',
            method: 'POST',
            contentType: 'application/json', // 전송하는 데이터의 타입을 JSON으로 설정
            data: JSON.stringify(dataToSend), // 데이터를 JSON 문자열로 변환하여 전송
            success: function(response) {
                // 성공 시 서버에서 받은 응답 처리
                debugger;
                console.log('Server Response:', response);
            },
            error: function(error) {
                debugger;
                // 실패 시 에러 처리
                console.error('Error:', error);
            }
        });	
	}
	//----------------------------------------
	$.ajax({
        url: '/filebox/tree-data',  // 실제 서버 엔드포인트에 맞게 변경
        method: 'GET',
        dataType: 'json',
        success: function (serverData) {
            // jstree에서 사용할 데이터로 가공
            var treeData = serverData.map(function (item) {
                return {
                    id: item.file_id.toString(),
                    text: item.folderNm,
                    parent: (item.parent_id !== null) ? item.parent_id.toString() : "#",
                    children: true
                };
            });

            // jstree 초기화
            $('#tree').jstree({
                'core': {
                    'data': treeData
                }
            });
        },
        error: function (error) {
            console.error('Error fetching tree data:', error);
        }
    });	
});
</script>	
</body>
</html>