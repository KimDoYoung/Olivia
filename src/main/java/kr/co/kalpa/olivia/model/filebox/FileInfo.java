package kr.co.kalpa.olivia.model.filebox;

import lombok.Data;

/**
 * 파일정보
 */
@Data
public class FileInfo {
	private String fileInfoId ;
	private String boxId ;
	private String phyFolder ;
	private String phyName ;
	private String orgName ;
	private String mimeType ;
	private String fileSize ;
	private String ext ;
	private String note ;
	private String width ;
	private String height ;
	private String createOn ;
	private String createBy ;
}
