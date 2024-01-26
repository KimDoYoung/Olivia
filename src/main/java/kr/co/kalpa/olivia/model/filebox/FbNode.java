package kr.co.kalpa.olivia.model.filebox;

import java.util.ArrayList;
import java.util.Date;

import lombok.Data;

/**
 * 파일을 보관하는 박스 즉 direcotry = folder 의 개념
 */
@Data
public class FbNode {
	private Long nodeId;
	private String nodeType;
	private Long parentId;
	private String ownerId;
	private String nodeName;
	private String ownerAuth;
	private String groupAuth;
	private String guestAuth;
	private Date createOn;
	private String createBy;
	private Integer level;
	private ArrayList<Long> path;
}
