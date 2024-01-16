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
        /* Custom icon for closed nodes */
        .jstree-closed > .jstree-anchor > .jstree-icon {
            background: url('css/close-folder.svg') no-repeat center center;
            background-size: 16px 16px; /* Adjust the size as needed */
            text-color : blue;
        }
        /* Custom icon for opened nodes */
        .jstree-open > .jstree-anchor > .jstree-icon {
            background: url('css/open-folder.svg') no-repeat center center;
            background-size: 16px 16px; /* Adjust the size as needed */
            text-color : blue;
        }
        /* Custom icon for toggle button (using Unicode characters) */
/*         .jstree-closed > .jstree-anchor > .jstree-themeicon:before { */
/*             content: '\2b'; /* Unicode character for "+" */ */
/*             color: #333; /* Color of the toggle button */ */
/*         } */
/*         .jstree-open > .jstree-anchor > .jstree-themeicon:before { */
/*             content: '\2212'; /* Unicode character for "-" */ */
/*             color: #333; /* Color of the toggle button */ */
/*         } */
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
    	<header class="mt-3">
    		<h2>파일 보관함</h2>
    	</header>
    	<div id="divJsTree" class="mt-2"></div>
    	<div>
    	<button id="btnOpenAll">open all</button>
    	<button id="btnCloseAll">close all</button>
    	</div>
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
    	<header class="mt-3">
    		<h2><span id="path-display"></span></h2>
    	</header>
    	<div id="button-area">
    		<form id="formFileUpload"  method="post" enctype="multipart/form-data">
    			<input type="hidden" name="parentId" id="form-file-upload-parentid"/>
				<label for="file">파일 선택:</label>
				<input type="file" id="files" name="files" accept=".pdf, .doc, .docx, .txt" multiple required> <!-- 허용할 파일 확장자 지정 -->
				<button type="submit">업로드</button>
    		</form>
    	</div>
    </div>
    </div>
</div>

<!-- =================================================== -->
<jsp:include page="../common/footer.jsp" flush="false" />
<!-- -================================================== -->

<script>
$( document ).ready(function() {
	console.log('board list1');
	
	var $jsTree;
	$('#btnCloseAll').on('click', function(){
 		$jsTree.jstree('close_all');
//		 $jsTree.jstree('toggle_all');
	});
	$('#btnOpenAll').on('click', function(){
		console.log('btn open all');
		$jsTree.jstree('open_all');
		//$('#jstree').jstree('open_all');
		//$jsTree.jstree('open_all');
		
// 		var allClosed = $('#jstree').jstree('is_closed', -1); // -1 represents the root node
// 		console.log("All Nodes Closed:", allClosed);
// 		if(allClosed.length == 0){
// 		}else {
// 			$jsTree.jstree('close_all');
// 		}
	});
	
	$('#formFileUpload').submit(function(){
		console.log('form file upload...');
	});
	
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
                //debugger;
                console.log('Server Response:', response);
            },
            error: function(error) {
                //debugger;
                // 실패 시 에러 처리
                console.error('Error:', error);
            }
        });	
	}
//----------------------------------------
	var jsTreeConfig  = {
		"core": {
		    "themes": {
		       "responsive": false
		    }
		},
		"types" : {
		    "default": {
	            "icon": "bi bi-folder2 text-primary"
	        }			
		},
		'plugins' : ["dnd","contextmenu","types"]	
	};
	$.ajax({
        url: '/filebox/tree-data/1',  // 실제 서버 엔드포인트에 맞게 변경
        method: 'GET',
        dataType: 'json',
        success: function (response) {
            // jstree에서 사용할 데이터로 가공
            //debugger;
            var list = response.list;
            var treeData = list.map(function (item) {
                return {
                    id: item.boxId.toString(),
                    text: item.folderNm,
                    parent: (item.level !== 0) ? item.parentId.toString() : "#"
                };
            });
			jsTreeConfig.core.data = treeData;
			createJsTree(jsTreeConfig);
        },
        error: function (error) {
        	debugger;
            console.error('Error fetching jsTree data:', error);
        }
    });	
	
//create $jsTree
function createJsTree(jsTreeConfig){
	$jsTree = $('#divJsTree').jstree(jsTreeConfig);	
	//노드가 선택되었을 때
	$jsTree.on('select_node.jstree', function(e, data) {
	    var selectedNodeId = data.node.id;
	    console.log(selectedNodeId);
	    // /filebox/3/upload-files
	    $('#formFileUpload').prop('action', '/filebox/' + selectedNodeId + "/upload-files");
	    
	 	// 선택된 노드의 경로(조상들)를 가져옵니다.
	    var path = $jsTree.jstree('get_path', data.node, ' > ');
	     // Display the path for the selected node
	    //displayPath(path);
	     $('#path-display').text(path);
	});
}


// Function to display the path
function displayPath(path) {
    var pathDisplay = $('#path-display');
    pathDisplay.empty();

    // Iterate through the path and display each node's text
    path.forEach(function(nodeId, index) {
        var nodeText = $jsTree.jstree('get_text', nodeId);
        pathDisplay.append(nodeText);

        // Add a separator if it's not the last node in the path
        if (index < path.length - 1) {
            pathDisplay.append(' > ');
        }
    });
}  
//------------------------------------------------------
// 폴더 선택 시 데이터를 가져와서 파일 목록을 보여준다.
//------------------------------------------------------
	
});



</script>	
</body>
</html>