package kr.co.kalpa.olivia.repository;

import java.util.List;

import kr.co.kalpa.olivia.model.filebox.FileInfo;
import kr.co.kalpa.olivia.model.filebox.FileMatch;
import kr.co.kalpa.olivia.model.filebox.Filebox;

public interface FileboxRepository {

	int addFolder(Filebox filebox);
	int getFileBoxSeq(); //sequence

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
	/**
	 * filebox의 이름을 바꾼다.
	 * @param filebox
	 * @return
	 */
	int renameFilebox(Filebox filebox);
	/**
	 * boxId 에 포함된 파일의 갯수를 리턴
	 * @param boxId
	 * @return
	 */
	int countFilesInFilebox(Integer boxId);
	/**
	 * file_box에서 boxId에 해당하는 row를 지운다.
	 * @param boxId
	 * @return
	 */
	int deleteFilebox(Integer boxId);
	int moveFilebox(Filebox filebox);

}
