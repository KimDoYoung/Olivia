package kr.co.kalpa.olivia.utils.crawling;

import java.io.IOException;
import java.net.MalformedURLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import kr.co.kalpa.olivia.model.IpoData;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class IpoCrawler {

	private int pageCount = 5;
	private String startUrl;
	private DetailPageLinks detailPageLinks;
	
	public IpoCrawler(String baseUrl) throws MalformedURLException {
		this.startUrl = baseUrl;
		this.detailPageLinks = new DetailPageLinks(startUrl);
	}
	
	
	/**
     * crawling ID : yyyyMMddHHmmddss
     * @return
     */
    private String newTrackId() {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
        Date now = new Date();
        String formattedDate = dateFormat.format(now);
        return formattedDate;
	}
    
    private List<IpoData> crawl() throws IOException {
    	List<String> list = gatherAllDetailPageAnchor();
    	detailPageLinks.add(list);

    	List<IpoData> dataList = new ArrayList<>();
    	
    	for (String pageUrl : detailPageLinks.getLinks()) {
    		Document doc = Jsoup.connect(pageUrl).get();
    		IpoDetailPageParser parser = new IpoDetailPageParser(doc);
			IpoData ipoData = parser.parse();
			dataList.add(ipoData);
		}
    	return dataList;
    }


	/**
     * 수요예측 일정 리스트를 정해진 페이지 갯수만큼 가져와서 링크를 뽑아낸다.
     * @throws IOException
     */
	private List<String> gatherAllDetailPageAnchor() throws IOException {
		
		List<String> list = new ArrayList<>();
		
        for(int i=1; i <= pageCount; i++) {
        	String url = startUrl + "&page=" + i;
        	Document doc = Jsoup.connect(url).get();
        	Element table = doc.select("table[summary=수요예측일정]").first();

             if (table != null) {
                 // 테이블 내의 anchor 요소들을 추출합니다.
                 Elements links = table.select("a");

                 for (Element link : links) {
                     String href = link.attr("href");
//                     String text = link.text();
                     list.add(href);
                 }
             } else {
                 log.warn("해당 summary 속성을 가진 테이블을 찾을 수 없습니다.");
             }        	
        }
        return list;
	}


	public List<IpoData> run() throws IOException {
    	List<IpoData> ipoDataList = crawl();
    	
    	String trackId = newTrackId();
    	for (IpoData ipoData : ipoDataList) {
    		ipoData.setTrackId(trackId);
		}
    	return ipoDataList;
	}
}
