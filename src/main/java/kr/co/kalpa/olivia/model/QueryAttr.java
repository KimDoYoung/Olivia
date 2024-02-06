package kr.co.kalpa.olivia.model;

import java.util.HashMap;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class QueryAttr extends HashMap<String,Object>{

//	private String searchText;
//	private Integer currentPageNumber = 1;
//	private Integer pageSize = 10;
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void clear() {
		super.clear();
	}
}
