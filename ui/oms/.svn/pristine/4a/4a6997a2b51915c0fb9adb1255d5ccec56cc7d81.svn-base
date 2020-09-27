/**
 * 
 */
package cn.rkylin.apollo.enums;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 区域状态
 * @author Administrator
 *
 */
public enum AreaStatusEnum {
	INVALID(0,"无效"),
	VALID(1,"有效"),
	DELETE(2,"删除"),
	;
	AreaStatusEnum(Integer c,String s){
		this.c = c;
		this.s = s;
	}
	private final Integer c;
	private final String s;
	public Integer getC() {
		return c;
	}
	public String getS() {
		return s;
	}		
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static List<Map> getJSONArray(Map reqMap){
    	List<Map> json = new ArrayList<Map>();
    	Map obj = null;
		for (AreaStatusEnum e : AreaStatusEnum.values()) {
			if (DELETE.equals(e)) continue;
			obj = new HashMap();
			obj.put("TEXT", e.getS());
			obj.put("VALUE", e.getC());
			json.add(obj);
		}
		return json;
    }
}
