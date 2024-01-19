package kr.co.kalpa.olivia.controller;

import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import kr.co.kalpa.olivia.exception.FileboxException;
import kr.co.kalpa.olivia.model.JsonData;
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
	//@PostMapping("/add-folder")
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
	@ResponseBody
	@GetMapping("/create-sub-filebox/{parentId}")
	public String createSubBox(@PathVariable("parentId") Integer parentId, String name) {
		Filebox filebox = new Filebox();
		filebox.setParentId(parentId);
		filebox.setFolderNm(name);
		int i = fileboxService.addFolder(filebox);
		int newId = fileboxService.getFileboxSeq();
		JsonData jsonData = new JsonData();
		if(i>0) {
			jsonData.put("result", "OK");
			jsonData.put("newId", newId);
		}else {
			jsonData.put("result", "NK");
		}
		return jsonData.toJson();
	}
	@ResponseBody
	@GetMapping("/rename-filebox/{boxId}")
	public String renameFilebox(@PathVariable("boxId") Integer boxId, String name) {
		Filebox filebox = new Filebox();
		filebox.setBoxId(boxId);
		filebox.setFolderNm(name);
		int i = fileboxService.renameFilebox(filebox);
		JsonData jsonData = new JsonData();
		if(i>0) {
			jsonData.put("result", "OK");
		}else {
			jsonData.put("result", "NK");
		}
		return jsonData.toJson();
	}
	/**
	 * delete file_box
	 * 포함된 파일이 없을 경우 
	 * @param boxId
	 * @return
	 */
	@ResponseBody
	@GetMapping("/delete-filebox/{boxId}")
	public String deleteFilebox(@PathVariable("boxId") Integer boxId) {
		
		JsonData jsonData = new JsonData();
		int count= fileboxService.countFilesInFilebox(boxId);
		if(count > 0) {
			jsonData.put("result", "NK");
			jsonData.put("msg", "폴더 안에 파일들이 존재합니다. 비어있는 폴더만 삭제할 수 있습니다.");
			return jsonData.toJson();
		}
		int i = fileboxService.deleteFilebox(boxId);
		if(i > 0) {
			jsonData.put("result", "OK");
		}else {
			jsonData.put("result", "NK");
			jsonData.put("msg","폴더를 삭제하는 중 에러가 발생했습니다");
		}
		return jsonData.toJson();
	}
	@ResponseBody
	@GetMapping("/move-filebox/{boxId}")
	public String moveFilebox(@PathVariable("boxId") Integer boxId, @RequestParam("newParentId") Integer newParentId ) {
		
		JsonData jsonData = new JsonData();
		int i = fileboxService.moveFilebox(boxId, newParentId);
		if(i > 0) {
			jsonData.put("result", "OK");
		}else {
			jsonData.put("result", "NK");
			jsonData.put("msg","폴더를 이동하는 중 에러가 발생했습니다");
		}
		return jsonData.toJson();
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
	@PostMapping("/upload-files/{boxId}")
	public String uploadFiles(@PathVariable Integer boxId, @RequestParam("files") List<MultipartFile> files) throws  FileboxException  {
		
		//file를 옮기고 fileList를 채운다.
		for (MultipartFile file : files) {
			if (!file.isEmpty()) {
				FileInfo fileInfo = moveToRepository(file,boxId);

				//file_info테이블 저장
				int i = fileboxService.insertFileInfoAndMatch(fileInfo);
				if(i>0) {
					log.debug("파일저장됨 : {}", fileInfo);
				}
			}
		}
//		return "forward:/filebox/file-list/" + boxId;
		List<FileInfo> list = fileboxService.selectFiles(boxId);
		
		JsonData jsonData = new JsonData();
		jsonData.put("list", list);
		return jsonData.toJson();
	}

	@ResponseBody
	@GetMapping("/file-list/{boxId}")
	public String fileListInBox(@PathVariable Integer boxId) throws  FileboxException  {
		List<FileInfo> list = fileboxService.selectFiles(boxId);
		
		JsonData jsonData = new JsonData();
		jsonData.put("list", list);
		return jsonData.toJson();
	}
	//delete-file
	@ResponseBody
	@PostMapping("/delete-file/{boxId}")
	public String deleteFileInfo(HttpServletRequest request, @PathVariable Integer boxId,@RequestBody List<Integer> deleteFileInfoIdList) throws  FileboxException  {
		
		printRequest(request);
		
		int deleteCount = fileboxService.deleteFiles(deleteFileInfoIdList);
		List<FileInfo> list = fileboxService.selectFiles(boxId);
		JsonData jsonData = new JsonData();
		jsonData.put("deletedCount", deleteCount);
		jsonData.put("list", list);
		return jsonData.toJson();
	}
	/**
	 * client로부터 전송받은 파일을 server의 repository로 이동 후
	 * 파일정보 FileInfo를 만들어서 리턴한다.
	 * 
	 * @param file
	 * @param boxId
	 * @return
	 * @throws FileboxException
	 */
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
