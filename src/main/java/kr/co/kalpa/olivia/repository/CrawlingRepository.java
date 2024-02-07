package kr.co.kalpa.olivia.repository;

import java.util.List;

import kr.co.kalpa.olivia.model.IpoData;

public interface CrawlingRepository {

	List<IpoData> selectIpoList();
	IpoData selectIpoOne(Long seq);
	Long insertIpoData(IpoData ipoData);
}
