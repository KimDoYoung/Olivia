<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
   
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
    
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- =================================================== -->
<jsp:include page="../common/meta_css.jsp" flush="false" />
<!-- =================================================== -->
<title><c:out value="${pageTitle }" default="filebox" /></title>
 <style>
.table {
  table-layout: fixed; /* or you can try 'auto' if it's set to 'fixed' */
  width: 100%; /* ensure the table spans the full width of its container */
}

th, td {
  word-break: keep-all; /* to prevent breaking words in cells */
  white-space: nowrap; /* to ensure content stays on one line */
  overflow: hidden; /* hides any content that overflows */
  text-overflow: ellipsis; /* adds an ellipsis to any text that overflows */
}
 </style>
</head>
<body>
<!-- =================================================== -->
<jsp:include page="../common/top-menu.jsp" flush="false" />
<!-- =================================================== -->
<div class="container">
	<h1 class="text-center">IPO Schedule tracking</h1>
	<div class="d-flex justify-content-between">
	  <div class="text-primary fw-bolder">Tracking on <c:out value="${trackTime }"/></div>
	  <div><a href="#none" class="btn btn-warning" id="btnRunCrawling">Crawling <i class="bi bi-arrow-clockwise"></i></a></div>
	</div>
	<table class="table table-sm table-hover mt-2" style="font-size:small">
    <thead class="table-success">
        <tr>
        	<th scope="col" class="text-center">#</th>
            <th scope="col" class="text-center">종목명</th>
            <th scope="col" class="text-center">진행상황</th>
            <th scope="col" class="text-center">시장구분</th>
            <th scope="col" class="text-center">종목코드</th>
            <th scope="col" class="text-center">업종</th>
            <th scope="col" class="text-center">대표자</th>
            <th scope="col" class="text-center">기업구분</th>
            <th scope="col" class="text-center">본점소재지</th>
            <th scope="col" class="text-center"  style="width:25px"></th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="item" items="${ipoDataList}" varStatus="status">
            <tr>
            	<td class="text-center">${status.count}</td>
                <td><a href="#none" data-homepage="${item.website}" class="company-home-page">${item.stockName}</a></td>
                <td class="text-center">${item.status}</td>
                <td class="text-center">${item.marketType}</td>
                <td class="text-center">${item.stockCode}</td>
                <td class="text-start" title="${item.industry}">${item.industry}</td>
                <td class="text-center">${item.ceo}</td>
                <td class="text-center">${item.businessType}</td>
                <td class="text-start" title="${item.headquartersLocation}">${item.headquartersLocation}</td>
                <td class="text-start text-danger"><i class="bi bi-plus btnMoreInfo" data-seq="${item.seq }"></i></td>
            </tr>
        </c:forEach>
    </tbody>
</table>
</div>
<script id="ipodata-template" type="text/x-handlebars-template">
<table class="table table-sm table-hover mt-3 userTable font-size-small">
    <tbody>
        <tr>
            <th>종목명</th>
            <td>{{stockName}}</td>
            <th>진행상황</th>
            <td>{{status}}</td>
            <th>시장구분</th>
            <td>{{marketType}}</td>
        </tr>
        <tr>
            <th>종목코드</th>
            <td>{{stockCode}}</td>
            <th>업종</th>
            <td>{{industry}}</td>
            <th>대표자</th>
            <td>{{ceo}}</td>
        </tr>
        <tr>
            <th>기업구분</th>
            <td>{{businessType}}</td>
            <th>본점소재지</th>
            <td>{{headquartersLocation}}</td>
            <th>홈페이지</th>
            <td>{{website}}</td>
        </tr>
        <tr>
            <th>대표전화</th>
            <td>{{phoneNumber}}</td>
            <th>최대주주</th>
            <td>{{majorShareholder}}</td>
            <th>매출액</th>
            <td>{{revenue}}</td>
        </tr>
        <tr>
            <th>법인세비용차감전 계속사업이익</th>
            <td>{{preTaxContinuingOperationsProfit}}</td>
            <th>순이익</th>
            <td>{{netProfit}}</td>
            <th>자본금</th>
            <td>{{capital}}</td>
        </tr>
        <tr>
            <th>총공모주식수</th>
            <td>{{totalIpoShares}}</td>
            <th>액면가</th>
            <td>{{faceValue}}</td>
            <th>상장공모</th>
            <td>{{listingIpo}}</td>
        </tr>
        <tr>
            <th>희망공모가액</th>
            <td>{{desiredIpoPrice}}</td>
            <th>청약경쟁률</th>
            <td>{{subscriptionCompetitionRate}}</td>
            <th>확정공모가</th>
            <td>{{finalIpoPrice}}</td>
        </tr>
        <tr>
            <th>공모금액</th>
            <td>{{ipoProceeds}}</td>
            <th>주간사</th>
            <td>{{leadManager}}</td>
            <th>수요예측일</th>
            <td>{{demandForecastDate}}</td>
        </tr>
        <tr>
            <th>공모청약일</th>
            <td>{{ipoSubscriptionDate}}</td>
            <th>배정공고일(신문)</th>
            <td>{{newspaperAllocationAnnouncementDate}}</td>
            <th>납입일</th>
            <td>{{paymentDate}}</td>
        </tr>
        <tr>
            <th>환불일</th>
            <td>{{refundDate}}</td>
            <th>상장일</th>
            <td>{{listingDate}}</td>
            <th>IR일자</th>
            <td>{{irData}}</td>
        </tr>
        <tr>
            <th>IR장소/시간</th>
            <td>{{irLocationTime}}</td>
            <th>기관경쟁률</th>
            <td>{{institutionalCompetitionRate}}</td>
            <th>의무보유확약</th>
            <td>{{lockUpAgreement}}</td>
        </tr>
    </tbody>
</table>
</script>
<!-- =================================================== -->
<jsp:include page="../common/footer.jsp" flush="false" />
<!-- -================================================== -->
<script>
$( document ).ready(function() {
	console.log('ipo schedule');
	function ensureProtocol(url) {
	    if (!url.startsWith('http://') && !url.startsWith('https://')) {
	        return 'https://' + url; // 기본적으로 https를 사용합니다.
	    }
	    return url;
	}
	$('.btnMoreInfo').hover(function() {
        $(this).removeClass("bi-plus").addClass("bi-plus-circle");
      }, function() {
        $(this).removeClass("bi-plus-circle").addClass("bi-plus");
      });
	
	$('.btnMoreInfo').click(function() {
		var $this = $(this);
		if($this.hasClass("active")) {
			$this.removeClass("active");
			$this.closest("tr").next().remove();
			return;
		}
		
		$this.addClass("active");
		//-----------------------------------
		var seq = $this.data('seq');
		JuliaUtil.ajax("/ipodata/"+seq,null,{
			method  : 'GET',
			success : (response)=>{
				console.log(response.ipoData);
				var templateHtml = $('#ipodata-template').html();
				var template = Handlebars.compile(templateHtml);
				var html = template(response.ipoData);
				html = "<tr><td colspan='10'>" + html + "</td></tr>";
				$this.closest("tr").after(html);
			}
		})
	});
	
	$('.company-home-page').on('click', function(){
		var homepage = $(this).data('homepage');
		homepage = ensureProtocol(homepage);
		window.open(homepage);
	});
	$('#btnRunCrawling').on('click', function(){
		JuliaUtil.displayLoading(true);
		JuliaUtil.submitGet("/crawling/run");
	});
});
</script>	
</body>
</html>