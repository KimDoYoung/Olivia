package kr.co.kalpa.olivia.controller;

import org.java_websocket.server.WebSocketServer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.kalpa.olivia.security.UserPrincipal;
import kr.co.kalpa.olivia.servlet.AlramServer;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/websocket")
public class WebSocketController {

	 //  private final WebSocketServer alramServer;

	
	@GetMapping("/purejava/alram")
	public String purejavaAlaram(Authentication auth, Model model,WebSocketServer alramServer) {
		log.debug("******************************************************");
		log.debug("순수자바 alram");
		log.debug("******************************************************");
		alramServer.broadcast("홍길동.... 산다는 것은 무엇?");
		return null;
	}

	
	
	@GetMapping("/websocket")
	public String useWebsocket(Authentication auth, Model model) {
		log.debug("******************************************************");
		log.debug("websocket");
		log.debug("******************************************************");
		UserPrincipal principal = (UserPrincipal) auth.getPrincipal();
		String userName = principal.getUsername();
		model.addAttribute("userName", userName);
		return "websocket/websocket";
	}
	
	@GetMapping("/sockjs")
	public String main() {
		log.debug("******************************************************");
		log.debug("websocket");
		log.debug("******************************************************");
		return "websocket/sockjs";
	}
	
    @MessageMapping("/hello")
    @SendTo("/topic/greetings")
    public String greeting(String message) throws Exception {
        Thread.sleep(1000); // simulated delay
        return "Hello, " + message + "!";
    }
    
    @MessageMapping("/message")
    @SendTo("/topic/messages")
    public String sendMessage(String message) throws Exception {
        Thread.sleep(1000);
        return  message;
    }    
}