package kr.co.kalpa.olivia.controller;

import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import kr.co.kalpa.olivia.exception.BoardException;
import kr.co.kalpa.olivia.exception.FileboxException;
import kr.co.kalpa.olivia.model.JsonData;
import kr.co.kalpa.olivia.model.board.BoardFile;
import kr.co.kalpa.olivia.model.board.BoardTag;
import kr.co.kalpa.olivia.model.filebox.FileInfo;
import kr.co.kalpa.olivia.model.filebox.Filebox;
import kr.co.kalpa.olivia.service.FileboxService;
import kr.co.kalpa.olivia.servlet.view.JsonView;
import kr.co.kalpa.olivia.utils.CommonUtil;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/filebox")
public class FileboxController<T> extends BaseController{

	private String baseUrl ="/filebox";
	private FileboxService fileboxService;

	@Value("${file.base.repository}")
	private String fileBaseRepository;
	
    public FileboxController(FileboxService fielboxService) {
        this.fileboxService = fielboxService;
    }

	
	@GetMapping("")
	public String filebox(
			@RequestParam(value="parentId", required=false, defaultValue="0") Integer parentId,
			Model model) throws SQLException {
		log.debug("********************************************");
		log.debug("filebox");
		log.debug("********************************************");
		//List<Filebox> list = fielboxService.subFolderList(parentId);
//		for (Filebox filebox : list) {			
//			Integer[] arrayData = (Integer[]) filebox.getPath().getArray();
//			log.debug("{}",arrayData);
//		}
		//model.addAttribute("list", list);
		
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
		int i = fileboxService.addFolder(filebox);
		if(i>0) {			
			mav.addObject("filebox", filebox);
			mav.addObject("result", "OK");
		}else {
			mav.addObject("result", "NK");
		}
		return mav;
	}
	/**
	 * jsTree을 만들 수 있는 데이터를 만든다
	 * @param parentId
	 * @return
	 */
	@ResponseBody
	@GetMapping("/tree-data/{parentId}")
	public String treeData(@PathVariable Integer parentId)  {
		List<Filebox> list = fileboxService.subFolderList(parentId);
		JsonData jsonData = new JsonData();
		jsonData.put("list", list);
		return jsonData.toJson();
	}
	@ResponseBody
	@GetMapping("/{boxId}/upload-files")
	public String uploadFiles(@PathVariable Integer boxId, @RequestPart("files") List<MultipartFile> files) throws  FileboxException  {
		
		//file를 옮기고 fileList를 채운다.
		for (MultipartFile file : files) {
			if (!file.isEmpty()) {
				FileInfo fileInfo = moveToRepository(file,boxId);
				fileboxService.insertFileInfo(fileInfo);
			}
		}
		List<FileInfo> list = fileboxService.selectFiles(boxId);
		
		JsonData jsonData = new JsonData();
		jsonData.put("list", list);
		return jsonData.toJson();

	}
	private FileInfo moveToRepository(MultipartFile file, Integer boxId) throws FileboxException {
		FileInfo fileInfo = new FileInfo();
		//0.저장폴더 생성
		String[] ymdArray = CommonUtil.getTodayAsArray();
		String targetFolder = String.format("%s/%s/%s", fileBaseRepository, ymdArray[0], ymdArray[1]);
		CommonUtil.createFolder(targetFolder);

		//1.저장위치로 파일을 옮긴다.
		Path destinationPath = Paths.get(targetFolder);
		String uuid = CommonUtil.getUuid();
		
		String orgName = file.getOriginalFilename();
		String ext = CommonUtil.getExtension(orgName);
		Long fileSize = file.getSize();
		
        Path destinationFilePath = destinationPath.resolve(uuid);
        
        try {
            //저장장소로 file을 옮긴다.
        	file.transferTo(destinationFilePath.toFile());
            //fileInfo를 채운다
        	fileInfo.setBoxId(boxId);
            fileInfo.setPhyFolder(targetFolder);
            fileInfo.setPhyName(uuid);
            fileInfo.setOrgName(orgName);
            fileInfo.setFileSize(fileSize);
            fileInfo.setStatus("O");
            //TODO image이면  w,h 를 구하자
            fileInfo.setExt(ext);
            log.debug("업로드 파일 boardFile : {}", fileInfo);
        } catch (IOException e) {
        	throw new FileboxException(e.getMessage());
        }

        return fileInfo;
	}	
}
