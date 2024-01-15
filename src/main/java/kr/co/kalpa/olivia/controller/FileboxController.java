package kr.co.kalpa.olivia.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.JsonElement;

import kr.co.kalpa.olivia.model.filebox.Filebox;
import kr.co.kalpa.olivia.service.FileboxService;
import kr.co.kalpa.olivia.servlet.view.JsonView;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/filebox")
public class FileboxController<T> extends BaseController{

	private String baseUrl ="/filebox";
	private FileboxService fielboxService;
	
    public FileboxController(FileboxService fielboxService) {
        this.fielboxService = fielboxService;
    }

	
	@GetMapping("")
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
	/**
	 * client에서 form으로 보낼 수도 있고
	 * ajx로 보낼 수도 있고 
	 * 2가지모두 1개의 controller에서 처리
	 * @param filebox
	 * @param model
	 * @return
	 */
	@PostMapping("/add-folder")
	public ModelAndView addFolder(HttpServletRequest request, @ModelAttribute("filebox") Filebox filebox,Model model)  {
		ModelAndView mav = new ModelAndView();
		boolean isAjax = isAjax(request); //
		if(isAjax) {
			filebox = getClassFromBody(request, Filebox.class);
			mav.setView(new JsonView());
		}else {
			mav.setViewName("redirect:" + baseUrl);
		}
		int i = fielboxService.addFolder(filebox);
		if(i>0) {			
			mav.addObject("firebox", filebox);
			mav.addObject("result", "OK");
		}else {
			mav.addObject("result", "NK");
		}
		return mav;
	}
	
	@PostMapping("/tree-data/{parentId}")
	public ModelAndView treeData(@PathVariable Integer parentId, Model model)  {
		//fielboxService.treeData(parentId);
		return null;
	}

}
