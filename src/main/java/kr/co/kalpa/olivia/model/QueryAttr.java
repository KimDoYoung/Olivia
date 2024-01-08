package kr.co.kalpa.olivia.model;

import java.util.HashMap;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class QueryAttr extends HashMap<String,Object>{

	private String searchText;
	private PageAttr pageAttr;
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void clear() {
		super.clear();
		this.searchText = null;
		this.pageAttr = null;
	}
}
