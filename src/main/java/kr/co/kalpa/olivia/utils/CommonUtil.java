package kr.co.kalpa.olivia.utils;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

public class CommonUtil {

	public static String[] getTodayAsArray() {
		// 현재 날짜 가져오기
		LocalDate today = LocalDate.now();

		// 오늘의 년도 구하기
		int year = today.getYear();

		// 오늘의 월 구하기
		int month = today.getMonthValue();

		int day = today.getDayOfMonth();

		String year1 = String.valueOf(year);
		String month1 = String.format("%02d", month);
		String day1 = String.format("%02d", day);
		return new String[] { year1, month1, day1 };
	}

	public static String createFolder(String targetFolder) {
		Path baseDir = Paths.get(targetFolder);
		try {
			// 디렉토리 생성
			Files.createDirectories(baseDir);
			return targetFolder;
		} catch (IOException e) {
			return null;
		}

	}

	public static String getUuid() {
		// UUID 생성
		UUID uuid = UUID.randomUUID();
		String uuidString = uuid.toString().replace("-", "");
		return uuidString;
	}

	public static String getExtension(String fileName) {
		String extension = fileName.substring(fileName.lastIndexOf('.'));

		return extension;

	}

	/**
	 * 문자열을 분리해서 List로 만들어서 리턴한다.
	 * 
	 * @param tags : string
	 * @return
	 */
	public static List<String> toListFromString(String tags) {
		List<String> list = new ArrayList<>();
		if (tags == null)
			return list;
		String[] tagArray = tags.trim().split("[,|]\\s*");
		for (String s : tagArray) {
			list.add(s);
		}
		return list;

	}

	public static String today(String format) {
		// 현재 날짜 가져오기
		LocalDate currentDate = LocalDate.now();

		// 날짜를 원하는 형식으로 포맷
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern(format);
		return currentDate.format(formatter);
	}

	public static String today() {
		return today("yyyy-MM-dd");
	}

	public static String displayYmd(String s) {
		if (s == null)
			return s;
		String y = s.replaceAll("\\D", "");
		if (y.length() == 8) {
			return y.substring(0, 4) + "-" + y.substring(4, 6) + "-" + y.substring(6);
		}
		return s;
	}

	/**
	 * openApi의 url에 queryParams를 붙여서 만들어 준다.
	 * 
	 * @param baseUrl
	 * @param queryParams
	 * @return
	 */
	public static String buildUrlWithParams(String baseUrl, Map<String, String> queryParams) {
		String encodedParams = queryParams.entrySet().stream()
				.map(entry -> encodeParam(entry.getKey(), entry.getValue())).collect(Collectors.joining("&"));

		return baseUrl + "?" + encodedParams;
	}

	private static String encodeParam(String key, String value) {
		try {
			return URLEncoder.encode(key, StandardCharsets.UTF_8.toString()) + "="
					+ URLEncoder.encode(value, StandardCharsets.UTF_8.toString());
		} catch (Exception e) {
			// In real-world scenarios, consider more robust error handling
			throw new RuntimeException("Failed to encode parameters", e);
		}
	}

}
