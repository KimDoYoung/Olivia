package kr.co.kalpa.olivia.model;

import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;

import lombok.Getter;
import lombok.Setter;

/**
 * 
 * Json데이터를 client에 보내기 위한 객체
 * 
 * @author Kim Do Young
 *
 */
@Getter
@Setter
public class JsonData {
	private Map<String, Object> data;
	public JsonData() {
		data  = new HashMap<String, Object>();
	}
	public void put(String name, Object o) {
		data.put(name, o);
	}
	public void clear() {
		data.clear();
	}
	public String toJson() {
//		for( Map.Entry<String, Object> entry : data.entrySet() ){
//			String key = entry.getKey();
//			Object o = entry.getValue();
//		}
		Gson gson = new Gson(); 
		String json = gson.toJson(data); 
		return json;
	}
}
