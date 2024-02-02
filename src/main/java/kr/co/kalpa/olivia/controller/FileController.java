package kr.co.kalpa.olivia.controller;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import kr.co.kalpa.olivia.model.FileInfo;
import kr.co.kalpa.olivia.servlet.view.DownloadView;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/file")
public class FileController {
	
//	@Autowired
//	private JuliaConfig juliaConfig;


	/**
	 * 
	 * @param fileInfo
	 * @param response
	 * @param auth
	 */
	@RequestMapping(value="/download/{fileId}", method = RequestMethod.GET)
	public ModelAndView download(FileInfo fileInfo,	HttpServletResponse response, Authentication auth) {
		log.debug(fileInfo.toString());
		ModelAndView mav = new ModelAndView();
		mav.setView( new DownloadView() );
		mav.addObject("fileInfo", fileInfo);
		return mav;
	}
	
}
