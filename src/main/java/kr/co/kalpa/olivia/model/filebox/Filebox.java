package kr.co.kalpa.olivia.model.filebox;

import java.util.Date;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import lombok.Data;

/**
 * 파일을 보관하는 박스 즉 direcotry = folder 의 개념
 */
@Data
@JsonSerialize
@JsonDeserialize
public class Filebox {
	private Integer boxId;
	private Integer parentId;
	private String folderNm;
	private String note;
	private Date createOn;
	private String createBy;
}
