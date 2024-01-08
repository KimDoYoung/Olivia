package kr.co.kalpa.olivia.model.board;

import java.util.Date;

import lombok.Data;

@Data
public class Board {
	private Integer boardId;
	private String boardType;
	private String title;
	private String content;
	private Integer viewCount;
	private String startYmd;
	private String endYmd;
	private String status;
	private Date createOn;
	private String createBy;
}
