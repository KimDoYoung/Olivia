package kr.co.kalpa.olivia.controller;

import java.net.MalformedURLException;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.kalpa.olivia.OliviaApplication;
import kr.co.kalpa.olivia.exception.CrawlingException;
import kr.co.kalpa.olivia.model.IpoData;
import kr.co.kalpa.olivia.model.JsonData;
import kr.co.kalpa.olivia.service.CrawlingService;
import kr.co.kalpa.olivia.utils.crawling.IpoCrawler;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/crawling")
public class CrawlingController extends BaseController{
	
	private static final String START_URL = "https://www.38.co.kr/html/fund/index.htm?o=r";
	private CrawlingService service;

	public CrawlingController(CrawlingService service) {
		this.service = service;
	}
	
	@GetMapping("")
	public String main(Model model) {
		log.debug("********************************************");
		log.debug("crawling");
		log.debug("********************************************");
		List<IpoData>list = service.selectIpoList();
		String trackTime = parseTrackId(list.get(0).getTrackId());
		model.addAttribute("ipoDataList", list);
		model.addAttribute("trackTime", trackTime);
		return "crawling/ipotracker";
	}
	@GetMapping("run")
	public String run(Model model) throws CrawlingException {
		log.debug("********************************************");
		log.debug("RUN crawling");
		log.debug("********************************************");
		try {
			IpoCrawler ipoCrawler = new IpoCrawler(START_URL);
			List<IpoData> list = ipoCrawler.run();
			service.insertIpoDatas(list);
		} catch (Exception e) {
			e.printStackTrace();
			throw new CrawlingException(e.getMessage());
		}
		
		return "redirect:/crawling";
	}
	private String parseTrackId(String trackId) {
		String yyyy= trackId.substring(0,4);
		String mm= trackId.substring(4,6);
		String dd= trackId.substring(6,8);
		String H= trackId.substring(8,10);
		String M= trackId.substring(10,12);
		String S= trackId.substring(12);
		return String.format("%s-%s-%s %s:%s:%s", yyyy,mm,dd,H,M,S);
	}
	
	@GetMapping("ipodata/{seq}")
	@ResponseBody
	public String ipodata(@PathVariable("seq") Long seq) {
		IpoData ipoData = service.selectIpoOne(seq);
		JsonData jsonData = new JsonData();
		jsonData.put("ipoData", ipoData);
		return jsonData.toJson();

	}
}
