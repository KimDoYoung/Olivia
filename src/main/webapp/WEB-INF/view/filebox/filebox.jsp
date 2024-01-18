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
    	<section id="fileinfo-section">
    	<div id="fileinfo-path-area" class="mt-3">
    		<h2><span id="path-display">파일박스 선택되지 않음</span></h2>
    	</div>
        <div id="fileinfo-search-area" class="search-container mt-3 mx-2 ">
        	<div class="d-flex  justify-content-between">
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
        </div>

    	<div id="fileinfo-table-area" class="mt-3">
    		
    	</div>
    	</section>
    </div>
    </div>
</div>

<!-- Create sub 컨테이너 -->
<div class="modal fade" id="createSubFilebox" tabindex="-1" aria-labelledby="createSubFileboxLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header bg-light">
        <h5 class="modal-title" id="createSubFileboxLabel">파일 박스 만들기</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <p class="text-muted fs-6 mb-4"><span id="parent-box-nm">총무팀</span> 하위에 만들어질 폴더(파일박스)들</p>
        <input type="hidden" id="parentBoxId" />
        <input type="text" class="form-control mb-2" name="subFilebox" placeholder="파일박스명을 넣어주세요"/>
        <input type="text" class="form-control mb-2" name="subFilebox" placeholder="파일박스명을 넣어주세요"/>
        <input type="text" class="form-control mb-2" name="subFilebox" placeholder="파일박스명을 넣어주세요"/>
        <input type="text" class="form-control mb-2" name="subFilebox" placeholder="파일박스명을 넣어주세요"/>
        <input type="text" class="form-control mb-2" name="subFilebox" placeholder="파일박스명을 넣어주세요"/>
      </div>
      <div class="modal-footer border-0">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="button" class="btnCreateFilebox btn btn-primary">하위 파일박스 만들기</button>
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
   
	var $jsTree;
	var treeData;

	  // 컨텍스트 메뉴 항목 정의

	
	
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
	$('#fileinfo-path-area').on('click', '.btnBreadcrumb',function(){
		var boxId = $(this).data('box-id');
		$jsTree.jstree('deselect_all');
		$jsTree.jstree('select_node', boxId);
		//makeFileInfoSection(boxId);
		
	});
	//파일 리스트 테이블 events
	//모두체크가 체크될때
	$('#fileinfo-table-area').on('click','#allFileCheck', function(e){
		e.stopPropagation();
		var checked = $(this).is(':checked');
		$('#fileinfo-table-area table tbody').find('.chkFile').prop('checked', checked);		
	});
	$('#fileinfo-table-area').on('click','.chkFile', function(e){
		e.stopPropagation();
		var fileCount = $('#fileinfo-table-area table tbody').find('input[name=chkFile]').length;	
		var checkedCount = $('#fileinfo-table-area table tbody').find('input[name=chkFile]:checked').length;
		$('#fileinfo-table-area').find('#allFileCheck').prop('checked', fileCount == checkedCount);
	});
	//-------------------------------------------------------
	// buttons
	//-------------------------------------------------------
	$('#fileinfo-search-area').on('click','#btnSearch', function(){
		console.log('btnSearch');
	});
	$('#fileinfo-search-area').on('click','#btnInitSearch', function(){
		//makeFileInfoSection(2);
		console.log('btnInitSearch');
	});

	//Delete button click
	$('#fileinfo-search-area').on('click','#btnDeleteFile', function(e){
		e.stopPropagation();
		var checkedValues = $('#fileinfo-table-area table tbody').find('input[name=chkFile]:checked')
					.map(function() {
            				return $(this).val();
        			}).get();
		if( checkedValues.length < 1 ){
			alert("삭제할 파일을 선택해 주십시오");
			return;
		}
		console.log("checkValues:" + checkedValues);
		var boxId = $('#form-file-upload-box-id').val();
		if(boxId == false){
			alert('선택된 파일박스가 없습니다');
			return;
		}
		
		if(confirm('선택된 파일 ' + checkedValues.length +"개를 삭제하시겠습니까?") == false) return;
		
		var url = '/filebox/' + boxId + '/delete-file' 
        // Ajax 요청
        $.ajax({
            url: url, // 실제 서버 엔드포인트로 대체해야 함
            type: 'POST',
            data: JSON.stringify( checkedValues ), // 배열을 JSON 형태로 전송
            contentType: 'application/json',
            dataType : 'json',
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
		"check_callback" : true,
		'plugins' : ["contextmenu","types"],
//         'contextmenu' : {
//     		"items" : {
//     		  "create" : { 
//             		"separator_before" : false,
//     				    "separator_after" : true,
//     				    "label" : "메뉴추가",
//     				    "action" : function(t){
//     				    	alert('111');
//     				    	var i=$.jstree.reference(t.reference),r=i.get_node(t.reference);i.create_node(r,{},"last",(function(e){try{i.edit(e)}catch(t){setTimeout((function(){i.edit(e)}),0)}}))
//     				    }
//     			},
//     			"rename" : {
//     				    "separator_before" : false,
//     				    "separator_after" : true,
//     				    "label" : "이름바꾸기",
//     				    "action" : function(t){var i=$.jstree.reference(t.reference),r=i.get_node(t.reference);i.edit(r)}
//     			},
//     			"remove" : {
//     				    "separator_before" : false,
//     				    "separator_after" : true,
//     				    "label" : "삭제",
//     				    "action" : function(t){var i=$.jstree.reference(t.reference),r=i.get_node(t.reference);i.is_selected(r)?i.delete_node(i.get_selected()):i.delete_node(r)}
//     			}
//     		}
//     	}
	    "contextmenu": {
	        "items": function ($node) {
	            var tree = $("#SimpleJSTree").jstree(true);
	            return {
	                "Create": {
	                    "separator_before": false,
	                    "separator_after": true,
	                    "label": "파일박스 생성 ",
	                    "action": function (t) {
	                        //tree.create($node);
	                        var i=$.jstree.reference(t.reference),node=i.get_node(t.reference);
	                        showModalCreateFolder(node);
	                    }

	                },
	                "Rename": {
	                    "separator_before": false,
	                    "separator_after": false,
	                    "label": "Rename",
	                    "action": function (obj) {
	                        tree.edit($node);
	                    }
	                },
	                "Remove": {
	                    "separator_before": false,
	                    "separator_after": false,
	                    "label": "Remove",
	                    "action": function (obj) {
	                        tree.delete_node($node);
	                    }
	                },
	                "Upload": {
	                    "seperator_beore": false,
	                    "seperator_after": false,
	                    "label": "Upload",
	                    "action": function (obj) {
	                        tree.upload_node($node);
	                    }
	                }
	            };
	        }
	    }
	};
	$.ajax({
        url: '/filebox/tree-data/0',  // 실제 서버 엔드포인트에 맞게 변경
        method: 'GET',
        dataType: 'json',
        success: function (response) {
            var list = response.list;
            treeData = list.map(function (item) {
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
        	//debugger;
            console.error('Error fetching jsTree data:', error);
        }
    });	
//---------------------------------------------------
// context menu
//---------------------------------------------------
function showModalCreateFolder(node){
	console.log(node);
	alert(node.id);
	$('#createSubFilebox').modal('show');
}	
//create $jsTree
function createJsTree(jsTreeConfig){
	$jsTree = $('#divJsTree').jstree(jsTreeConfig);	
	//노드가 선택되었을 때
	$jsTree.on('select_node.jstree', function(e, data) {
		//debugger;
	    var boxId = data.node.id;
	    console.log(boxId);
	    makeFileInfoSection(boxId);
	});
// 	$jsTree.on('contextmenu.jstree', function (e, data) {
// 		console.log(e, data);
// 		//var clickedMenuItemId = data.menu_item.id;
//  		var clickedMenuItemId = data.node.id;
// 	    // 사용자 정의 함수 호출
// 	    if (clickedMenuItemId === 'create') {
// 	      myCreateFunction();
// 	    }
// 	});	
	$jsTree.bind('create_node.jstree', function(evt, data) {
		alert('111');
	});
	$jsTree.bind("rename_node.jstree", function (node, text, old) {
		alert('rename');
	});

	
}
function makeFileInfoSection(boxId){
    console.log(boxId);
    $('#form-file-upload-box-id').val(boxId);

    var selected = findNodeById(boxId);
    
    var path=[];
    var node = selected;
    do{
     path.push(node);
     var parent = node.parent;
     node = findNodeById(parent)
    }while(node);
    
    var path_desc = path.reverse();
	//var parents = selected.parents.reverse().filter(function(item){ return item !== '#'});
// 	var node_path = parents.map(function(id) {
// 	        return treeData.find(function(node) { return node.id === id; });
// 	    });	
    displayPath(path_desc);
    //$('#path-display').text(path);
     
     //파일목록
     var url = '/filebox/file-list/'+boxId;
     $.get(url, function(response){
    	 console.log(response);
    	 makeFileList(response.list);
     }, "json");
}
function findNodeById(boxId){
	return treeData.find(item => item.id == boxId);
}

// node_path_array
function displayPath(node_path_array) {
	var seperator = ' / ';
	var pathArray = [];
	for(var i=1; i < node_path_array.length; i++){
		var node = node_path_array[i];
		if(i == node_path_array.length -1){
			pathArray.push( '<span>' + node.text + '</span>' );
		}else{
			pathArray.push( '<a class="btnBreadcrumb" href="#" data-box-id="'+node.id+'">'+node.text+'</a>' );
		}
	}
	
// 	var pathArray = node_path_array.map(function(node) {
// 	    //return '<a href="javascript:makeFileList('+node.id+');">'+node.text+'</a>';
// 	    return '<a class="btnBreadcrumb" href="#" data-box-id="'+node.id+'">'+node.text+'</a>';
// 	});
	var html = pathArray.join(seperator);
	console.log(html);
	$('#path-display').html(html);
//     var s = '';
// 	paths.forEach(function(path, index) {
// 		s += path + ' / '
//     });
// 	if(s.endsWith(' / ')){
// 		s = s.substring(0,s.lastIndexOf(' / '));
// 	}
//     $('#path-display').html(paths.join(seperator));
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
	$('#fileinfo-table-area').html(html);
}
	

}); //end of document ready 

function makeFileList(boxId){
	console.log(boxId);
	//$jsTree.on('select_node.jstree'
//     var url = '/filebox/file-list/'+boxId;
//     $.get(url, function(response){
//    	 console.log(response);
//  	 //var html = makeHtmlWithHandlebar('#table-template', {list:list});
//  	 var data = {list: response.list};
//      var template = $('#table-template').html();
//      var compiledTemplate =  Handlebars.compile(template); // compile 함수가 함수를 리턴함
//      var html = compiledTemplate(data);
 	 
// 	 $('#file-list-area').html(html);
//     }, "json");
}


</script>	
</body>
</html>