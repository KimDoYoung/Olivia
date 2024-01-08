package kr.co.kalpa.olivia;

import java.util.List;

import javax.validation.Valid;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.kalpa.olivia.model.QueryAttr;
import kr.co.kalpa.olivia.model.board.Board;
import kr.co.kalpa.olivia.service.BoardService;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("board")
public class BoardController{

	private BoardService boardService;
	private QueryAttr queryAttr; 
	
	public BoardController(BoardService boardService) {
		this.boardService = boardService;
		this.queryAttr = new QueryAttr();
	}
	
	@GetMapping("/list")
	public String list(@ModelAttribute QueryAttr queryAttr, Model model) {

		log.debug("********************************************");
		log.debug("board list");
		log.debug("********************************************");
		List<Board> list=boardService.selectList(null);
		model.addAttribute("list", list);
		return "board/list";
	}
	@GetMapping("insert")
	public String insertPage() {
		 return "board/insert";
	}	
	@PostMapping("insert")
	public String insert(@Valid @ModelAttribute("board")Board board) {
		
		int i = boardService.insert(board);
		
		return "board/insert";
	}	
}
