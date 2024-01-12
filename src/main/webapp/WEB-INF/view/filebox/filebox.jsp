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
	    	<button id="btnSendAjax">add-folder(ajax)</button>        
	    	</form>
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
	
	var jsTreeConfig = {
		"core": {
	        "themes": {
	            "responsive": false
	        },
	        // so that create works
	        "check_callback": true,
	        'data': {
	            'url': '/filebox',
	            'dataType': 'json',
	            'data': function (node) {
	                return { 'id': node.id };
	            },
	            'success': function (data) {
	            	console.log(data);
	            	debugger;
	            	callback.call(this, data);
	                // 사용자 지정 콜백 실행
	                //customCallback(data);
	            },
	            'error': function (error) {
                    // 데이터 가져오기 실패 시 적절한 처리 수행
                    console.error('Error fetching tree data:', error);
                }	            
	        }
	    },
	    "types": {
	        "default": {
	            "icon": "ki-outline ki-folder text-primary"
	        },
	        "file": {
	            "icon": "ki-outline ki-file  text-primary"
	        }
	    },
// 	    "state": {
// 	        "key": "demo3"
// 	    },			
// 	  	"plugins": ["dnd", "state", "types"]		
	};
	
	//var $jsTree = $('#div-filebox').jstree(jsTreeConfig);
	
	
	$('#btnSendAjax').on('click', function(){
		var parentId = $('#parentId').val();
		var folderNm = $('#folderNm').val();
		var note = $('#note').val();
		addFolder({parentId, folderNm, note});
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
                console.log('Server Response:', response);
            },
            error: function(error) {
                // 실패 시 에러 처리
                console.error('Error:', error);
            }
        });	
	}
});
</script>	
</body>
</html>