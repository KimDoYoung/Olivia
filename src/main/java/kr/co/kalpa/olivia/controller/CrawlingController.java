package kr.co.kalpa.olivia.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.kalpa.olivia.model.IpoData;
import kr.co.kalpa.olivia.service.CrawlingService;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/crawling")
public class CrawlingController extends BaseController{
	
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
	public String run(Model model) {
		log.debug("********************************************");
		log.debug("RUN crawling");
		log.debug("********************************************");
		
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

}
