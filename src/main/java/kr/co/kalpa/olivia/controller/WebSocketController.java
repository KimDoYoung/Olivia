package kr.co.kalpa.olivia.controller;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/websocket")
public class WebSocketController {

	@GetMapping("")
	public String main() {
		log.debug("******************************************************");
		log.debug("websocket");
		log.debug("******************************************************");
		return "websocket/test";
	}
	
    @MessageMapping("/hello")
    @SendTo("/topic/greetings")
    public String greeting(String message) throws Exception {
        Thread.sleep(1000); // simulated delay
        return "Hello, " + message + "!";
    }
}