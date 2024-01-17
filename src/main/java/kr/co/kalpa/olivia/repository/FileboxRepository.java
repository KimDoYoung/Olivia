package kr.co.kalpa.olivia.repository;

import java.util.List;

import kr.co.kalpa.olivia.model.filebox.FileInfo;
import kr.co.kalpa.olivia.model.filebox.FileMatch;
import kr.co.kalpa.olivia.model.filebox.Filebox;

public interface FileboxRepository {

	int addFolder(Filebox filebox);

	List<Filebox> subFolderList(int parentId);

	/**
	 * boxId에 담겨져 있는 파일들 리스트 
	 * @param boxId
	 * @return
	 */
	List<FileInfo> selectFiles(Integer boxId);

	/**
	 * file_info 테이블에 저장
	 * @param fileInfo
	 * @return
	 */
	Integer insertFileInfo(FileInfo fileInfo);

	/**
	 * file_match 테이블에 저장한다
	 * @param match
	 */
	Integer insertFileMatch(FileMatch match);

	int getFileInfoSeq();

	int deleteFileInfo(Integer fileInfoId);

}
