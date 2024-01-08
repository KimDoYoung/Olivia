package kr.co.kalpa.olivia.service;

import java.util.List;

import javax.validation.Valid;

import org.springframework.stereotype.Service;

import kr.co.kalpa.olivia.model.QueryAttr;
import kr.co.kalpa.olivia.model.board.Board;
import kr.co.kalpa.olivia.repository.BoardRepository;

@Service
public class BoardService {

	private BoardRepository repository ;

    BoardService(BoardRepository repository) {
        this.repository = repository;
    }

    public List<Board> selectList(QueryAttr qa) {
		return repository.selectList(qa);
	}

	public int insert(@Valid Board board) {
		return repository.insert(board);
	}
	
}
