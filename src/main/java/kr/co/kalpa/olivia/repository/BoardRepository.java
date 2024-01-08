package kr.co.kalpa.olivia.repository;

import java.util.List;

import javax.validation.Valid;

import org.springframework.stereotype.Repository;

import kr.co.kalpa.olivia.model.QueryAttr;
import kr.co.kalpa.olivia.model.board.Board;

@Repository
public interface BoardRepository {
	Long selectCount( QueryAttr queryAttr);
	List<Board >selectList(QueryAttr queryAttr);
	int insert(@Valid Board board);
}
