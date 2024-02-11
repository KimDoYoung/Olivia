package kr.co.kalpa.olivia.controller;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.util.StreamUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.kalpa.olivia.model.JsonData;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/utility")
public class UtilityController{

	
	@GetMapping("")
	public String main() {
		log.debug("********************************************");
		log.debug("utilities");
		log.debug("********************************************");
		return "utility/util";
	}

    @GetMapping("/handlebar/template/{templateName}")
    @ResponseBody
    public String getTemplate(@PathVariable("templateName") String templateName) throws IOException {
        // handlebar 템플릿 읽어서 String으로.
        InputStream inputStream = getClass().getResourceAsStream("/handlebar-templates/" + templateName + ".html");
        String templateContent = StreamUtils.copyToString(inputStream, StandardCharsets.UTF_8);

        JsonData jsonData = new JsonData();
        jsonData.put("template", templateContent);
		return jsonData.toJson();
    }	
}
