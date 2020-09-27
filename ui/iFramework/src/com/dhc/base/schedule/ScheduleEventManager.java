package com.dhc.base.schedule;

import java.util.List;

public interface ScheduleEventManager {

	// public void addEventOrUpdateEvent(Calendar event);

	public void addEvent(ScheduleEvent event);

	public void updateEvent(ScheduleEvent event);

	public void delEvent(String eventId);

	public ScheduleEvent findEventById(String eventId);

	public List<ScheduleEvent> findAllEvent(String userName);
}
