package kr.co.kalpa.olivia.service;

import kr.co.kalpa.olivia.model.filebox.Filebox;
import kr.co.kalpa.olivia.repository.FileboxRepository;

public class FileboxService {
	private FileboxRepository repository;

	public FileboxService(FileboxRepository repository) {
		this.repository = repository;
	}

	public int addFolder(Filebox filebox) {
		return repository.addFolder(filebox);
	}
}
