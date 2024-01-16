package kr.co.kalpa.olivia.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.kalpa.olivia.model.filebox.FileInfo;
import kr.co.kalpa.olivia.model.filebox.Filebox;
import kr.co.kalpa.olivia.repository.FileboxRepository;

@Service
public class FileboxService {
	private FileboxRepository repository;

	public FileboxService(FileboxRepository repository) {
		this.repository = repository;
	}

	/**
	 * filebox의 내용으로 폴더를 추가한다
	 * 
	 * @param filebox
	 * @return
	 */
	@Transactional
	public int addFolder(Filebox filebox) {
		return repository.addFolder(filebox);
	}
	/**
	 * parentId의 하위 폴더리스트를 구해서 리턴 
	 * 
	 * @param parentId
	 * @return
	 */
	public List<Filebox> subFolderList(int parentId) {
		return repository.subFolderList(parentId);
	}

	/**
	 * boxId에 담겨 있는 파일들을 리스트
	 * @param boxId
	 * @return
	 */
	public List<FileInfo> selectFiles(Integer boxId) {
		return repository.selectFiles(boxId);
	}

	@Transactional
	public Integer insertFileInfo(FileInfo fileInfo) {
		
		return repository.insertFileInfo(fileInfo);
	}

}
