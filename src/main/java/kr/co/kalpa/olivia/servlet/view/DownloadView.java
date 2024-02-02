package kr.co.kalpa.olivia.servlet.view;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;

import kr.co.kalpa.olivia.model.FileInfo;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class DownloadView extends AbstractView {

	@Override
	protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		FileInfo fileInfo = (FileInfo) model.get("fileInfo");
		String saveFileName = fileInfo.getFbFile().getOrgName();
		String serverFullPath = fileInfo.getFbFile().getPhyFolder() + "/" + fileInfo.getFbFile().getPhyName();
	    try {
	    	response.setContentType("application/octet-stream; charset=UTF-8");
			response.setHeader("Content-Disposition", "attachment; filename=\""+ URLEncoder.encode(saveFileName, "UTF-8") + "\"");
			response.setHeader("Content-Transfer-Encoding", "binary");
			
			File file = new File(serverFullPath);
			response.setHeader("Content-Length", String.valueOf(file.length()));
			
			FileCopyUtils.copy(new FileInputStream(file), response.getOutputStream());
			response.flushBuffer();
			
	    } catch (IOException ex) {
	    	
	      log.error("Error writing file to output stream. Filename was '{}', {}", serverFullPath, ex);
	      throw new RuntimeException("IOError writing file to output stream");
	      
	    }			

	}

}
