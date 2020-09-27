package com.dhc.base.schedule.ibatis;

import java.util.List;

import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

import com.dhc.base.schedule.ScheduleEvent;
import com.dhc.base.schedule.ScheduleEventManager;

public class ScheduleEventManagerImpl extends SqlMapClientDaoSupport implements ScheduleEventManager {

	public void addEvent(ScheduleEvent event) {

		getSqlMapClientTemplate().insert("schedule_addEvent", event);
	}

	public void updateEvent(ScheduleEvent event) {
		getSqlMapClientTemplate().update("schedule_updateEvent", event);
	}

	public void delEvent(String eventId) {
		getSqlMapClientTemplate().delete("schedule_delEvent", eventId);
	}

	@SuppressWarnings("unchecked")
	public List<ScheduleEvent> findAllEvent(String userName) {
		List<ScheduleEvent> allEvent;
		allEvent = getSqlMapClientTemplate().queryForList("schedule_findAllEvent", userName);
		return allEvent;
	}

	public ScheduleEvent findEventById(String eventId) {
		ScheduleEvent event = (ScheduleEvent) getSqlMapClientTemplate().queryForObject("schedule_findEventById",
				eventId);

		return event;
	}

}
