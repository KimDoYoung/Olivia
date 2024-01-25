package kr.co.kalpa.olivia.model.board;

import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import lombok.Data;

@Data
public class Board {
	private Long boardId;
	private String boardType;
	private String title;
	private String content;
	private Integer viewCount;
	private String startYmd;
	private String endYmd;
	private String status;
	private Date lastModifyOn;
	private int modifyCount;	
	private Date createOn;
	private String createBy;
	
	private Integer attachedFileCount;
	
	//첨부된 파일들
	private List<BoardFile> fileList;
	
	//관련 태그들
	private Set<Tags> tagSet;
		
	public String getTags() {
		if(tagSet == null || tagSet.size() == 0) return "";
		String tags = tagSet.stream()
					.map(Tags::getName)
					.collect(Collectors.joining(", "));
		return tags;
	}
}
