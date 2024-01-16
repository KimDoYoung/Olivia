package kr.co.kalpa.olivia.model.filebox;

import java.util.ArrayList;
import java.util.Date;

import lombok.Data;

/**
 * 파일을 보관하는 박스 즉 direcotry = folder 의 개념
 */
@Data
public class Filebox {
	private Integer boxId;
	private Integer parentId;
	private String folderNm;
	private String note;
	private Date createOn;
	private String createBy;
	private Integer level;
	private ArrayList<Integer> path;
}
