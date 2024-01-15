package kr.co.kalpa.olivia.servlet.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.kalpa.olivia.utils.SysUtil;
import lombok.extern.slf4j.Slf4j;

/**
 * ajax로 호출받았을 때는 json으로
 * 그냥 호출받았을때는 jsp로 반응한다. 
 */
@Slf4j
public class AjaxJspInterceptor implements HandlerInterceptor  {
	
	public final static String Attr_Is_Ajax = "IS_AJAX__"; 
	@Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
		log.debug("---------------------------------------------");
		log.debug("AjaxJsp Interceptor preHandler");
		log.debug("---------------------------------------------");
		request.setAttribute(Attr_Is_Ajax, false);
        if (handler instanceof HandlerMethod) {
            HandlerMethod handlerMethod = (HandlerMethod) handler;
            
            SysUtil.printRequest(request);
            
            // Ajax 호출 여부 확인
            if (isAjaxRequest(request)) {
                // Ajax 호출일 경우, JSON 응답으로 변경
                //response.setContentType("application/json;charset=UTF-8");
            	request.setAttribute(Attr_Is_Ajax, true);
            } else {
                // 그 외의 경우, JSP 응답으로 변경
                //response.setContentType("text/html;charset=UTF-8");
            }
        }

        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
            ModelAndView modelAndView) throws Exception {
		log.debug("---------------------------------------------");
		log.debug("AjaxJsp Interceptor postHandler");
		log.debug("---------------------------------------------");
    	
//        if (modelAndView != null && !response.isCommitted()) {
//            // 모델이 존재하면서 응답이 커밋되지 않은 경우
//        	boolean isAjax = (boolean) request.getAttribute(Attr_Is_Ajax);
//            if (isAjax) {
//                // Ajax 호출일 경우, 모델 데이터를 JSON으로 변환하여 응답
//            	response.setContentType("application/json;charset=UTF-8");
//                response.getWriter().write(convertModelToJson(modelAndView.getModel()));
//                response.getWriter().flush();
//                response.getWriter().close();
//            } else {
//                // 그 외의 경우, Controller에서 반환한 뷰의 이름을 설정
//                String viewName = modelAndView.getViewName();
//                if (viewName != null) {
//                    modelAndView.setViewName(viewName);
//                }
//            }
//        }
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
            throws Exception {
        // 뷰 렌더링 완료 후에 실행되는 부분
    }
    
    /**
     * 모델의 내용을 json 문자열로 만들어서 리턴
     * @param model
     * @return
     */
    private String convertModelToJson(Object model) {
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            return objectMapper.writeValueAsString(model);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * ajax호출인지 판별
     * @param request
     * @return
     */
    private boolean isAjaxRequest(HttpServletRequest request) {
        return "XMLHttpRequest".equals(request.getHeader("X-Requested-With"))
                || "XMLHttpRequest".equals(request.getHeader("x-requested-with"));
    }
    
}
