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
	
	// boardId에 해당하는 tag들 조회
	List<BoardTag> selectTagList(Integer boardId);
	
	// board_id에 소속된 BoardFile을 조회
	List<BoardFile> selectFileList(Integer boardId);
	
	//board_file_match에서 boardFileId로 삭제한다
	void deleteBoardFileMatch(Integer boardFileId);
	
	//board_tag_match에서 board_id로 모두 지운다.
	void deleteBoardTagMatch(Integer boardId);
	
	//board update
	int update(Board board);
	
	//board delete
	int delete(Integer board);
	void deleteBoardFileMatchWithBoardId(Integer boardId);
	void deleteBoardTagMatchWithBoardId(Integer boardId);
}
