package kr.co.kalpa.olivia.utils;

import java.time.LocalDate;

import org.junit.jupiter.api.Test;

class LunarCalcTest {

	@Test
	void test() {
		int[] ymd = LunarCalc.get(2024, 2, 16);
		System.out.println(String.format("%d %d %d", ymd[0], ymd[1], ymd[2]));
		
        LocalDate startDate = LocalDate.of(2024, 1, 1);
        LocalDate endDate = LocalDate.of(2024, 12, 31);

        for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {
            int year = date.getYear();
            int month = date.getMonthValue();
            int day = date.getDayOfMonth();
            String lunar = LunarCalc.getYmd(year, month, day);
            System.out.println(String.format("date %s -> %s",date.toString(), lunar));
        }
        
	}

}
