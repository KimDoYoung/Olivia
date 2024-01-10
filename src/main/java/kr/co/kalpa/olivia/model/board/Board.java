package kr.co.kalpa.olivia.model.board;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

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
	
	private Integer attachedFileCount;
	
	//첨부된 파일들
	private List<BoardFile> fileList;
	
	//관련 태그들
	private List<BoardTag> tagList;
	
	public String getTags() {
		if(tagList == null || tagList.size() == 0) return "";
		String tags = tagList.stream()
					.map(BoardTag::getName)
					.collect(Collectors.joining(", "));
		return tags;
	}
}
