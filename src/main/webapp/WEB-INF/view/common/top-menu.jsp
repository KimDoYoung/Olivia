<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<style>
header.sticky {
    z-index: 100;
}
</style>
<header class="sticky">
<nav class="navbar navbar-expand-lg bg-dark">
     <div class="container-fluid">
         <a class="navbar-brand text-warning fw-bold" href='<c:url value="/main"/>'>Board and File-box</a>
         <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
             data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false"
             aria-label="Toggle navigation">
             <span class="navbar-toggler-icon"></span>
         </button>
	   	<div class="collapse navbar-collapse" id="navbarSupportedContent">
	      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
	        <li class="nav-item">
	          <a class="nav-link text-white" aria-current="page" href="/board" >Board</a>
	        </li>
	        <li class="nav-item">
	          <a class="nav-link text-white" aria-current="page" href="/filebox">File-Box</a>
	        </li>
	        <li class="nav-item">
	          <a class="nav-link text-white" aria-current="page" href="/schedule">Schedule</a>
	        </li>
	        <li class="nav-item">
	          <a class="nav-link text-white" aria-current="page" href="/crawling">Crawling</a>
	        </li>
	        <li class="nav-item">
	          <a class="nav-link text-white" aria-current="page" href="/utility">Utility</a>
	        </li>
<!-- 	        <li class="nav-item"> -->
<!-- 	          <a class="nav-link text-white" aria-current="page" href="/websocket">Websocket</a> -->
<!-- 	        </li> -->
 			<li class="nav-item dropdown">
				<a class="nav-link dropdown-toggle text-white" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
					Websocket
				</a>
				<ul class="dropdown-menu">
				  <li><a class="dropdown-item" href="/websocket/websocket">공지사항전송(websocket)</a></li>
				  <li><a class="dropdown-item" href="/websocket/sockjs">공지사항전송(SockJS-STOMP)</a></li>
<!-- 				  <li><hr class="dropdown-divider"></li> -->
<!-- 				  <li><a class="dropdown-item" href="#">Something else here</a></li> -->
				</ul>
			</li>
			<li class="nav-item">
	          <a class="nav-link text-white" aria-current="page" href="/alram?msg=TEST">alram</a>
	        </li>
				        
	       </ul>
	     </div>
         <div  class="d-flex">
			<sec:authorize access="isAuthenticated()">
		       <span class="text-warning fw-bold"><sec:authentication property="principal.userId"/>님 반갑습니다.</span>&nbsp;&nbsp;
		    </sec:authorize>
		    <a href="/logout" title="log out"><i class="bi bi-box-arrow-right"></i></a>
	  </div> 
	  </div>
 </nav>
</header>