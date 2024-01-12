package kr.co.kalpa.olivia.repository;

import java.util.List;

import kr.co.kalpa.olivia.model.filebox.Filebox;

public interface FileboxRepository {

	int addFolder(Filebox filebox);

	List<Filebox> subFolderList(int parentId);

}
