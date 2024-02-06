package kr.co.kalpa.olivia.servlet.view;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

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
		
//		List<FbFile> list = (List<FbFile>) model.get("list");
//		FileInfo fileInfo = (FileInfo) model.get("fileInfo");
//		if(list != null) {
//			downloadMultiFiles(request,response, list);
//		}else if(fileInfo != null){
//			downloadFile(request,response, fileInfo );
//		}
		List<FileInfo> list = (List<FileInfo>) model.get("list");
		if(list == null) return;
		if( list.size() == 1) {
			FileInfo fileInfo = list.get(0);
			downloadFile(request, response, fileInfo );
		}else {
			downloadMultiFiles(request, response, list);
		}
	}

	
	private void downloadMultiFiles(HttpServletRequest request, HttpServletResponse response,List<FileInfo> list) throws IOException {
		// zip파일생성
        File zipFile = File.createTempFile("download", ".zip");

        try (FileOutputStream fos = new FileOutputStream(zipFile);
             ZipOutputStream zipOut = new ZipOutputStream(fos)) {
            
        	for (FileInfo fileInfo : list) {
        		FbFile fbFile = fileInfo.getFbFile();
        		String srcFile = fbFile.getPhyFolder() + "/" + fbFile.getPhyName();
                FileInputStream fis = new FileInputStream(srcFile);
                ZipEntry zipEntry = new ZipEntry(fbFile.getOrgName());
                zipOut.putNextEntry(zipEntry);

                byte[] bytes = new byte[1024*4];
                int length;
                while ((length = fis.read(bytes)) >= 0) {
                    zipOut.write(bytes, 0, length);
                }
                zipOut.closeEntry();
                fis.close();
            }
        }
        //사용자가 다운로드 받을 파일명
        String zipFileName = downloadFileName("download");
        
        // Set response headers
        response.setContentType("application/zip");
        response.setHeader("Content-Disposition", "attachment; filename="+zipFileName);

        // Copy the zip file to the response output stream
        FileInputStream zipInputStream = new FileInputStream(zipFile);
        FileCopyUtils.copy(zipInputStream, response.getOutputStream());
        zipInputStream.close();

        // Delete the temporary zip file
        zipFile.delete();
		
	}


	private String downloadFileName(String prefix) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss");
        String formattedDate = sdf.format(new Date());
        return prefix +"_" +formattedDate + ".zip";
	}


	private void downloadFile(HttpServletRequest request,HttpServletResponse response, FileInfo fileInfo) {
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
