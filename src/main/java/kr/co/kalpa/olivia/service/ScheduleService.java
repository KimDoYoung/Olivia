package kr.co.kalpa.olivia.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import com.google.gson.Gson;

import kr.co.kalpa.olivia.model.openapi.holiday.ApiErrorResponse;
import kr.co.kalpa.olivia.model.openapi.holiday.ApiResponse;
import kr.co.kalpa.olivia.model.openapi.holiday.ApiItems;
import kr.co.kalpa.olivia.model.schedule.Schedule;
import kr.co.kalpa.olivia.model.schedule.SpecialDay;
import kr.co.kalpa.olivia.repository.ScheduleRepository;
import kr.co.kalpa.olivia.utils.CommonUtil;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class ScheduleService {

	@Value("${openapi.data.go.kr.holiday.key}")
	private String holidayApiKey;

	@Value("${openapi.data.go.kr.holiday.base.url}")
	private String holidayBaseUrl;
	
	
	private final ScheduleRepository repository;
	private final RestTemplate restTemplate;
	private final Gson gson;

	public ScheduleService(ScheduleRepository repository,RestTemplate restTempalte, Gson gson) {
		this.repository = repository;
		this.restTemplate = restTempalte;
		this.gson = gson;
	}

	public int insertSchedule(Schedule schedule) {
		return repository.insertSchedule(schedule);
		
	}

	public List<Schedule> selectSchedule() {
		return repository.selectSchedule();
	}

	public int insertSpecialDay(SpecialDay specialDay) {
		return repository.insertSpecialDay(specialDay);
	}

	public List<SpecialDay> selectAllSpecialDays() {
		return repository.selectAllSpecialDays();
	}

	public void specialDayFetchAll() throws Exception {
		String year = String.valueOf( LocalDate.now().getYear());
		String[] months = new String[] {"01","02","03","04","05","06","07","08","09","10","11","12"};
		for (String month : months) {
			fetchAndinsertHolidayToDb(year, month);
			log.debug("-----------------------------------------------------");
			log.debug("year {}, month: {} DONE", year,month);
			log.debug("-----------------------------------------------------");
		}
	}
	/**
	 * openapi를 이용해서 데이터를 가져와서 db에 넣는다.
	 * @throws Exception 
	 */
	@Transactional
	private void fetchAndinsertHolidayToDb(String year, String month) throws Exception {
		String key = holidayApiKey;      //"1ROBN6Q1t6iYO9fc2SbHVby0AruUb78/jd0Ruzvyv33tgJKV7WcOyZ+SmhnNPIYmrR0/ppqifPYDcrywywu9ZQ==";
        String baseUrl = holidayBaseUrl; // "http://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/getRestDeInfo";

        Map<String, String> queryParams = Map.of(
                "serviceKey", key,
                "solYear", year,
                "solMonth", month
        );
        String fullUrl = CommonUtil.buildUrlWithParams(baseUrl, queryParams);
        log.debug("open api full url :[{}]",fullUrl);
        
        URL url = new URL(fullUrl.toString());
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");
        
        log.debug("Response code: " + conn.getResponseCode());
        BufferedReader rd;
        if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        } else {
            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
        }
        StringBuilder xmlSb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) {
            xmlSb.append(line);
        }
        rd.close();
        conn.disconnect();
        
        String responseXml = xmlSb.toString();
        log.debug("responseXml:[{}]", responseXml);
        
        
        try {
            // 성공 응답 파싱
            JAXBContext jaxbContext = JAXBContext.newInstance(ApiResponse.class);
            Unmarshaller unmarshaller = jaxbContext.createUnmarshaller();
            StringReader reader = new StringReader(responseXml);
            ApiResponse apiResponse = (ApiResponse) unmarshaller.unmarshal(reader);

            ApiItems items = apiResponse.getBody().getItems();
            List<SpecialDay> list = null;
            if(items != null && items.getItem() != null) {
            	list = items.getItem();
            	for (SpecialDay specialDay : list) {
            		specialDay.setCreatedBy("System");
            		repository.insertSpecialDay(specialDay);
            	}        	
            }
        } catch (JAXBException e) {
            // 에러 응답 파싱 시도
            try {
                JAXBContext errorContext = JAXBContext.newInstance(ApiErrorResponse.class);
                Unmarshaller errorUnmarshaller = errorContext.createUnmarshaller();
                ApiErrorResponse errorResponse = (ApiErrorResponse) errorUnmarshaller.unmarshal(new StringReader(responseXml));
                
                log.error(errorResponse.getCmmMsgHeader().getErrMsg());

            } catch (JAXBException ex) {
                ex.printStackTrace();
            }
        }
	}
}



