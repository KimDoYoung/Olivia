package kr.co.kalpa.olivia.servlet.view;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;

import kr.co.kalpa.olivia.model.FileInfo;
import kr.co.kalpa.olivia.model.filebox.FbFile;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class DownloadView extends AbstractView {

	private static final String defaultContentType = "application/octet-stream; charset=UTF-8";
	private static final Map<String, String> contentTypeMap = new HashMap<>() ;
    static {
        contentTypeMap.put("jpg", "image/jpeg");
        contentTypeMap.put("jpeg", "image/jpeg");
        contentTypeMap.put("png", "image/png");
        contentTypeMap.put("gif", "image/gif");
        contentTypeMap.put("svg", "image/svg+xml");
        contentTypeMap.put("tiff", "image/tiff");
        contentTypeMap.put("tif", "image/tiff");
        contentTypeMap.put("bmp", "image/bmp");
        contentTypeMap.put("webp", "image/webp");
        contentTypeMap.put("ico", "image/x-icon");
        // Microsoft Excel 파일
        contentTypeMap.put("xls", "application/vnd.ms-excel");
        contentTypeMap.put("xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");

        // Microsoft Word 파일
        contentTypeMap.put("doc", "application/msword");
        contentTypeMap.put("docx", "application/vnd.openxmlformats-officedocument.wordprocessingml.document");

        // Microsoft PowerPoint 파일
        contentTypeMap.put("ppt", "application/vnd.ms-powerpoint");
        contentTypeMap.put("pptx", "application/vnd.openxmlformats-officedocument.presentationml.presentation");        
    }
	
	@Override
	protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		FileInfo fileInfo = (FileInfo) model.get("fileInfo");
		FbFile fbFile = fileInfo.getFbFile();
		String saveFileName = fbFile.getOrgName();
		String serverFullPath = fbFile.getPhyFolder() + "/" + fbFile.getPhyName();
		
	    try {
	    	String contentType = contentTypeWithExtension(fbFile.getExt());
	    	response.setContentType(contentType);
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

	
	private String contentTypeWithExtension(String ext) {
		if(ext == null) return defaultContentType;
		if(ext.startsWith(".")) {
			ext = ext.substring(1);
		}
		if( contentTypeMap.containsKey(ext) == false) {
			return defaultContentType;
		}
		return contentTypeMap.get(ext);
	}

}
