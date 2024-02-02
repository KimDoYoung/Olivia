package kr.co.kalpa.olivia.model;

import kr.co.kalpa.olivia.model.filebox.FbFile;
import lombok.Data;

@Data
public class FileInfo {
	private FbFile fbFile;
	private String requestUserId;
	private String authKey;
}
