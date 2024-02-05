package kr.co.kalpa.olivia.controller;

import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authorization.AuthenticatedAuthorizationManager;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
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
import kr.co.kalpa.olivia.model.filebox.FbFile;
import kr.co.kalpa.olivia.model.filebox.FbNode;
import kr.co.kalpa.olivia.security.UserPrincipal;
import kr.co.kalpa.olivia.service.FilenodeService;
import kr.co.kalpa.olivia.servlet.view.JsonView;
import kr.co.kalpa.olivia.utils.CommonUtil;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/filebox")
public class FileboxController extends BaseController {

	private String baseUrl = "/filebox";
	private FilenodeService nodeService;

	@Value("${file.base.repository}")
	private String fileBaseRepository;

	public FileboxController(FilenodeService fielboxService) {
		this.nodeService = fielboxService;
	}

	@GetMapping("")
	public String FbNode() throws SQLException {
		log.debug("********************************************");
		log.debug("FbNode");
		log.debug("********************************************");
		return baseUrl + "/filebox";
	}

	/**
	 * jsTree을 만들 수 있는 데이터를 만든다
	 * 
	 * @param parentId
	 * @return
	 */
	@ResponseBody
	@GetMapping("/tree-data/{parentId}")
	public String treeData(@PathVariable Long parentId, HttpServletRequest request) {

		String userId = (String) request.getSession().getAttribute("userId");
		FbNode fbNode = new FbNode();
		fbNode.setNodeId(parentId);
		fbNode.setOwnerId(userId);

		List<FbNode> list = nodeService.subNodeList(fbNode);
		JsonData jsonData = new JsonData();
		jsonData.put("list", list);
		return jsonData.toJson();
	}

	/**
	 * client에서 form으로 보낼 수도 있고 ajx로 보낼 수도 있고 2가지모두 1개의 controller에서 처리
	 * 
	 * @param fbNode
	 * @param model
	 * @return
	 */
	// @PostMapping("/add-folder")
	public ModelAndView addFolder(HttpServletRequest request, @ModelAttribute("FbNode") FbNode fbNode, Model model) {

		ModelAndView mav = new ModelAndView();
		boolean isAjax = isAjax(request); //
		if (isAjax) {
			fbNode = getClassFromBody(request, FbNode.class);
			mav.setView(new JsonView());
		} else {
			mav.setViewName("redirect:" + baseUrl);
		}
		Long nodeId = nodeService.insertNode(fbNode);
		fbNode.setNodeId(nodeId);

		if (nodeId > 0) {
			mav.addObject("FbNode", fbNode);
			mav.addObject("result", "OK");
		} else {
			mav.addObject("result", "NK");
		}
		return mav;
	}

	/**
	 * ajax로 처리되면서 parentId 밑에 name으로 하위폴더를 생성한다
	 * 
	 * @param parentId
	 * @param name
	 * @return
	 */
	@ResponseBody
	@GetMapping("/create-sub-node/{parentId}")
	public String createSubBox(@PathVariable("parentId") Long parentId, String name) {
		FbNode fbNode = new FbNode();
		fbNode.setNodeType("D");
		fbNode.setParentId(parentId);
		fbNode.setOwnerId(loginUserId());
		fbNode.setNodeName(name);
		fbNode.setOwnerAuth("RWX");
		fbNode.setGroupAuth("RWX");
		fbNode.setGuestAuth("RWX");
		fbNode.setCreateBy(loginUserId());

		nodeService.insertNode(fbNode);
		Long nodeId = fbNode.getNodeId();

		JsonData jsonData = new JsonData();
		jsonData.put("result", "OK");
		jsonData.put("newId", nodeId);
		return jsonData.toJson();
	}

	@ResponseBody
	@GetMapping("/rename-node/{nodeId}")
	public String renameFbNode(@PathVariable("nodeId") Long nodeId, String name) {
		FbNode fbNode = new FbNode();
		fbNode.setNodeId(nodeId);
		fbNode.setNodeName(name);
		int i = nodeService.renameNode(fbNode);
		JsonData jsonData = new JsonData();
		if (i > 0) {
			jsonData.put("result", "OK");
		} else {
			jsonData.put("result", "NK");
		}
		return jsonData.toJson();
	}

	/**
	 * delete file_box 포함된 파일이 없을 경우
	 * 
	 * @param boxId
	 * @return
	 */
	@ResponseBody
	@GetMapping("/delete-node/{nodeId}")
	public String deleteFbNode(@PathVariable("nodeId") Long nodeId) {

		JsonData jsonData = new JsonData();
		int count = nodeService.countFilesInNode(nodeId);
		if (count > 0) {
			jsonData.put("result", "NK");
			jsonData.put("msg", "폴더 안에 파일들이 존재합니다. 비어있는 폴더만 삭제할 수 있습니다.");
			return jsonData.toJson();
		}
		int i = nodeService.deleteNode(nodeId);
		if (i > 0) {
			jsonData.put("result", "OK");
		} else {
			jsonData.put("result", "NK");
			jsonData.put("msg", "폴더를 삭제하는 중 에러가 발생했습니다");
		}
		return jsonData.toJson();
	}

	@ResponseBody
	@GetMapping("/move-node/{nodeId}")
	public String moveFbNode(@PathVariable("nodeId") Long nodeId, @RequestParam("newParentId") Long newParentId) {

		JsonData jsonData = new JsonData();
		int i = nodeService.moveNode(nodeId, newParentId);
		if (i > 0) {
			jsonData.put("result", "OK");
		} else {
			jsonData.put("result", "NK");
			jsonData.put("msg", "폴더를 이동하는 중 에러가 발생했습니다");
		}
		return jsonData.toJson();
	}

	@ResponseBody
	@PostMapping("/upload-files/{nodeId}")
	public String uploadFiles(@PathVariable Long nodeId, @RequestParam("files") List<MultipartFile> files)
			throws FileboxException {

		// file를 옮기고 fileList를 채운다.
		for (MultipartFile file : files) {
			if (!file.isEmpty()) {
				FbNode fbNode = newFileNode(nodeId);
				FbFile fbFile = moveToRepository(file);
				// fb_file테이블 저장
				Long i = nodeService.insertFile(fbNode, fbFile);
				if (i > 0) {
					log.debug("파일저장됨 : {}", fbFile);
				}
			}
		}
//		return "forward:/FbNode/file-list/" + boxId;
		List<FbFile> list = nodeService.selectFiles(nodeId);

		JsonData jsonData = new JsonData();
		jsonData.put("list", list);
		return jsonData.toJson();
	}

	private FbNode newFileNode(Long parentId) {
		FbNode node = new FbNode();
		node.setNodeType("F");
		node.setParentId(parentId);
		node.setOwnerId(loginUserId());
		node.setNodeName(null);
		node.setOwnerAuth("RWX");
		node.setGroupAuth("RWX");
		node.setGuestAuth("RWX");
		node.setCreateBy(loginUserId());
		return node;
	}

	@ResponseBody
	@GetMapping("/file-list/{nodeId}")
	public String fileListInBox(@PathVariable Long nodeId) throws FileboxException {
		List<FbFile> list = nodeService.selectFiles(nodeId);

		JsonData jsonData = new JsonData();
		jsonData.put("list", list);
		return jsonData.toJson();
	}

	// delete-file
	@ResponseBody
	@PostMapping("/delete-file/{nodeId}")
	public String deleteFbFile(HttpServletRequest request, @PathVariable Long nodeId,
			@RequestBody List<Long> deleteFbFileIdList) throws FileboxException {

		printRequest(request);

		int deleteCount = nodeService.deleteFiles(deleteFbFileIdList);

		List<FbFile> list = nodeService.selectFiles(nodeId);
		JsonData jsonData = new JsonData();
		jsonData.put("deletedCount", deleteCount);
		jsonData.put("list", list);
		return jsonData.toJson();
	}

	/**
	 * client로부터 전송받은 파일을 server의 repository로 이동 후 파일정보 FbFile를 만들어서 리턴한다.
	 * 
	 * @param file
	 * @return
	 * @throws FileboxException
	 */
	private FbFile moveToRepository(MultipartFile file) throws FileboxException {
		FbFile fbFile = new FbFile();
		// 0.저장폴더 생성
		String[] ymdArray = CommonUtil.getTodayAsArray();
		String targetFolder = String.format("%s/%s/%s", fileBaseRepository, ymdArray[0], ymdArray[1]);
		CommonUtil.createFolder(targetFolder);

		// 1.저장위치로 파일을 옮긴다.
		Path destinationPath = Paths.get(targetFolder);
		String uuid = CommonUtil.getUuid();

		String orgName = file.getOriginalFilename();
		String ext = CommonUtil.getExtension(orgName);
		Long fileSize = file.getSize();

		Path destinationFilePath = destinationPath.resolve(uuid);

		try {
			// 저장장소로 file을 옮긴다.
			file.transferTo(destinationFilePath.toFile());
			// FbFile를 채운다
			fbFile.setNodeId(null);
			fbFile.setPhyFolder(targetFolder);
			fbFile.setPhyName(uuid);
			fbFile.setOrgName(orgName);
			fbFile.setFileSize(fileSize);
			fbFile.setStatus("N");
			// TODO image이면 w,h 를 구하자
			fbFile.setExt(ext);
			log.debug("업로드 파일 boardFile : {}", fbFile);
		} catch (IOException e) {
			throw new FileboxException(e.getMessage());
		}

		return fbFile;
	}

}