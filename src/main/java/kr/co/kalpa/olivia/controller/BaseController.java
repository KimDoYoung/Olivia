package kr.co.kalpa.olivia.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.Map;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;

import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.ui.Model;

import com.google.gson.Gson;

import kr.co.kalpa.olivia.servlet.interceptor.AjaxJspInterceptor;
import kr.co.kalpa.olivia.utils.SysUtil;
import lombok.extern.slf4j.Slf4j;

/**
 * 
 * Controller에서의 유틸리티함수 및 디버깅함수를 갖는 상위Controller
 *  
 * @author KOREA 
 *
 */
@Slf4j
public class BaseController {
	
	protected boolean isAjax(HttpServletRequest request) {
		return (boolean)request.getAttribute(AjaxJspInterceptor.Attr_Is_Ajax);
	}
	
	protected void printModel(Model model) {
		SysUtil.printModel(model);
		Map<String, Object> md = model.asMap();
		log.debug("----------------[ Model ]---------------------");
		for (Object modelKey : md.keySet()) {
			Object modelValue = md.get(modelKey);
			log.debug("{} : [{}]",modelKey, modelValue);
		}
		log.debug("--------------------------------------------");
	}
	protected void printRequest(HttpServletRequest request) {
		SysUtil.printRequest(request);
	}
	
	@SuppressWarnings("hiding")
	protected <T> T getClassFromBody(HttpServletRequest request, Class<T> clazz) {
		   	
        try {
            BufferedReader reader = request.getReader();
            StringBuilder json = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                json.append(line);
            }

            // JSON 데이터를 제네릭 클래스로 매핑
            Gson gson = new Gson();
            return gson.fromJson(json.toString(), clazz);
        } catch (IOException e) {
            e.printStackTrace();
            // 예외 처리가 필요한 경우 null을 반환하거나 예외를 throw할 수 있습니다.
            return null;
        }
	}
}
