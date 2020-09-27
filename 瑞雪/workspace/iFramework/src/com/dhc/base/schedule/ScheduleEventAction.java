package com.dhc.base.schedule;

import java.text.SimpleDateFormat;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.actions.DispatchAction;

import com.dhc.base.security.SecurityUser;
import com.dhc.base.security.SecurityUserHoder;

public class ScheduleEventAction extends DispatchAction {

	private ScheduleEventManager eventManager;

	public ActionForward addOrUpdateEvent(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ScheduleEventForm eventForm = (ScheduleEventForm) form;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		ScheduleEvent event = new ScheduleEvent();
		event.setEventId(eventForm.getEventId());
		event.setText(new String(eventForm.getText().getBytes("ISO-8859-1"), "UTF-8"));
		if (null == eventForm.getDetails() || "".equals(eventForm.getDetails())) {
			event.setDetails(new String(eventForm.getText().getBytes("ISO-8859-1"), "UTF-8"));
		}

		String startDate = eventForm.getStartDate();
		if (null != startDate || !"".equals(startDate)) {
			event.setStartDate(sdf.parse(startDate));
		}

		String endDate = eventForm.getEndDate();
		if (null != endDate || !"".equals(endDate)) {
			event.setEndDate(sdf.parse(endDate));
		}

		SecurityUser securityUser = SecurityUserHoder.getCurrentUser();
		String username = securityUser.getUsername();

		if (null != username || !"".equals(username)) {
			event.setUsername(username);
		}

		// BeanUtils.copyProperties(event, form);

		ScheduleEvent cal = eventManager.findEventById(eventForm.getEventId());
		if (cal == null) {
			eventManager.addEvent(event);
		} else {
			eventManager.updateEvent(event);
		}

		return null;
	}

	public ActionForward delEvent(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ScheduleEventForm eventForm = (ScheduleEventForm) form;
		eventManager.delEvent(eventForm.getEventId());
		return null;
	}

	public ActionForward findEventById(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ScheduleEventForm eventForm = (ScheduleEventForm) form;
		eventManager.findEventById(eventForm.getEventId());
		return null;
	}

	/**
	 * strb字符串的格式跟events.xml每个event格式一样（请参考events.xml）
	 */
	public ActionForward findAllEvent(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		response.setContentType("text/xml;charset=UTF-8");

		SecurityUser securityUser = SecurityUserHoder.getCurrentUser();
		String username = securityUser.getUsername();
		List eventList = (List) eventManager.findAllEvent(username);

		StringBuffer strb = new StringBuffer();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		strb.append("<data>");
		for (Iterator iter = eventList.iterator(); iter.hasNext();) {
			ScheduleEvent event = (ScheduleEvent) iter.next();
			strb.append("<event id=\"" + event.getEventId() + "\">");
			strb.append("<start_date><![CDATA[" + sdf.format(event.getStartDate()) + "]]></start_date>");
			strb.append("<end_date><![CDATA[" + sdf.format(event.getEndDate()) + "]]></end_date>");
			strb.append("<text><![CDATA[" + event.getText() + "]]></text>");
			strb.append("<details><![CDATA[" + event.getDetails() + "]]></details>");
			strb.append("</event>");
		}
		strb.append("</data>");
		response.getWriter().print(strb.toString());

		return null;
	}

	public void setScheduleEventManager(ScheduleEventManager eventManager) {
		this.eventManager = eventManager;
	}
}
