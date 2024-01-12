package kr.co.kalpa.olivia.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.co.kalpa.olivia.model.filebox.Filebox;
import kr.co.kalpa.olivia.service.FileboxService;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/filebox")
public class FileboxController{

	private String baseUrl ="/filebox";
	private FileboxService fielboxService;
	
    public FileboxController(FileboxService fielboxService) {
        this.fielboxService = fielboxService;
    }

	
	@RequestMapping("")
	public String filebox(
			@RequestParam(value="parentId", required=false, defaultValue="1") Integer parentId,
			Model model) {
		log.debug("********************************************");
		log.debug("filebox");
		log.debug("********************************************");
		List<Filebox> list = fielboxService.subFolderList(parentId);
		model.addAttribute("list", list);
		
		return baseUrl + "/filebox";
	}

	@PostMapping("add-folder")
	public String addFolder(@ModelAttribute("filebox") Filebox filebox) {
		log.debug("********************************************");
		log.debug("filebox: {}",filebox);
		log.debug("********************************************");
		//TODO ApiData 사용법을 기술하시오.
		int i = fielboxService.addFolder(filebox);
		return baseUrl + "/filebox";
	}
}
