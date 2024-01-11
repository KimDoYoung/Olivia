package kr.co.kalpa.olivia.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.kalpa.olivia.model.filebox.Filebox;
import kr.co.kalpa.olivia.service.FileboxService;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/filebox")
public class FileboxController{

	private String baseUrl ="/filebox";
	private FileboxService fielboxService;
	@RequestMapping("")
	public String filebox() {
		log.debug("********************************************");
		log.debug("filebox");
		log.debug("********************************************");
		return baseUrl + "/filebox";
	}

	@RequestMapping("add-folder")
	@ResponseBody
	public String addFolder(@ModelAttribute("filebox") Filebox filebox) {
		log.debug("********************************************");
		log.debug("filebox");
		log.debug("********************************************");
		//TODO ApiData 사용법을 기술하시오.
		int i = fielboxService.addFolder(filebox);
		return baseUrl + "/filebox";
	}
}
