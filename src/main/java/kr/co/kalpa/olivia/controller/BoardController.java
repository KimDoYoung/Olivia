package kr.co.kalpa.olivia.controller;

import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

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
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.multipart.MultipartFile;

import kr.co.kalpa.olivia.exception.BoardException;
import kr.co.kalpa.olivia.model.QueryAttr;
import kr.co.kalpa.olivia.model.board.Board;
import kr.co.kalpa.olivia.model.board.BoardFile;
import kr.co.kalpa.olivia.model.board.BoardTag;
import kr.co.kalpa.olivia.service.BoardService;
import kr.co.kalpa.olivia.utils.CommonUtil;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("board")
public class BoardController{

	@Value("${file.base.repository}")
	private String fileBaseRepository;
	   
	private BoardService boardService;
	private QueryAttr queryAttr; 
	
	public BoardController(BoardService boardService) {
		this.boardService = boardService;
		this.queryAttr = new QueryAttr();
	}
	
	@GetMapping("")
	public String list(@ModelAttribute QueryAttr queryAttr, Model model) {

		log.debug("********************************************");
		log.debug("board list");
		log.debug("********************************************");
		queryAttr.put("status", "1");
		queryAttr.put("dateRangeCheck", true);
		
		List<Board> list=boardService.selectList(queryAttr);
		model.addAttribute("list", list);
		return "board/list";
	}
	@GetMapping("insert")
	public String insertPage(Model model) {
		String startYmd = CommonUtil.today();
		String endYmd = "9999-12-13";
		model.addAttribute("startYmd", startYmd);
		model.addAttribute("endYmd", endYmd);
		return "board/insert_form";
	}	
	/**
	 * board 저장
	 * @param board
	 * @return
	 * @throws BoardException 
	 */
	@PostMapping("insert")
	public String insert(@ModelAttribute("board")Board board, 
			@RequestPart("files") List<MultipartFile> files,
			@RequestParam(name="tags", required=false) String tags
	) throws BoardException {

		board.setFileList(new ArrayList<BoardFile>());
		board.setTagList(new ArrayList<BoardTag>());
		
		//file를 옮기고 fileList를 채운다.
		for (MultipartFile file : files) {
			if (!file.isEmpty()) {
				BoardFile boardFile = toBoardFile(file);
				board.getFileList().add(boardFile);
			}
		}
		//tagList를 넣는다.
		List<String> list = CommonUtil.toListFromString(tags);
		for (String name : list) {
			BoardTag tag = new BoardTag();
			tag.setName(name);
			board.getTagList().add( tag  );
		}
		
		int i = boardService.insert(board);

		return "redirect:/board";
	}

	@GetMapping("update")
	public String updatePage(Integer boardId, Model model) throws BoardException {
		Board board = boardService.selectBoardOne(boardId);
		if(board == null) {
			throw new BoardException("board id : " + boardId + " is not exist");
		}		
		String startYmd = board.getStartYmd();
		String endYmd = board.getEndYmd();
		board.setStartYmd(CommonUtil.displayYmd(startYmd));
		board.setEndYmd(CommonUtil.displayYmd(endYmd));
		model.addAttribute("board", board );
		
		return "board/update_form";
	}	
	@PostMapping("update")
	public String update(
			@ModelAttribute("board") Board board, 
			@RequestParam(name="deletefiles", required=false) Integer[] deleteFiles, 
			@RequestPart("files") List<MultipartFile> files,
			@RequestParam(name="tags", required=false) String tags,			
			Model model
			) throws BoardException {
		log.debug("board:{}",board);
		log.debug("tags:{}",tags);
		log.debug("deleteFiles:{}", deleteFiles);
		
		board.setFileList(new ArrayList<BoardFile>());
		board.setTagList(new ArrayList<BoardTag>());
		
		//file를 옮기고 fileList를 채운다.
		for (MultipartFile file : files) {
			if (!file.isEmpty()) {
				BoardFile boardFile = toBoardFile(file);
				board.getFileList().add(boardFile);
			}
		}
		//tagList를 넣는다.
		List<String> list = CommonUtil.toListFromString(tags);
		for (String name : list) {
			BoardTag tag = new BoardTag();
			tag.setName(name);
			board.getTagList().add( tag  );
		}
		
		//board update
		int i = boardService.update(board, deleteFiles);	
		
		return "redirect:/board";
	}
	
	@PostMapping("delete")
	public String delete(@RequestParam("boardId") Integer boardId) {
		
		int i = boardService.delete(boardId);
		
		return "redirect:/board";
	}
	
	@GetMapping("view/{boardId}")
	public String viewPage(@PathVariable Integer boardId, Model model) throws BoardException {
		Board board = boardService.selectBoardOne(boardId);
		model.addAttribute("board", board);
		return "/board/view";
	}

	
	private BoardFile toBoardFile(MultipartFile file) throws BoardException {
		BoardFile boardFile = new BoardFile();
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
            file.transferTo(destinationFilePath.toFile());
            boardFile.setPhyFolder(targetFolder);
            boardFile.setPhyName(uuid);
            boardFile.setOrgName(orgName);
            boardFile.setFileSize(fileSize);
            boardFile.setExt(ext);
            log.debug("업로드 파일 boardFile : {}", boardFile);
        } catch (IOException e) {
        	throw new BoardException(e.getMessage());
        }

        return boardFile;
	}	

}
