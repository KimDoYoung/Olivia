package kr.co.kalpa.olivia.service;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.co.kalpa.olivia.model.schedule.Schedule;
import kr.co.kalpa.olivia.model.schedule.SpecialDay;
import kr.co.kalpa.olivia.repository.ScheduleRepository;

@Service
public class ScheduleService {

	
	private ScheduleRepository repository;

	public ScheduleService(ScheduleRepository repository) {
		this.repository = repository;
	}

	public int insertSchedule(Schedule schedule) {
		return repository.insertSchedule(schedule);
		
	}

	public List<Schedule> selectSchedule() {
		return repository.selectSchedule();
	}

	public int insertSpecialDay(SpecialDay specialDay) {
		return repository.insertSpecialDay(specialDay);
	}

	public List<SpecialDay> selectAllSpecialDays() {
		return repository.selectAllSpecialDays();
	}
}
