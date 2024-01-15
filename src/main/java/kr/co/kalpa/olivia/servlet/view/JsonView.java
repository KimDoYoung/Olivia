package kr.co.kalpa.olivia.servlet.view;

import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.View;

import com.google.gson.Gson;

/**
 * JsonView : Model에 담긴 내용을 json string 으로 write
 * 
 */
public class JsonView implements View {

	@Override
	public void render(Map<String, ?> model, 
			HttpServletRequest request, 
			HttpServletResponse response)
			throws Exception {

		Gson gson = new Gson(); 
		String json = gson.toJson(model); 
		PrintWriter out;
		response.setContentType("application/json; charset=utf-8");
		out = response.getWriter();
		out.write(json);
		out.flush();
		out.close();		
	}

}
