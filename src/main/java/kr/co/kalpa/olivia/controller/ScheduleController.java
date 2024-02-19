package kr.co.kalpa.olivia.controller;

import java.time.LocalDate;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.kalpa.olivia.model.JsonData;
import kr.co.kalpa.olivia.model.schedule.Schedule;
import kr.co.kalpa.olivia.model.schedule.SpecialDay;
import kr.co.kalpa.olivia.service.ScheduleService;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("schedule")
@Slf4j
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
	
	@ResponseBody
	@GetMapping("openApi/holiday")
	public String openApiHoliday() {

		log.debug("*****************************************");
		log.debug("openapi 휴일정보가져오기");
		log.debug("*****************************************");
		JsonData jsonData = new JsonData();
		try {
			String year = String.valueOf( LocalDate.now().getYear());
			service.specialDayFetchAll(year);
			jsonData.put("result", "OK");
		} catch (Exception e) {
			jsonData.put("result", "NK");
			e.printStackTrace();
			log.error(e.getMessage());
		}
		return jsonData.toJson();
	}

	@ResponseBody
	@GetMapping("openApi/division24")
	public String division24() {
		
		log.debug("*****************************************");
		log.debug("openapi 24절기정보가져오기");
		log.debug("*****************************************");
		JsonData jsonData = new JsonData();
		try {
			String year = String.valueOf( LocalDate.now().getYear());
			service.division24FetchAll(year);
			jsonData.put("result", "OK");
		} catch (Exception e) {
			jsonData.put("result", "NK");
			e.printStackTrace();
			log.error(e.getMessage());
		}
		return jsonData.toJson();
	}
	
	@ResponseBody
	@GetMapping("openApi/fill-lunar-calendar")
	public String lunar() {
		
		log.debug("*****************************************");
		log.debug("lunar_calendar 를 채운다.");
		log.debug("*****************************************");
		JsonData jsonData = new JsonData();
		try {
			String year = String.valueOf( LocalDate.now().getYear());
			service.lunarCalendarFill(Integer.parseInt(year));
			jsonData.put("result", "OK");
		} catch (Exception e) {
			jsonData.put("result", "NK");
			e.printStackTrace();
			log.error(e.getMessage());
		}
		return jsonData.toJson();
	}
}
