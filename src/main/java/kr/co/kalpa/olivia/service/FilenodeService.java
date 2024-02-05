package kr.co.kalpa.olivia.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.kalpa.olivia.model.filebox.FbFile;
import kr.co.kalpa.olivia.model.filebox.FbNode;
import kr.co.kalpa.olivia.repository.FilenodeRepository;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Service
public class FilenodeService {

	private FilenodeRepository repository;

	public FilenodeService(FilenodeRepository repository) {
		this.repository = repository;
	}


	/**
	 * node를 하나 추가한다
	 * @param fbNode
	 * @return
	 */
	@Transactional
	public Long insertNode(FbNode fbNode) {
		return repository.insertNode(fbNode);
	}

	/**
	 * parentId의 하위 폴더리스트를 구해서 리턴 
	 * 
	 * @param parentId
	 * @return
	 */
	public List<FbNode> subNodeList(FbNode fbNode) {
		return repository.subNodeList(fbNode);
	}

	/**
	 * nodeId에 담겨 있는 파일들을 리스트
	 * @param nodeId
	 * @return FbFile list
	 */
	public List<FbFile> selectFiles(Long nodeId) {
		return repository.selectFiles(nodeId);
	}

	/**
	 * 
	 * file을 추가하고 추가된 파일의 fileId를 리턴한다
	 * @param file
	 * @return
	 */
	@Transactional
	public Long insertFile(FbNode node, FbFile file) {
		
		Long insertedNodeId = repository.insertNode(node);
		insertedNodeId = node.getNodeId();
		file.setNodeId(insertedNodeId);
		Long insertedFileId = repository.insertFile(file);
		log.debug("file inserted : node:{}, file:{}",insertedNodeId, insertedFileId);
		return insertedFileId;
	}

	/**
	 * file_info에서 파일들을 지운다.
	 * @param deleteFbFileIdList
	 * @return
	 */
	@Transactional
	public int deleteFiles(List<Long> deleteFbFileIdList) {
		int totalDeletedCount = 0;
		for (Long fileId : deleteFbFileIdList) {

		  FbFile file = repository.selectFileOne(fileId);	
		  Long nodeId = file.getNodeId();

		  //파일을 지운다.
		  totalDeletedCount += repository.deleteFile(fileId);

		  //노드를 지운다		  
		  repository.deleteNode(nodeId);
		}
		return totalDeletedCount;
	}

	public int renameNode(FbNode fbNode) {
		return repository.renameNode(fbNode);
	}

	public int countFilesInNode(Long nodeId) {
		return repository.countFilesInNode(nodeId);
	}

	@Transactional
	public int deleteNode(Long nodeId) {
		return repository.deleteNode(nodeId);
	}

	public int moveNode(Long nodeId, Long newParentId) {
		FbNode node = new FbNode();
		node.setNodeId(nodeId);
		node.setParentId(newParentId);
		return repository.moveNode(node);
	}

	/**
	 * fileId에 해당하는 FbFile을 조회한다.
	 * @param fileId
	 * @return
	 */
	public FbFile selectOneFile(Long fileId) {
		return repository.selectFileOne(fileId);
	}
	

}
