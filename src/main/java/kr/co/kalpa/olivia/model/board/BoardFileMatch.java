package kr.co.kalpa.olivia.model.board;

import lombok.Data;

@Data
public class BoardFileMatch {

	private Integer boardId;
	private Integer boardFileId;
	private Integer seq;
	private String deletedYn;
}
