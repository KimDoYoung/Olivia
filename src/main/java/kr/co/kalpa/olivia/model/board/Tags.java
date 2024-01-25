package kr.co.kalpa.olivia.model.board;

import java.util.Date;

import lombok.Data;

@Data
public class Tags {
	private Long tagId;
	private String name;
	private Integer useCount;
	private Date lastUseOn;
}
