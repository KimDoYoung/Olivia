package kr.co.kalpa.olivia.repository;

import java.util.List;

import javax.validation.Valid;

import org.springframework.stereotype.Repository;

import kr.co.kalpa.olivia.model.QueryAttr;
import kr.co.kalpa.olivia.model.board.Board;
import kr.co.kalpa.olivia.model.board.BoardFile;
import kr.co.kalpa.olivia.model.board.BoardFileMatch;
import kr.co.kalpa.olivia.model.board.BoardTag;
import kr.co.kalpa.olivia.model.board.BoardTagMatch;

@Repository
public interface BoardRepository {
	Long selectCount( QueryAttr queryAttr);
	List<Board > selectList(QueryAttr queryAttr);
	int insert(@Valid Board board);
	int getSequence();
	int insertBoardFile(BoardFile boardFile);
	int insertBoardTag(BoardTag boardTag);
	void insertBoardFileMatch(BoardFileMatch boardFileMatch);
	void insertBoardTagMatch(BoardTagMatch boardTagMatch);
	BoardTag selectOneTag(BoardTag tag);
	Board selectBoardOne(Board board);
}
