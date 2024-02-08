package kr.co.kalpa.olivia.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
	public IpoData selectIpoOne(Long seq) {
		return repository.selectIpoOne(seq);
	}
	@Transactional
	public void insertIpoDatas(List<IpoData> list) {
		for (IpoData ipoData : list) {
			repository.insertIpoData(ipoData);
		}
	}

}
