package kr.co.kalpa.olivia.model.board;

import java.util.Date;

import lombok.Data;

@Data
public class BoardFile {
	private Long boardFileId;
	private Long boardId;
	private Integer seq;
	private String phyFolder;
	private String phyName;
	private String orgName;
	private String mimeType;
	private Long fileSize;
	private String ext;
	private String note;
	private Date createOn;
	private String createBy;
}
