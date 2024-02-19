package kr.co.kalpa.olivia.service;

import java.io.BufferedReader;
import java.io.IOException;
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

import kr.co.kalpa.olivia.model.QueryAttr;
import kr.co.kalpa.olivia.model.openapi.holiday.ApiErrorResponse;
import kr.co.kalpa.olivia.model.openapi.holiday.Division24ApiItems;
import kr.co.kalpa.olivia.model.openapi.holiday.Division24ApiResponse;
import kr.co.kalpa.olivia.model.openapi.holiday.HolidayApiItems;
import kr.co.kalpa.olivia.model.openapi.holiday.HolidayApiResponse;
import kr.co.kalpa.olivia.model.schedule.LunarCalendar;
import kr.co.kalpa.olivia.model.schedule.Schedule;
import kr.co.kalpa.olivia.model.schedule.SpecialDay;
import kr.co.kalpa.olivia.repository.ScheduleRepository;
import kr.co.kalpa.olivia.utils.CommonUtil;
import kr.co.kalpa.olivia.utils.LunarCalc;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class ScheduleService {

	@Value("${openapi.data.go.kr.holiday.key}")
	private String holidayApiKey;

	@Value("${openapi.data.go.kr.holiday.base.url}")
	private String holidayBaseUrl;

	@Value("${openapi.data.go.kr.division24.base.url}")
	private String division24BaseUrl;
	
	
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

	/**
	 * 공휴일 정보 openApi로 가져와서 DB에 넣기
	 * 
	 * @param year
	 * @throws Exception
	 */
	public void specialDayFetchAll(String year) throws Exception {
		String[] months = new String[] {"01","02","03","04","05","06","07","08","09","10","11","12"};
		for (String month : months) {
			fetchAndInsertHolidayToDb(year, month);
			log.debug("-----------------------------------------------------");
			log.debug("year {}, month: {} DONE", year,month);
			log.debug("-----------------------------------------------------");
		}
	}
	/**
	 * 지정된 연도와 월에 해당하는 공휴일 정보를 OpenAPI에서 가져와서 데이터베이스에 저장한다.
	 * @param year 공휴일 정보를 조회할 연도
	 * @param month 공휴일 정보를 조회할 월
	 * @throws Exception 네트워크 오류나 파싱 실패 등으로 인한 예외 처리
	 */
	@Transactional
	private void fetchAndInsertHolidayToDb(String year, String month) throws Exception {
	    // OpenAPI로부터 공휴일 데이터를 XML 형태로 가져옴
	    String responseXml = fetchHolidayData(year, month);
	    try {
	        // 성공 응답을 파싱하여 ApiResponse 객체로 변환
	        HolidayApiResponse apiResponse = parseSuccessResponse(responseXml);
	        // 파싱된 데이터를 DB에 저장
	        insertSpecialDays(apiResponse);
	    } catch (JAXBException e) {
	        // 에러 응답 처리
	        handleErrorResponse(responseXml);
	    }
	}

	/**
	 * OpenAPI로부터 공휴일 데이터를 가져오는 메소드
	 * @param year 조회할 연도
	 * @param month 조회할 월
	 * @return API 응답으로 받은 XML 문자열
	 * @throws IOException HTTP 요청 실패시 발생
	 */
	private String fetchHolidayData(String year, String month) throws IOException {
	    // API 인증키와 기본 URL 설정
	    String key = holidayApiKey;
	    String baseUrl = holidayBaseUrl;
	    // 쿼리 파라미터 설정
	    Map<String, String> queryParams = Map.of(
	            "serviceKey", key,
	            "solYear", year,
	            "solMonth", month
	    );
	    // 전체 URL 생성
	    String fullUrl = CommonUtil.buildUrlWithParams(baseUrl, queryParams);
	    log.debug("Open API full URL: [{}]", fullUrl);

	    // HTTP 연결 설정 및 요청
	    URL url = new URL(fullUrl);
	    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	    conn.setRequestMethod("GET");
	    conn.setRequestProperty("Content-type", "application/json");
	    
	    log.debug("Response code: " + conn.getResponseCode());
	    // 응답 스트림 읽기
	    BufferedReader rd = new BufferedReader(new InputStreamReader(
	        conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300 ? conn.getInputStream() : conn.getErrorStream()));
	    StringBuilder xmlSb = new StringBuilder();
	    String line;
	    while ((line = rd.readLine()) != null) {
	        xmlSb.append(line);
	    }
	    rd.close();
	    conn.disconnect();

	    return xmlSb.toString();
	}

	/**
	 * API로부터 받은 성공 응답(XML)을 파싱하여 ApiResponse 객체로 변환
	 * @param responseXml API 응답 XML 문자열
	 * @return ApiResponse 객체
	 * @throws JAXBException XML 파싱 실패 시 발생
	 */
	private HolidayApiResponse parseSuccessResponse(String responseXml) throws JAXBException {
	    JAXBContext jaxbContext = JAXBContext.newInstance(HolidayApiResponse.class);
	    Unmarshaller unmarshaller = jaxbContext.createUnmarshaller();
	    return (HolidayApiResponse) unmarshaller.unmarshal(new StringReader(responseXml));
	}

	/**
	 * ApiResponse 객체의 내용을 바탕으로 DB에 공휴일 정보를 저장
	 * @param apiResponse 공휴일 정보가 담긴 ApiResponse 객체
	 */
	private void insertSpecialDays(HolidayApiResponse apiResponse) {
	    HolidayApiItems items = apiResponse.getBody().getItems();
	    if (items != null && items.getItem() != null) {
	        for (SpecialDay specialDay : items.getItem()) {
	            specialDay.setCreatedBy("System");
	            repository.insertSpecialDay(specialDay);
	        }
	    }
	}

	/**
	 * API로부터 받은 에러 응답(XML)을 처리
	 * @param responseXml API 응답 XML 문자열
	 */
	private void handleErrorResponse(String responseXml) {
	    try {
	        JAXBContext errorContext = JAXBContext.newInstance(ApiErrorResponse.class);
	        Unmarshaller errorUnmarshaller = errorContext.createUnmarshaller();
	        ApiErrorResponse errorResponse = (ApiErrorResponse) errorUnmarshaller.unmarshal(new StringReader(responseXml));
	        log.error(errorResponse.getCmmMsgHeader().getErrMsg());
	    } catch (JAXBException e) {
	        log.error("Error parsing error response", e);
	    }
	}

	/**
	 * year에 해당하는 24절기 정보를 openapi를 통해서 가져와서 테이블에 넣는다.
	 * special_day
	 * @param year
	 * @throws IOException 
	 */
	public void division24FetchAll(String year) throws IOException {
		String[] months = new String[] {"01","02","03","04","05","06","07","08","09","10","11","12"};
		for (String month : months) {
			fetchAndInsertDivision24ToDb(year, month);
			log.debug("-----------------------------------------------------");
			log.debug("year {}, month: {} DONE", year,month);
			log.debug("-----------------------------------------------------");
		}
		
	}
	/**
	 * 지정된 연도와 월에 해당하는 24절기 정보를 OpenAPI에서 가져와서 데이터베이스에 저장한다.
	 * @param year 조회할 연도
	 * @param month 조회할 월
	 * @throws IOException 
	 * @throws Exception 네트워크 오류나 파싱 실패 등으로 인한 예외 처리
	 */
	@Transactional
	private void fetchAndInsertDivision24ToDb(String year, String month) throws IOException {
	    // OpenAPI로부터 공휴일 데이터를 XML 형태로 가져옴
	    String responseXml = fetch24DivisionData(year, month);
	    try {
	        // 성공 응답을 파싱하여 ApiResponse 객체로 변환
	        Division24ApiResponse apiResponse = parseDivison24SuccessResponse(responseXml);
	        // 파싱된 데이터를 DB에 저장
	        insertDivision24(apiResponse);
	    } catch (JAXBException e) {
	        // 에러 응답 처리
	        handleErrorResponse(responseXml);
	    }
		
	}

	private void insertDivision24(Division24ApiResponse apiResponse) {
	    Division24ApiItems items = apiResponse.getBody().getItems();
	    if (items != null && items.getItem() != null) {
	        for (SpecialDay specialDay : items.getItem()) {
	            specialDay.setCreatedBy("System");
	            repository.insertSpecialDay(specialDay);
	        }
	    }
		
	}

	private Division24ApiResponse parseDivison24SuccessResponse(String responseXml) throws JAXBException {
	    JAXBContext jaxbContext = JAXBContext.newInstance(Division24ApiResponse.class);
	    Unmarshaller unmarshaller = jaxbContext.createUnmarshaller();
	    return (Division24ApiResponse) unmarshaller.unmarshal(new StringReader(responseXml));
	}

	private String fetch24DivisionData(String year, String month) throws IOException {
		 // API 인증키와 기본 URL 설정
	    String key = holidayApiKey;
	    String baseUrl = division24BaseUrl;
	    // 쿼리 파라미터 설정
	    Map<String, String> queryParams = Map.of(
	            "serviceKey", key,
	            "solYear", year,
	            "solMonth", month,
	            "kst", "0120",
	            "sunLongitude","285",
	            "pageNo","1",
	            "totalCount", "210114"
	    );
	    // 전체 URL 생성
	    String fullUrl = CommonUtil.buildUrlWithParams(baseUrl, queryParams);
	    log.debug("Open API full URL: [{}]", fullUrl);

	    // HTTP 연결 설정 및 요청
	    URL url = new URL(fullUrl);
	    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	    conn.setRequestMethod("GET");
	    conn.setRequestProperty("Content-type", "application/json");
	    
	    log.debug("Response code: " + conn.getResponseCode());
	    // 응답 스트림 읽기
	    BufferedReader rd = new BufferedReader(new InputStreamReader(
	        conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300 ? conn.getInputStream() : conn.getErrorStream()));
	    StringBuilder xmlSb = new StringBuilder();
	    String line;
	    while ((line = rd.readLine()) != null) {
	        xmlSb.append(line);
	    }
	    rd.close();
	    conn.disconnect();

	    return xmlSb.toString();
	}

	/**
	 * 해당 year의 1.1 ~12.31까지 음력을 구해서 lunar_calendar를 추가한다.
	 * 
	 * @param year
	 */
	public void lunarCalendarFill(int year) {
        LocalDate startDate = LocalDate.of(year, 1, 1);
        LocalDate endDate = LocalDate.of(year, 12, 31);

        LunarCalendar lunarCalender = new LunarCalendar();
        for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {
            int month = date.getMonthValue();
            int day = date.getDayOfMonth();
       
            String solar = String.format("%d%02d%02d", year,month, day);
            String lunar = LunarCalc.getYmd(year, month, day);
            
            lunarCalender.setSolarYmd(solar);
            lunarCalender.setLunarYmd(lunar);
            
            repository.insertLunarCalendar(lunarCalender);
        }
	}

	/**
	 * 달력에 표시한 Holiday, 24절기, schedule정보를 가져온다.
	 * 
	 * @param qa
	 * @return
	 */
	public List<SpecialDay> calendarSchedules(QueryAttr qa) {
		return repository.calendarSchedules(qa);
	}

	
	
}



