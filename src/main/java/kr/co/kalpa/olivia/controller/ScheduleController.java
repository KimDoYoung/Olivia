package kr.co.kalpa.olivia.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.kalpa.olivia.model.JsonData;
import kr.co.kalpa.olivia.model.filebox.FbNode;
import kr.co.kalpa.olivia.model.schedule.Schedule;
import kr.co.kalpa.olivia.model.schedule.SpecialDay;
import kr.co.kalpa.olivia.service.ScheduleService;

@Controller
@RequestMapping("schedule")
public class ScheduleController extends BaseController {

	private ScheduleService service;

	public ScheduleController(ScheduleService service) {
		this.service = service;
	}
	
	@GetMapping(value = "")
	public String index() {
		
		return "schedule/calendar";
	}
	
	@ResponseBody
	@PostMapping("insert")
	public String insertSchedule(@RequestBody Schedule schedule) {
		String userId = loginUserId();
		schedule.setCreatedBy(userId);
		int i = service.insertSchedule(schedule);
		String result = i > 0 ? "OK": "NK";
		List<Schedule> list = service.selectSchedule();
		JsonData jsonData = new JsonData();
		jsonData.put("list", list);
		jsonData.put("result", result);
		
		return jsonData.toJson();
	}
	@ResponseBody
	@PostMapping("sepcialday/insert")
	public String insertSpecialDay(@RequestBody SpecialDay specialDay) {
		String userId = loginUserId();
		specialDay.setCreatedBy(userId);
		int i = service.insertSpecialDay(specialDay);
		String result = i > 0 ? "OK": "NK";
		List<SpecialDay> list = service.selectAllSpecialDays();
		JsonData jsonData = new JsonData();
		jsonData.put("list", list);
		jsonData.put("result", result);
		
		return jsonData.toJson();
	}
}
