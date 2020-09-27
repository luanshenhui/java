package cn.com.cgbchina.user.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.google.common.base.MoreObjects;
import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by 11141021040453 on 16-4-8.
 */
public class Activity implements Serializable {

	private static final long serialVersionUID = 8501679919218756361L;
	private Long id;
	private String activityName;
	private String type;
	private String user;
	private String beginTime;
	private String endTime;
	private String state;

	public static long getSerialVersionUID() {
		return serialVersionUID;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getActivityName() {

		return activityName;
	}

	public void setActivityName(String activityName) {
		this.activityName = activityName;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getBeginTime() {
		return beginTime;
	}

	public void setBeginTime(String beginTime) {
		this.beginTime = beginTime;
	}

	public String getUser() {
		return user;
	}

	public void setUser(String user) {
		this.user = user;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		Activity activity = (Activity) o;

		if (activityName != null ? !activityName.equals(activity.activityName) : activity.activityName != null)
			return false;
		if (beginTime != null ? !beginTime.equals(activity.beginTime) : activity.beginTime != null)
			return false;
		if (endTime != null ? !endTime.equals(activity.endTime) : activity.endTime != null)
			return false;
		if (id != null ? !id.equals(activity.id) : activity.id != null)
			return false;
		if (state != null ? !state.equals(activity.state) : activity.state != null)
			return false;
		if (type != null ? !type.equals(activity.type) : activity.type != null)
			return false;
		if (user != null ? !user.equals(activity.user) : activity.user != null)
			return false;

		return true;
	}

	@Override
	public int hashCode() {
		int result = id != null ? id.hashCode() : 0;
		result = 31 * result + (activityName != null ? activityName.hashCode() : 0);
		result = 31 * result + (type != null ? type.hashCode() : 0);
		result = 31 * result + (user != null ? user.hashCode() : 0);
		result = 31 * result + (beginTime != null ? beginTime.hashCode() : 0);
		result = 31 * result + (endTime != null ? endTime.hashCode() : 0);
		result = 31 * result + (state != null ? state.hashCode() : 0);
		return result;
	}

	@Override
	public String toString() {
		return "Activity{" + "id=" + id + ", activityName='" + activityName + '\'' + ", type='" + type + '\''
				+ ", user='" + user + '\'' + ", beginTime='" + beginTime + '\'' + ", endTime='" + endTime + '\''
				+ ", state='" + state + '\'' + '}';
	}
}
