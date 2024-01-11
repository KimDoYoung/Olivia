package kr.co.kalpa.olivia.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.kalpa.olivia.security.UserPrincipal;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class MainController{

	
	@RequestMapping("/")
	public String main() {
		log.debug("********************************************");
		log.debug("index");
		log.debug("********************************************");
		return "redirect:main";
	}
	@RequestMapping("login")
	public String login(Authentication authentication) {
		log.debug("********************************************");
		log.debug("login");
		log.debug("********************************************");
		if(authentication != null) {
			UserPrincipal userDetails = (UserPrincipal) authentication.getPrincipal();
			if(userDetails != null) {
				return "redirect:main";
			}
		}
		
		return "login";
	}
	@RequestMapping("main")
	public String main(Authentication authentication) {
		log.debug("********************************************");
		log.debug("main");
		log.debug("********************************************");
		if(authentication != null) {
			UserPrincipal userDetails = (UserPrincipal) authentication.getPrincipal();
			if(userDetails != null) {
				return "main";
			}
		}
		
		return "login";
	}

}
