package kr.co.kalpa.olivia.utils;

import java.util.Enumeration;
import javax.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class SysUtil {
	
	public static void printRequest(HttpServletRequest request) {
        log.debug("Request Information: --------->");

        // Request URL 및 메서드 출력
        log.debug("URL: {}", request.getRequestURL());
        log.debug("Method: {}", request.getMethod());

        // Request 헤더 출력
        log.debug("Headers:");
        Enumeration<String> headerNames = request.getHeaderNames();
        while (headerNames.hasMoreElements()) {
            String headerName = headerNames.nextElement();
            log.debug("{}: {}", headerName, request.getHeader(headerName));
        }

        // Request 파라미터 출력
        log.debug("Parameters:");
        request.getParameterMap().forEach((key, values) ->
                log.debug("{}: {}", key, String.join(", ", values)));

        // Request 속성 출력
        log.debug("Attributes:");
        Enumeration<String> attributeNames = request.getAttributeNames();
        while (attributeNames.hasMoreElements()) {
            String attributeName = attributeNames.nextElement();
            log.debug("{}: {}", attributeName, request.getAttribute(attributeName));
        }

        log.debug("<-----------End of Request Information.");
    }
}
