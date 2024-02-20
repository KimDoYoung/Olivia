package kr.co.kalpa.olivia.config;

import org.java_websocket.server.WebSocketServer;
import org.springframework.boot.web.servlet.ServletRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

import com.google.gson.Gson;

import kr.co.kalpa.olivia.servlet.AlarmServlet;
import kr.co.kalpa.olivia.servlet.AlramServer;

@Configuration
public class OliviaConfig {

	@Bean
	public RestTemplate restTemplate() {
		return new RestTemplate();
	}
	
    @Bean
    public Gson gson() {
        return new Gson();
    }
    
    @Bean
    public ServletRegistrationBean<AlarmServlet> myServletRegistration() {
        ServletRegistrationBean<AlarmServlet> registrationBean = new ServletRegistrationBean<>(new AlarmServlet(), "/alram");
        return registrationBean;
    }
    
    @Bean
    public WebSocketServer alarmServer() throws Exception {
        WebSocketServer server = new AlramServer(8887); // 오타 수정: AlarmServer
        server.start();
        System.out.println("WebSocket server started on port 8887.");
        return server;
    }
}
