package kr.co.kalpa.olivia.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.kalpa.olivia.service.ScheduleService;

@Controller
@RequestMapping("schedule")
public class ScheduleController {

	private ScheduleService service;

	public ScheduleController(ScheduleService service) {
		this.service = service;
	}
	
	@GetMapping(value = "")
	public String index() {
		
		return "schedule/calendar";
	}

}
