package chinsoft.tempService;

public class MapUtil {
	private Object key_obj;
	private Object value_obj;
	
	private Object temp_obj;
	public MapUtil() {

	}
	
	public MapUtil(Object key_obj,Object value_obj) {
		this.key_obj = key_obj;
		this.value_obj = value_obj;
	}

	public Object getKey_obj() {
		return key_obj;
	}
	public void setKey_obj(Object key_obj) {
		this.key_obj = key_obj;
	}
	public Object getValue_obj() {
		return value_obj;
	}
	public void setValue_obj(Object value_obj) {
		this.value_obj = value_obj;
	}

	public Object getTemp_obj() {
		return temp_obj;
	}

	public void setTemp_obj(Object temp_obj) {
		this.temp_obj = temp_obj;
	}
	
	
}
