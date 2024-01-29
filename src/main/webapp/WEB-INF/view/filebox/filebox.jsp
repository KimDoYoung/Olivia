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
    	<div id="treeButtons" class="mt-2">
    		<div class="btn-group">
    			<button id="btnOpenAll" class="btn btn-warning"><i class="bi bi-folder-plus"></i></button>
    			<button id="btnCloseAll" class="btn btn-secondary"><i class="bi bi-folder-minus"></i></button>
    		</div>
    	</div>
    	<div id="divJsTree" class="mt-2"></div>
    	<div></div>
    </div>
    <!-- 오른쪽 div -->
    <div class="col-8">
    	<section id="fileinfo-section">
    	<div id="fileinfo-path-area" class="mt-3">
    		<h2><span id="path-display">파일박스 선택되지 않음</span></h2>
    	</div>
        <div id="fileinfo-search-area" class="search-container mt-3 mx-2 ">
        	<div class="d-flex  justify-content-between">
	            <input type="text" id="searchText" name="searchText" class="form-control me-2" placeholder="검색어를 입력하세요">
	            <div class="btn-group">
				<button id="btnSearch" class="btn btn-primary" title="검색"><i class="bi bi-search"></i></button>
				<button id="btnInitSearch" class="btn btn-secondary" title="초기화"><i class="bi bi-arrow-counterclockwise"></i></button>
				<button id="btnUploadFile" class="btn btn-warning" title="upload files" data-bs-toggle="collapse" data-bs-target="#file-upload-area"><i class="bi bi-plus"></i></button>
				<button id="btnDeleteFile" class="btn btn-danger" title="파일 삭제"><i class="bi bi-trash"></i></button>
				</div>
			</div>
           	<div id="file-upload-area" class="collapse m-3">
	   			<input type="hidden" name="nodeId" id="form-file-upload-node-id" />
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
                <th scope="col">동작</th>
              </tr>
            </thead>
            <tbody>
              {{#each list}}
              <tr scope="row">
                <th>{{inc @index}}</th>
				<th><input type="checkbox" data-file-info-id="{{fileId}}" name="chkFile" class="form-checkbox chkFile" value="{{fileId}}" /></th>
                <td>{{orgName}}</td>
                <td class="text-end">{{humanFileSize fileSize}}</td>
                <td>{{ext}}</td>
                <td>{{formatDateString createOn}}</td>
                <td>
					<div class="btn-group">
    				<button class="btnView btn btn-warning btn-sm" title="view"><i class="bi bi-eye bi-sm"></i></button>
    				<button class="btnDownload btn btn-secondary btn-sm" title="download"><i class="bi bi-cloud-download bi-sm"></i></button>
				    </div>
				</td>
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
	
	$('#btnCloseAll').on('click', function(){
 		$jsTree.jstree('close_all');
//		 $jsTree.jstree('toggle_all');
	});
	$('#btnOpenAll').on('click', function(){
		console.log('btn open all');
		$jsTree.jstree('open_all');
	});
	$('#fileinfo-path-area').on('click', '.btnBreadcrumb',function(){
		var nodeId = $(this).data('node-id');
		$jsTree.jstree('deselect_all');
		$jsTree.jstree('select_node', nodeId);
		//makeFileInfoSection(nodeId);
		
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
		var nodeId = $('#form-file-upload-node-id').val();
		if(nodeId == false){
			alert('선택된 파일박스가 없습니다');
			return;
		}
		
		if(confirm('선택된 파일 ' + checkedValues.length +"개를 삭제하시겠습니까?") == false) return;
		
		var url = '/filebox/delete-file/' + nodeId; 
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
            	console.error(error.responseJSON);
                alert("삭제 중 오류가 발생했습니다");
            }
        });		
		
	});
	
	//파일업로드
	$('#btnFileUpload').on('click', function(){
		var nodeId = $('#form-file-upload-node-id').val();
		var fileInput = $('#files').get(0);
		if(!nodeId){
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
		var url = '/filebox/upload-files/' + nodeId;
	    $.ajax({
            url: url,
            method: 'POST',
            //contentType: 'application/json', // 전송하는 데이터의 타입을 JSON으로 설정
            data: formData, // 데이터를 JSON 문자열로 변환하여 전송
            contentType : false,
            processData : false,
     		dataType : 'json',
            success: function(response) {
                ////debugger;
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
		       "responsive": false,
		       "dots": false 
		    },
		    "check_callback" : true,
		},
		"types" : {
		    "default": {
	            "icon": "bi bi-folder2 text-primary"
	        }			
		},
		"plugins" : ["contextmenu","types"],
	    "contextmenu": {
	        "items": function ($node) {
	            var tree = $("#divJsTree").jstree(true);
	            return {
	                "Create": {
	                    "separator_before": false,
	                    "separator_after": true,
	                    "label": "하위폴더 생성",
	                    "icon" : "text-primary bi bi-folder-plus",
						"action" : function (data) {
					    var inst = $.jstree.reference(data.reference),
							obj = inst.get_node(data.reference);
						inst.create_node(obj, {}, "last", function (new_node) {
							try {
								inst.edit(new_node, null, function (the_node, rename_status) {
									if(rename_status){
										var parentId = the_node.parents[0];
										var url = '/filebox/create-sub-node/' + parentId;
										$.get(url,{name:the_node.text},function(response){
											if(response.result == "OK"){
												var newId = response.newId;
												inst.set_id(the_node,newId)
											}
										},"json")
										.fail(function(error){
											console.log(error);
											alert('하위 폴더 생성중 오류가 발생했습니다');
											//refresh
										});
									}
								});
							} catch (ex) {
								setTimeout(function () { inst.edit(new_node); },0);
							}
						});
					  }//end create_node
	                },
	                "Rename": {
	                    "separator_before": false,
	                    "separator_after": false,
	                    "icon" : "text-primary bi bi-pencil",	                    
	                    "label": "폴더명 바꾸기",
	                    "action": function (data) {
	    	                var inst = $.jstree.reference(data.reference),
	    					node = inst.get_node(data.reference);
		    				inst.edit(node, null, function(the_node, rename_status){
		    					if(rename_status){
									var nodeId = the_node.id;
									var url = '/filebox/rename-node/' + nodeId;
									$.get(url,{name:the_node.text},function(response){
										if(response.result == "OK"){
											var newId = response.newId;
											inst.set_text(the_node,the_node.text);
										}
									},"json")
									.fail(function(error){
										console.log(error);
										alert('하위 폴더 생성중 오류가 발생했습니다');
										//refresh
									});
		    					}
		    				});
	                    }//end actionj
	                },
	                "Remove": {
	                    "separator_before": false,
	                    "separator_after": false,
	                    "icon" : "text-danger bi bi-folder-x",	
	                    "label": "폴더 삭제",
						"_disabled"			: function (data) {
							var inst = $.jstree.reference(data.reference),
							node = inst.get_node(data.reference);							
							var selectedId = node.id;
	                    	// 선택된 노드의 자식 노드 가져오기
	                    	var childrenNodes = inst.get_children_dom(selectedId);

	                    	// 자식 노드가 존재하는지 확인
	                    	if (childrenNodes.length > 0) {
	                    		return true;
	                    	}else{
	                    		return false;
	                    	}							
						},	                    
	                    "action": function (data) {
	                    	//debugger;
							var inst = $.jstree.reference(data.reference),
							node = inst.get_node(data.reference);
							var selectedId = node.id;
	                    	// 선택된 노드의 자식 노드 가져오기
	                    	var childrenNodes = inst.get_children_dom(selectedId);

	                    	// 자식 노드가 존재하는지 확인
	                    	if (childrenNodes.length > 0) {
	                    	    console.log('선택된 노드의 자식 노드가 존재합니다.');
	                    	    alert('선택된 노드의 자식 노드가 존재하여 삭제할 수 없습니다');
	                    	    return;
	                    	}
							var nodeId = selectedId;
							var url = '/filebox/delete-node/' + nodeId;
							$.get(url,function(response){
								if(response.result == "OK"){
									if(inst.is_selected(node)) {
										inst.delete_node(inst.get_selected());
									}
									else {
										inst.delete_node(node);
									}
								}else {
									alert(response.msg);
								}
							},"json")
							.fail(function(error){
								console.log(error);
								alert('하위 폴더 생성중 오류가 발생했습니다');
								//refresh
							});	                    	
	                    }
	                },
					"ccp" : { /* cut and paste */
						"separator_before"	: true,
						"icon"				: "text-primary bi-clipboard2-check",
						"separator_after"	: false,
						"label"				: "편집",
						"action"			: false,
						"submenu" : {
							"cut" : {
								"separator_before"	: false,
								"separator_after"	: false,
								"icon"				: "text-warning bi bi-scissors",
								"label"				: "잘라내기",
								"action"			: function (data) {
									var inst = $.jstree.reference(data.reference),
										obj = inst.get_node(data.reference);
									debugger;
									if(inst.is_selected(obj)) {
										inst.cut(inst.get_top_selected());
									}
									else {
										inst.cut(obj);
									}
								}
							},
// 							"copy" : {
// 								"separator_before"	: false,
// 								"icon"				: false,
// 								"separator_after"	: false,
// 								"label"				: "Copy",
// 								"action"			: function (data) {
// 									var inst = $.jstree.reference(data.reference),
// 										obj = inst.get_node(data.reference);
// 									if(inst.is_selected(obj)) {
// 										inst.copy(inst.get_top_selected());
// 									}
// 									else {
// 										inst.copy(obj);
// 									}
// 								}
// 							},
							"paste" : {
								"separator_before"	: false,
								"icon"				: "text-success bi bi-clipboard-plus",
								"_disabled"			: function (data) {
									return !$.jstree.reference(data.reference).can_paste();
								},
								"separator_after"	: false,
								"label"				: "붙여넣기",
								"action"			: function (data) {
									var inst = $.jstree.reference(data.reference),
										obj = inst.get_node(data.reference);
									debugger;
									//var ccpNode = data.ccp_node;
									var buffer = inst.get_buffer();
									var ccp_nodes = buffer.node;
									if(ccp_node == false){
										alert("옮길 대상 폴더가 존재하지 않습니다");
										return;
									} 
									var ccp_node = ccp_nodes[0];
									var nodeId = ccp_node.id;
									var newParentId = obj.id;
									if(newParentId == ccp_node.parent){
										alert("옮길 위치 폴더가 동일합니다.");
										return;
									}
									var url = '/filebox/move-node/' + nodeId;
									$.get(url,{newParentId:newParentId},function(response){
										if(response.result == "OK"){
											inst.paste(obj);
										}else {
											alert(response.msg);
										}
									},"json")
									.fail(function(error){
										console.log(error);
										alert('하위 폴더 생성중 오류가 발생했습니다');
										//refresh
									});	  									
								}
							}
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
                    id: item.nodeId.toString(),
                    text: item.nodeName,
                    parent: (item.level === 0) ? "#" : item.parentId.toString() 
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
	//노드가 선택되었을 때 event
	$jsTree.on('select_node.jstree', function(e, data) {
		//debugger;
	    var nodeId = data.node.id;
	    console.log("fileinfo section nodeId: " + nodeId);
	   	makeFileInfoSection(nodeId);
	}).on('ready.jstree', function (e, data) {    
        $jsTree.jstree('open_all');
	});
}
function makeFileInfoSection(nodeId){
    console.log(nodeId);
    // 현재 선택된 nodeId를 hidden에 넣는다.
    $('#form-file-upload-node-id').val(nodeId);

    //박스 id가 1 즉 root라면
    if(nodeId == 1){
    	
    }
    //debugger;
 	// jsTree에서 선택된 노드의 ID를 가져옴
    //var selectedNodeId = $('#yourJsTreeId').jstree('get_selected')[0];
    var foundNode = $jsTree.jstree('get_node',nodeId);
    // 선택된 노드의 부모 노드들을 가져옴
    var parentNodes = foundNode.parents;

    // 부모 노드들의 정보 출력
    var path=[];
    for (var i = 0; i < parentNodes.length; i++) {
        var parentNode = $jsTree.jstree('get_node',parentNodes[i]);
        if(parentNode.id == "1" || parentNode.id == "#") continue;
        path.push(parentNode);
        console.log('부모 노드 ID: ' + parentNode.id + ', 부모 노드 텍스트: ' + parentNode.text);
    }    
    var path_desc = path.reverse();
    path_desc.push(foundNode); //선택된 노드를 맨 마지막에 넣는다
    displayPath(path_desc);

    //파일목록을 리스트한다
     var url = '/filebox/file-list/'+nodeId;
     $.get(url, function(response){
    	 console.log(response);
    	 makeFileList(response.list);
     }, "json");
}

// breadcrumb를 화면에 표시한다
function displayPath(node_path_array) {
	var seperator = ' / ';
	var pathArray = [];
	for(var i=0; i < node_path_array.length; i++){
		var node = node_path_array[i];
		if(i == node_path_array.length -1){
			pathArray.push( '<span>' + node.text + '</span>' );
		}else{
			pathArray.push( '<a class="btnBreadcrumb" href="#" data-box-id="'+node.id+'">'+node.text+'</a>' );
		}
	}
	var html = pathArray.join(seperator);
	console.log(html);
	$('#path-display').html(html);
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




</script>	
</body>
</html>