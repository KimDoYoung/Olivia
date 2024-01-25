package kr.co.kalpa.olivia.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.kalpa.olivia.model.filebox.FbFile;
import kr.co.kalpa.olivia.model.filebox.FbNode;
import kr.co.kalpa.olivia.repository.FileboxRepository;


@Service
public class FileboxService {

	private FileboxRepository repository;

	public FileboxService(FileboxRepository repository) {
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
	public List<FbNode> subNodeList(Long parentId) {
		return repository.subNodeList(parentId);
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
	 * file을 추가하고 추가된 파일의 fileId를 리턴한다
	 * @param FbFile
	 * @return
	 */
	@Transactional
	public Long insertFbFile(FbFile FbFile) {
		
		Long insertedFileId = repository.insertFile(FbFile);
		return insertedFileId;
	}

	/**
	 * file_info에서 파일들을 지운다.
	 * @param deleteFbFileIdList
	 * @return
	 */
	public int deleteFiles(List<Long> deleteFbFileIdList) {
		int totalDeletedCount = 0;
		for (Long fileId : deleteFbFileIdList) {
		  totalDeletedCount += repository.deleteFile(fileId);
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

}
