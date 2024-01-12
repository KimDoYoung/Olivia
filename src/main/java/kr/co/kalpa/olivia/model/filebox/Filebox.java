package kr.co.kalpa.olivia.model.filebox;

import java.util.Date;

import lombok.Data;

@Data
public class Filebox {
	private Integer boxId;
	private Integer parentId;
	private String folderNm;
	private String note;
	private Date createOn;
	private String createBy;
}
