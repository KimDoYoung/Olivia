package kr.co.kalpa.olivia.model.board;

import java.util.Date;
import java.util.List;

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
	
	//첨부된 파일들
	private List<BoardFile> fileList;
	
	//관련 태그들
	private List<BoardTag> tagList;

}
