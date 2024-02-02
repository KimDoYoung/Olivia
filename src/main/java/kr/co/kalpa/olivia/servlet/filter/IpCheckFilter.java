package kr.co.kalpa.olivia.servlet.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class IpCheckFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 필터 초기화 로직
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String clientIp = request.getRemoteAddr();
        String allowedIp = "특정 허용 IP"; // 여기에 허용할 IP 주소를 설정

        if (!clientIp.equals(allowedIp)) {
            httpResponse.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403 에러 반환
            return; // 요청 처리 중단
        }

        chain.doFilter(request, response); // 요청을 다음 필터 또는 대상 리소스로 전달
    }

    @Override
    public void destroy() {
        // 필터 해제 로직
    }

}