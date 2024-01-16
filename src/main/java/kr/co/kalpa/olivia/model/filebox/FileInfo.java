package kr.co.kalpa.olivia.model.filebox;

import java.util.Date;

import lombok.Data;

/**
 * 파일정보
 */
@Data
public class FileInfo {
	private Integer fileInfoId ;
	private Integer boxId ;
	private String phyFolder ;
	private String phyName ;
	private String orgName ;
	private String mimeType ;
	private Long fileSize ;
	private String ext ;
	private String note ;
	private Integer width ;
	private Integer height ;
	private String status;
	private Date createOn ;
	private String createBy ;
}
