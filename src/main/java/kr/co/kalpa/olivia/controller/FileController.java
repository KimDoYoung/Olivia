package kr.co.kalpa.olivia.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import kr.co.kalpa.olivia.exception.FileboxException;
import kr.co.kalpa.olivia.model.FileInfo;
import kr.co.kalpa.olivia.model.filebox.FbFile;
import kr.co.kalpa.olivia.service.FilenodeService;
import kr.co.kalpa.olivia.servlet.view.DownloadView;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/file")
public class FileController extends BaseController {
	
//	@Autowired
//	private JuliaConfig juliaConfig;

	private FilenodeService fileService;
	
	public FileController(FilenodeService fileService) {
		this.fileService = fileService;
	}
	@GetMapping("/downloads")
	public ModelAndView downloads(@RequestParam("fileIds") List<Long> fileIds, HttpServletRequest request) throws FileboxException {
		String userId = super.loginUserId();
		if(userId == null) {
			throw new FileboxException("로그인 한 후에 다운로드 가능합니다");
		}
		List<FileInfo> list = new ArrayList<>();
		for (Long fileId : fileIds) {
			FbFile fbFile = fileService.selectOneFile(fileId);
			if(fbFile != null) {
				FileInfo fileInfo = new FileInfo();
				fileInfo.setFbFile(fbFile);
				fileInfo.setRequestUserId(userId);
				fileInfo.setAuthKey(request.getSession().getId());
				
				list.add(fileInfo);
			}
		}
		ModelAndView mav = new ModelAndView();
		mav.setView( new DownloadView() );
		mav.addObject("list", list);
		return mav;
		
	}
	/**
	 * 1개의 파일을 다운로드 한다.
	 * @param fileInfo
	 * @param response
	 * @param auth
	 * @throws FileboxException 
	 */
	@GetMapping("/download/{fileId}")
	public ModelAndView download(@PathVariable("fileId") Long fileId, HttpServletRequest request) throws FileboxException {
		
		String userId = super.loginUserId();
		if(userId == null) {
			throw new FileboxException("로그인 한 후에 다운로드 가능합니다");
		}
		
		FbFile fbFile = fileService.selectOneFile(fileId);
		
		FileInfo fileInfo = new FileInfo();
		fileInfo.setFbFile(fbFile);
		fileInfo.setRequestUserId(userId);
		fileInfo.setAuthKey(request.getSession().getId());
		
		List<FileInfo> list = new ArrayList<>();
		list.add(fileInfo);
		log.debug(fileInfo.toString());
		ModelAndView mav = new ModelAndView();
		mav.setView( new DownloadView() );
		mav.addObject("list", list);
		return mav;
	}
	
}
