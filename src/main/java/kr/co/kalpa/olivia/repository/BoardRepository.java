package kr.co.kalpa.olivia.repository;

import java.util.List;

import javax.validation.Valid;

import org.springframework.stereotype.Repository;

import kr.co.kalpa.olivia.model.QueryAttr;
import kr.co.kalpa.olivia.model.board.Board;
import kr.co.kalpa.olivia.model.board.BoardFile;
import kr.co.kalpa.olivia.model.board.Tags;
import kr.co.kalpa.olivia.model.board.BoardTagMatch;

@Repository
public interface BoardRepository {
	Long selectCount( QueryAttr queryAttr);
	List<Board > selectList(QueryAttr queryAttr);
	long insert(@Valid Board board);
	long insertBoardFile(BoardFile boardFile);
	long insertTags(Tags tag);
	void insertBoardTagMatch(BoardTagMatch boardTagMatch);
	Tags selectOneTag(Tags tag);
	Board selectBoardOne(Board board);
	
	// boardId에 해당하는 tag들 조회
	List<Tags> selectTagList(Long boardId);
	
	// board_id에 소속된 BoardFile을 조회
	List<BoardFile> selectFileList(Long boardId);
	
	//board update
	int update(Board board);
	
	//board delete
	int delete(Long board);
	
	/**
	 * board_id로 board_tag_match를 지운다.
	 * @param boardId
	 */
	void deleteBoardTagMatchWithBoardId(Long boardId);
	/**
	 * board_file을 file_id로  삭제한다. 즉 1개 삭제한다
	 * @param boardFileId
	 */
	void deleteBoardFileWithFileId(Long boardFileId);
	/**
	 * boardId로 board에 딸려 있는 파일들을 모두 지운다.
	 * @param boardId
	 */
	void deleteBoardFileWithBoardId(Long boardId);
	/**
	 * 다음번 seq
	 * @param boardId
	 * @return
	 */
	int getNextBoardFileSeq(long boardId);
}
