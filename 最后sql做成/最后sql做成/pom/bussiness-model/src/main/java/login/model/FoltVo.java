package login.model;

import java.util.List;
import java.util.Map;

public class FoltVo{
	private String time;
	private String count;
	private String role_type;
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	public String getCount() {
		return count;
	}
	public void setCount(String count) {
		this.count = count;
	}
	
	private String role;
	private Map MonthData;
	private String color;
	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}
	public Map getMonthData() {
		return MonthData;
	}
	public void setMonthData(Map monthData) {
		
		MonthData = monthData;
	}
	public String getColor() {
		return color;
	}
	public void setColor(String color) {
		this.color = color;
	}
	public String getRole_type() {
		return role_type;
	}
	public void setRole_type(String role_type) {
		this.role_type = role_type;
	}
	
	private String  name;
	private List<Integer>  data;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public List<Integer> getData() {
		return data;
	}
	public void setData(List<Integer> data) {
		this.data = data;
	}
	
	private  String beginTime;
	private String  overTime;
	public String getBeginTime() {
		return beginTime;
	}
	public void setBeginTime(String beginTime) {
		this.beginTime = beginTime;
	}
	public String getOverTime() { 
		return overTime;
	}
	public void setOverTime(String overTime) {
		this.overTime = overTime;
	}
	private String foltColor;
	public String getFoltColor() {
		return foltColor;
	}
	public void setFoltColor(String foltColor) {
		this.foltColor = foltColor;
	}
	
	private String personId;
	public String getPersonId() {
		return personId;
	}
	public void setPersonId(String personId) {
		this.personId = personId;
	}
	
	

}
