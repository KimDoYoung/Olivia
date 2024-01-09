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

	public Board selectBoardOne(Integer boardId) {
		Board board = new Board();
		board.setBoardId(boardId);
		return repository.selectBoardOne(board);
	}
	
}
