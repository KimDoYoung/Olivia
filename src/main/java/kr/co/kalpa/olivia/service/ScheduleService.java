package kr.co.kalpa.olivia.service;

import org.springframework.stereotype.Service;

import kr.co.kalpa.olivia.repository.ScheduleRepository;

@Service
public class ScheduleService {

	
	private ScheduleRepository respository;

	public ScheduleService(ScheduleRepository repository) {
		this.respository = repository;
	}
}
