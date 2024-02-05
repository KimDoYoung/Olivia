package kr.co.kalpa.olivia.servlet.filter;

import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class IpCheckFilter implements Filter {

	private final Set<String> allowIpSet = new HashSet<String>();
	
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    	allowIpSet.add("0:0:0:0:0:0:0:1"); 
    	allowIpSet.add("127.0.0.1"); 
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        if( !isValidIp(httpRequest)) {
            httpResponse.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403 에러 반환
            return; // 요청 처리 중단        	
        }

        chain.doFilter(request, response); // 요청을 다음 필터 또는 대상 리소스로 전달
    }

	private boolean isValidIp(HttpServletRequest request) {
		
		String clientIp = null;
		String xForwardedForHeader = request.getHeader("X-Forwarded-For");

		if (xForwardedForHeader != null && !xForwardedForHeader.isEmpty()) {
			String[] forwardedForArray = xForwardedForHeader.split(",");
			clientIp = forwardedForArray[0].trim();
		} else {
			clientIp = request.getRemoteAddr();
		}
		if(! allowIpSet.contains(clientIp) ) {
			log.error("-----------------------------------------------");
			log.error("{} is not allowed");
			log.error("-----------------------------------------------");
			return false;
		}
		return true;
	}

	@Override
    public void destroy() {
        // 필터 해제 로직
    }

}