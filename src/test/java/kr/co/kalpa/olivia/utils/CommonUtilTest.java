package kr.co.kalpa.olivia.utils;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.List;

import org.junit.jupiter.api.Test;

import lombok.extern.slf4j.Slf4j;

@Slf4j
class CommonUtilTest {

	@Test
	void test() {
		List<String> list = CommonUtil.toListFromString("111,222");
		for (String string : list) {
			log.debug(string);
		}
		assertEquals(list.size(), 2);
		list = CommonUtil.toListFromString("111|222");
		assertEquals(list.size(), 2);
		list = CommonUtil.toListFromString("111, 222 ");
		assertEquals(list.size(), 2);
		assertTrue(list.get(1).equals("222"));
		
	}

}
