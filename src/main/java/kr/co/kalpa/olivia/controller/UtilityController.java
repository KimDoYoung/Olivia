package kr.co.kalpa.olivia.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/utility")
public class UtilityController{

	
	@GetMapping("")
	public String main() {
		log.debug("********************************************");
		log.debug("utilities");
		log.debug("********************************************");
		return "utility/util";
	}

}
