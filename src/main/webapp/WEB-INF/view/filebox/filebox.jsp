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
    		<h2><span id="path-display">파일박스 선택되지 않음</span></h2>
    	</header>
        <div id="search-area" class="search-container mt-3 mx-2 d-flex  justify-content-between">
            <input type="text" id="searchText" name="searchText" class="form-control mx-2" placeholder="검색어를 입력하세요">
			<button id="btnSearch" class="btn btn-primary"><i class="bi bi-search"></i></button>
			<button id="btnInitSearch" class="btn btn-secondary"><i class="bi bi-arrow-counterclockwise"></i></button>
			<button id="btnUploadFile" class="btn btn-warning" data-bs-toggle="collapse" data-bs-target="#file-upload-area"><i class="bi bi-plus"></i></button>
			<button id="btnDeleteFile" class="btn btn-danger"><i class="bi bi-trash"></i></button>
        </div>
    	<div id="file-upload-area" class="collapse m-3">
   			<input type="hidden" name="boxId" id="form-file-upload-box-id" />
			<label for="file">파일 선택:</label>
			<input type="file" id="files" name="files"  multiple required> <!-- 허용할 파일 확장자 지정 -->
			<button class="btn btn-primary" id="btnFileUpload">업로드</button>
    	</div>
    	<div id="file-list-area" class="mt-3">
    		
    	</div>
    </div>
    </div>
</div>

 <script id="table-template" type="text/x-handlebars-template">
 {{#if list.length}}
        <table class="table" id="table-file-list">
            <thead>
              <tr>
                <th scope="col">#</th>
				<th scope="col"><input type="checkbox" id="allFileCheck" name="chkFile" class="form-checkbox"/></th>
                <th scope="col">파일명</th>
                <th scope="col">크기</th>
                <th scope="col">종류</th>
                <th scope="col">올린 일시</th>
              </tr>
            </thead>
            <tbody>
              {{#each list}}
              <tr scope="row">
                <th>{{inc @index}}</th>
				<th><input type="checkbox" data-file-info-id="{{fileInfoId}}" name="chkFile" class="form-checkbox chkFile" value="{{fileInfoId}}" /></th>
                <td>{{orgName}}</td>
                <td class="text-end">{{formatComma fileSize}}</td>
                <td>{{ext}}</td>
                <td>{{formatDateString createOn}}</td>
              </tr>
              {{/each}}
            </tbody>
          </table>
    {{else}}
        <p class="text-danger">데이터가 없습니다.</p>
    {{/if}}
    </script>
<!-- =================================================== -->
<jsp:include page="../common/footer.jsp" flush="false" />
<!-- -================================================== -->
<script>
  
$( document ).ready(function() {
	console.log('board list1');
	// 사용자 함수 inc 등록
	Handlebars.registerHelper("inc", function(value, options){
	        return parseInt(value) + 1;
	});
    Handlebars.registerHelper('formatComma', function (number) {
        // 숫자에 콤마 추가
        return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    });	
    Handlebars.registerHelper('formatYmdHms', function(date) {
        // date는 JavaScript Date 객체여야 함
        var year = date.getFullYear();
        var month = ('0' + (date.getMonth() + 1)).slice(-2);
        var day = ('0' + date.getDate()).slice(-2);
        var hours = ('0' + date.getHours()).slice(-2);
        var minutes = ('0' + date.getMinutes()).slice(-2);
        var seconds = ('0' + date.getSeconds()).slice(-2);

        return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes + ':' + seconds;
    });
    Handlebars.registerHelper('formatDateString', function(dateStr) {
        var months = [
            "Jan", "Feb", "Mar", "Apr", "May", "Jun",
            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
        ];

        var dateParts = dateStr.split(/[\s,]+/);
        var monthIndex = months.indexOf(dateParts[0]);
        var year = dateParts[2];
        var month = ('0' + (monthIndex + 1)).slice(-2);
        var day = ('0' + dateParts[1]).slice(-2);
        var timeParts = dateParts[3].split(':');
        var hours = ('0' + parseInt(timeParts[0])).slice(-2);
        var minutes = ('0' + parseInt(timeParts[1])).slice(-2);
        var seconds = ('0' + parseInt(timeParts[2])).slice(-2);
        var period = dateParts[4];

        return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes + ':' + seconds + ' ' + period;
    });    
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
	//파일 리스트 테이블 events
	//모두체크가 체크될때
	$('#file-list-area').on('click','#allFileCheck', function(e){
		e.stopPropagation();
		var checked = $(this).is(':checked');
		$('#file-list-area table tbody').find('.chkFile').prop('checked', checked);		
	});
	$('#file-list-area').on('click','.chkFile', function(e){
		e.stopPropagation();
		var fileCount = $('#file-list-area table tbody').find('input[name=chkFile]').length;	
		var checkedCount = $('#file-list-area table tbody').find('input[name=chkFile]:checked').length;
		$('#file-list-area').find('#allFileCheck').prop('checked', fileCount == checkedCount);
	});
	//buttons
	$('#search-area').on('click','#btnSearch', function(){
		console.log('btnSearch');
	});
	$('#search-area').on('click','#btnInitSearch', function(){
		console.log('btnInitSearch');
	});
	$('#search-area').on('click','#btnDeleteFile', function(e){
		e.stopPropagation();
//		var checkedCount = $('#file-list-area table tbody').find('input[name=chkFile]:checked');
		var checkedValues = $('#file-list-area table tbody').find('input[name=chkFile]:checked')
					.map(function() {
            				return $(this).val();
        			}).get();
// 		console.log(checkedValues);
		if( checkedValues.length < 1 ){
			alert("삭제할 파일을 선택해 주십시오");
			return;
		}
		debugger;
		checkedValues = [16,17];
		console.log("checkValues:" + checkedValues);
		var boxId = $('#form-file-upload-box-id').val();
		if(boxId == false){
			alert('선택된 파일박스가 없습니다');
			return;
		}
		var url = '/filebox/' + boxId + '/delete-file' 
        // Ajax 요청
        $.ajax({
            url: url, // 실제 서버 엔드포인트로 대체해야 함
            type: 'POST',
            contentType: 'application/json',
            dataType : 'json',
            data: JSON.stringify({ deleteFileInfoIdList: checkedValues }), // 배열을 JSON 형태로 전송
            success: function(response) {
            	//테이블 만들어서 보이기
                makeFileList(response.list);
            },
            error: function(error) {
            	console.error(error);
                alert(error);
            }
        });		
		
	});
	
	$('#btnFileUpload').on('click', function(){
		var boxId = $('#form-file-upload-box-id').val();
		var fileInput = $('#files').get(0);
		if(!boxId){
			alert("파일이 담길 파일박스를 선택해 주십시오");
			return;
		}
		var files = fileInput.files;
		if(files.length < 1){
			alert("파일을 선택해 주십시오");
			return;
		}
		 var formData = new FormData();

	    for (var i = 0; i < files.length; i++) {
	        formData.append('files', files[i]);
	    }
		var url = '/filebox/' + boxId + '/upload-files';
	    $.ajax({
            url: url,
            method: 'POST',
            //contentType: 'application/json', // 전송하는 데이터의 타입을 JSON으로 설정
            data: formData, // 데이터를 JSON 문자열로 변환하여 전송
            contentType : false,
            processData : false,
     		dataType : 'json',
            success: function(response) {
                //debugger;
                //파일선택된 것 모두 해제
                $('#files').val('');
                console.log('Server Response:', response);
                //collapse 부분 hide
                $('#file-upload-area').collapse('hide');
                //테이블 만들어서 보이기
                makeFileList(response.list);
            },
            error: function(error) {
                //debugger;
                // 실패 시 에러 처리
                console.error('Error:', error);
            }
        });	
	    return false;
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
	    var boxId = data.node.id;
	    console.log(boxId);
	    // /filebox/3/upload-files
	    //$('#formFileUpload').prop('action', '/filebox/' + selectedNodeId + "/upload-files");
	    $('#form-file-upload-box-id').val(boxId);
	    
	 	// 선택된 노드의 경로(조상들)를 가져옵니다.
	    var path = $jsTree.jstree('get_path', data.node, ' / ');
	     // Display the path for the selected node
	    //displayPath(path);
	     $('#path-display').text(path);
	     
	     //파일목록
	     var url = '/filebox/file-list/'+boxId;
	     $.get(url, function(response){
	    	 console.log(response);
	    	 makeFileList(response.list);
	     }, "json");
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

function makeHtmlWithHandlebar(templateId, data){
    var template = $(templateId).html();
    var compiledTemplate =  Handlebars.compile(template); // compile 함수가 함수를 리턴함
    var html = compiledTemplate(data);
    return html;
}
/**
 * 리스트로 table html을 만들어서 file-list-area에 넣는다
 */
function makeFileList(list){
	var html = makeHtmlWithHandlebar('#table-template', {list:list});
	$('#file-list-area').html(html);
}
	

}); //end of document ready 




</script>	
</body>
</html>