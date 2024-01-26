package kr.co.kalpa.olivia.repository;

import java.util.List;

import kr.co.kalpa.olivia.model.filebox.FbFile;
import kr.co.kalpa.olivia.model.filebox.FbNode;

public interface FileboxRepository {

	/**
	 * node를 추가
	 * 
	 * @param fbNode
	 * @return
	 */
	Long insertNode(FbNode fbNode);
	

	/**
	 * parentId안에 포함되어 있는 node 리스트
	 * 
	 * @param parentId
	 * @return
	 */
	List<FbNode> subNodeList(FbNode fbNode);

	
	/**
	 * FbNode의 이름을 바꾼다.
	 * @param FbNode
	 * @return
	 */
	int renameNode(FbNode fbNode);

	
	/**
	 * boxId에 담겨져 있는 파일들 리스트 
	 * @param boxId
	 * @return
	 */
	List<FbFile> selectFiles(Long nodeId);

	/**
	 * file_info 테이블에 저장
	 * @param FbFile
	 * @return
	 */
	Long insertFile(FbFile fbFile);

	/**
	 * fileId에 해당하는 파일을 삭제
	 * 
	 * @param fileId
	 * @return
	 */
	int deleteFile(Long fileId);

	/**
	 * boxId 에 포함된 파일의 갯수를 리턴
	 * @param boxId
	 * @return
	 */
	int countFilesInNode(Long nodeId);
	/**
	 * file_box에서 boxId에 해당하는 row를 지운다.
	 * @param boxId
	 * @return
	 */
	int deleteNode(Long nodeId);
	
	/**
	 * node를 새로운 parent_id로 옮긴다.
	 * 
	 * @param fbNode
	 * @return
	 */
	int moveNode(FbNode fbNode);


	/**
	 * fileId로 fb_file에서 1개를 찾는다.
	 * @param fileId
	 * @return
	 */
	FbFile selectFileOne(Long fileId);

}
