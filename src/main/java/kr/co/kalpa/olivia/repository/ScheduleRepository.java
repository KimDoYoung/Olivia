package kr.co.kalpa.olivia.repository;

import java.util.List;

import kr.co.kalpa.olivia.model.schedule.LunarCalendar;
import kr.co.kalpa.olivia.model.schedule.Schedule;
import kr.co.kalpa.olivia.model.schedule.SpecialDay;

public interface ScheduleRepository {

	public int insertSchedule(Schedule schedule);

	public List<Schedule> selectSchedule();

	public int insertSpecialDay(SpecialDay specialDay);

	public List<SpecialDay> selectAllSpecialDays();

	public void insertLunarCalendar(LunarCalendar lunarCalender);
}
