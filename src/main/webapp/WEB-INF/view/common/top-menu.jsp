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
         <a class="navbar-brand text-warning fw-bold" href='<c:url value="/main"/>'>FBH-EDI Management</a>
         <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
             data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false"
             aria-label="Toggle navigation">
             <span class="navbar-toggler-icon"></span>
         </button>
         <div class="collapse navbar-collapse" id="navbarSupportedContent">
             <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                 <li class="nav-item dropdown">
                     <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown"
                         aria-expanded="false" style="color:#DECEFE">
                         EDI-Documents
                     </a>
                     <ul class="dropdown-menu">
                         <li><a class="dropdown-item" href='<c:url value="/edi/list/210"/>'>Hub Invoice (210)</a></li>
                         <li><a class="dropdown-item" href='<c:url value="/edi/list/810"/>'>Invoice (810)</a></li>
                         <li><a class="dropdown-item" href='<c:url value="/edi/list/850"/>'>Purchase Order (850)</a></li>
                         <li><a class="dropdown-item" href='<c:url value="/edi/list/945"/>'>Warehouse Shipping Advice (945)</a></li>
                         <li><a class="dropdown-item" href='<c:url value="/edi/list/820"/>'>Payment (820)</a></li>
                     </ul>
                 </li>
              	<li class="nav-item dropdown">
                     <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown"
                         aria-expanded="false" style="color:#DECEFE">
                         EDI-Business
                     </a>
                     <ul class="dropdown-menu">
                         <li><a class="dropdown-item" href='<c:url value="/edi/biz/diff850945"/>'>Diff 850-945</a></li>
                         <li><a class="dropdown-item" href='<c:url value="/edi/biz/po-trace"/>'>PO Trace</a></li>
                         <li><a class="dropdown-item" href='<c:url value="/edi/biz/dc-list"/>'>List by DC</a></li>
                         <li><a class="dropdown-item" href='<c:url value="/edi/biz/inventory-summary"/>'>Inventory Summary</a></li>
                         <li><a class="dropdown-item" href='<c:url value="/edi/biz/inventory-by-lot"/>'>Inventory by Lot</a></li>
                     </ul>
                 </li>
              	<li class="nav-item dropdown">
                     <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown"
                         aria-expanded="false" style="color:#DECEFE">
                         Statistics
                     </a>
                     <ul class="dropdown-menu">
                         <li><a class="dropdown-item" href='<c:url value="/edi/statistic/sales"/>'>Sales</a></li>
                         <li><a class="dropdown-item" href='<c:url value="/edi/statistic/trend"/>'>Trend</a></li>
                     </ul>
                 </li>
                 <li class="nav-item dropdown">
                     <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown"
                         aria-expanded="false" style="color:#DECEFE">
                         Codes
                     </a>
                     <ul class="dropdown-menu">
                         <li><a class="dropdown-item" href='<c:url value="/codes/company"/>'>Company</a></li>
                         <li><a class="dropdown-item" href='<c:url value="/codes/edi-code"/>'>Edi Code</a></li>
                         <li><a class="dropdown-item" href='<c:url value="/codes/stocks"/>'>Stocks</a></li>
                         <li><a class="dropdown-item" href='<c:url value="/codes/week-of-year"/>'>week of year(Kroger)</a></li>
                     </ul>
                 </li>
				<sec:authorize access="hasAnyRole('ROLE_ADMIN')"> 
				<!-- 관리자만 test와 admin -->    
                 <li class="nav-item dropdown">
                     <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown"
                         aria-expanded="false" style="color:#DECEFE">
                         System
                     </a>
                     <ul class="dropdown-menu">
                         <li><a class="dropdown-item" href='<c:url value="/admin/user/list"/>' >User</a></li>
                     </ul>
                 </li>
                 </sec:authorize>                 
             </ul>
         <div  class="d-flex">
			<sec:authorize access="isAuthenticated()">
			   <sec:authentication var="user" property="principal" />
		       <span class="text-warning fw-bold">
		       	<a href="<c:url value='/admin/user/update/${user.userId }'/>"><sec:authentication property="principal.username"/></a> 님 반갑습니다.
		       </span>
		    </sec:authorize>
		    <a href='<c:url value="/logout"/>' title="logout"><i class="bi bi-box-arrow-right mx-2"></i></a>
         </div>
       </div>
     </div>
 </nav>
</header>