package kr.co.kalpa.olivia.service;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.co.kalpa.olivia.model.IpoData;
import kr.co.kalpa.olivia.repository.CrawlingRepository;

@Service
public class CrawlingService {

	private CrawlingRepository repository;
	
	public CrawlingService(CrawlingRepository repository) {
		this.repository = repository;
	}
	public List<IpoData> selectIpoList() {
		return repository.selectIpoList();
	}

}
