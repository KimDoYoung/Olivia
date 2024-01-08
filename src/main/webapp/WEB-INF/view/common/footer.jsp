<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<footer class="footer my-5">
	<div class="footer-menu">
		&nbsp;
	</div> 
</footer>
<!-- loading layer -->
<div class="container-fluid mt-5" id="julia-loading-div">
    <div class="row">
        <div class="col d-flex align-items-center justify-content-center vh-100">
        <div class="spinner-border text-secondary" role="status">
        </div>
        <span class="m-2"> Please Wait... </span>
        </div>
    </div>
</div>
<!-- 스크롤이 top으로 보내는 버튼 -->
<div id="scroll-box" >
<a id="scroll-to-left" href="#" class="btn btn-light btn-lg border border-secondary opacity-50 me-1 back-to-top" role="button"><i class="bi bi-chevron-left"></i></a>
<a id="scroll-to-top" href="#" class="btn btn-light btn-lg border border-secondary opacity-50 back-to-top" role="button"><i class="bi bi-chevron-up"></i></a>
</div>
<script>
$(document).ready(function(){
	$(window).scroll(function () {
		//console.log("left: " +$(this).scrollLeft() + ", top : " + $(this).scrollTop() );
		if ($(this).scrollTop() > 50) {
			$('#scroll-to-top').fadeIn();
			//$('#scroll-box').fadeIn();
		} else {
			$('#scroll-to-top').fadeOut();
			//$('#scroll-box').fadeOut();
		}
		if ($(this).scrollLeft() > 10) {
			$('#scroll-to-left').fadeIn();
		} else {
			$('#scroll-to-left').fadeOut();
		}
	});
	// scroll body to 0px on click
	$('#scroll-to-top').click(function () {
		$('body,html').animate({
			scrollTop: 0
		}, 400);
		return false;
	});
	 $('#scroll-to-left').click(function(event) {
	    event.preventDefault();
	    $('body,html').animate({
	      //scrollLeft: "-=500px"
	      scrollLeft: "0px"
	    }, 400);
	    return false;    
	 });
/*      $('.horizon-next').click(function(event) {
	    event.preventDefault();
	    $('#content').animate({
		     scrollLeft: "+=775px"
	    	}, "slow");
	  }); */	
});
</script>
<!--  popperjs, bootstrap  -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js" integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+" crossorigin="anonymous"></script>

<!-- jqvalidator, handlebar -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jqwidgets/17.0.1/jqwidgets/jqx-all.js" integrity="sha512-KlJukoevfKgPqd9bJRAuzvuaU177/lFPb9GoXLr4neUSlvZMBtlGlfk9C2AFPD3bvaot0Cw7iHOrsCOdXUycPA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.7.8/handlebars.min.js" integrity="sha512-E1dSFxg+wsfJ4HKjutk/WaCzK7S2wv1POn1RRPGh8ZK+ag9l244Vqxji3r6wgz9YBf6+vhQEYJZpSjqWFPg9gg==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

<!-- datepicker -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.10.0/js/bootstrap-datepicker.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.10.0/locales/bootstrap-datepicker.ko.min.js"></script>

<!-- bootboxjs -->
<script src='<c:url value="/js/lib/bootbox.all.min.js"/>'></script>

<!-- xlsx table export -->
<script src="https://cdn.sheetjs.com/xlsx-0.20.0/package/dist/xlsx.full.min.js"></script>
<!-- asset유틸리티 -->
<script type="text/javascript" src='<c:url value="/js/common.js"/>'></script>
<script type="text/javascript" src='<c:url value="/js/input-format.js"/>'></script>