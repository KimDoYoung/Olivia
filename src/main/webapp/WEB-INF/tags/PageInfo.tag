
<%@ tag language="java" pageEncoding="UTF-8"%>

<%@ attribute name="id" required="true" %>
<%@ attribute name="pageAttr" type="kr.co.kalpa.olivia.utils.PageAttr"  required="true" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="text-end">
    (페이지:
    <c:out value="${pageAttr.currentPageNumber}" />/<c:out value="${pageAttr.totalPageCount }" />
    - 전체 갯수:
    <c:out value="${pageAttr.totalItemCount }" />)
</div>
