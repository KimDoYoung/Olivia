package kr.co.kalpa.olivia.service;

import java.util.List;

import javax.validation.Valid;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.kalpa.olivia.model.QueryAttr;
import kr.co.kalpa.olivia.model.board.Board;
import kr.co.kalpa.olivia.model.board.BoardFile;
import kr.co.kalpa.olivia.model.board.BoardFileMatch;
import kr.co.kalpa.olivia.model.board.BoardTag;
import kr.co.kalpa.olivia.model.board.BoardTagMatch;
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

    @Transactional
	public int insert(@Valid Board board) {
    	//board
    	int boardId = repository.getSequence();
    	board.setBoardId(boardId);
		int i =  repository.insert(board);
		
		//files and filematch
		if(board.getFileList() != null) {
			int seq = 1;
			for (BoardFile boardFile : board.getFileList()) {
				int boardFileId = repository.getSequence();
				boardFile.setBoardFileId(boardFileId);
				//boardFile.setBoardFileId(null);
				repository.insertBoardFile(boardFile);
				
				BoardFileMatch boardFileMatch = new BoardFileMatch();
				boardFileMatch.setBoardId(boardId);
				boardFileMatch.setBoardFileId(boardFileId);
				boardFileMatch.setSeq(seq++);
				boardFileMatch.setDeletedYn("N");
				
				repository.insertBoardFileMatch(boardFileMatch);
			}
		}
		
		//tags and tagsmatch
		if(board.getTagList() != null) {
			for (BoardTag boardTag : board.getTagList()) {
				BoardTag foundTag = repository.selectOneTag(boardTag);
				Integer boardTagId ;
				if(foundTag == null) {
					boardTagId = repository.getSequence();
					boardTag.setTagId(boardTagId);
					repository.insertBoardTag(boardTag);
				}else {
					boardTagId = foundTag.getTagId();
				}
				//match를 저장
				BoardTagMatch boardTagMatch = new BoardTagMatch();
				boardTagMatch.setBoardId(boardId);
				boardTagMatch.setTagId(boardTagId);
				repository.insertBoardTagMatch(boardTagMatch);
			}
		}
		return i;
	}

	public int getSequence() {
		return repository.getSequence();
	}

	/**
	 * 1. board table에서 1개 가져오기
	 * 2. board tag list가져오기
	 * 3. board file 가져오기 
	 * 
	 * @param boardId
	 * @return
	 */
	public Board selectBoardOne(Integer boardId) {
		
		Board board = new Board();
		board.setBoardId(boardId);
		board = repository.selectBoardOne(board);
		
		//tag list
		List<BoardTag> list = repository.selectTagList(board.getBoardId());
		board.setTagList(list);
		
		//file list
		List<BoardFile> fileList = repository.selectFileList(board.getBoardId());
		board.setFileList(fileList);
		return board;
		
	}
	/**
	 * boardFileMatch에서 boardFileId로 삭제한다
	 * 
	 * @param board
	 * @param deleteFiles
	 * @return
	 */
	@Transactional
	public int update(Board board, Integer[] deleteFiles) {
		
		int boardId = board.getBoardId();
		//첨부된 파일 지울 게 있으면 지운다.
		if(deleteFiles != null) {
			for (Integer boardFileId : deleteFiles) {
				repository.deleteBoardFileMatch(boardFileId);
			}
		}
		
		//files and filematch
		if(board.getFileList() != null) {
			int seq = 1;
			for (BoardFile boardFile : board.getFileList()) {
				int boardFileId = repository.getSequence();
				boardFile.setBoardFileId(boardFileId);
				//boardFile.setBoardFileId(null);
				repository.insertBoardFile(boardFile);
				
				BoardFileMatch boardFileMatch = new BoardFileMatch();
				boardFileMatch.setBoardId(boardId);
				boardFileMatch.setBoardFileId(boardFileId);
				boardFileMatch.setSeq(seq++);
				boardFileMatch.setDeletedYn("N");
				
				repository.insertBoardFileMatch(boardFileMatch);
			}
		}
		
		//태그를 모두 지우고.
		repository.deleteBoardTagMatch(board.getBoardId());

		//태그 넣기
		if(board.getTagList() != null) {
			for (BoardTag boardTag : board.getTagList()) {
				BoardTag foundTag = repository.selectOneTag(boardTag);
				Integer boardTagId ;
				if(foundTag == null) {
					boardTagId = repository.getSequence();
					boardTag.setTagId(boardTagId);
					repository.insertBoardTag(boardTag);
				}else {
					boardTagId = foundTag.getTagId();
				}
				//match를 저장
				BoardTagMatch boardTagMatch = new BoardTagMatch();
				boardTagMatch.setBoardId(boardId);
				boardTagMatch.setTagId(boardTagId);
				repository.insertBoardTagMatch(boardTagMatch);
			}
		}		
		//board update
		return repository.update(board);
	}

	/**
	 * boardId에 해당하는 board를 삭제
	 * 1. tag Match 삭제
	 * 2. file Match 삭제
	 * 3. board 자체를 삭제
	 * 
	 * @param boardId
	 */
	@Transactional
	public int delete(Integer boardId) {
		repository.deleteBoardFileMatchWithBoardId(boardId);
		repository.deleteBoardTagMatchWithBoardId(boardId);
		return repository.delete(boardId);
	}
	
}
