/**
 * 
 */
package cn.rkylin.core;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.Date;
import java.util.HashMap;

import cn.rkylin.core.utils.StringUtil;

public class ApolloRet extends HashMap<String,Object> {
	
	public Object put(String key,Object value){
		return super.put(key.toUpperCase(), value);
	}	
	
	public Object get(String key){
		return super.get(key.toUpperCase());
	}
	
	public java.lang.String getString(String key){
		Object value = get(key);
		if (null == value) return "";		
		return  get(key).toString();
	}
    public Integer getInteger(String key){
    	String value = getString(key);
    	if("".equals(value))return null;
    	return Integer.parseInt(value);
    }
    public Boolean getBoolean(String key){
    	String value = getString(key);
    	if("".equals(value))return null;
    	return Boolean.parseBoolean(value);
    }
    public Byte getByte(String key){
    	String value = getString(key);
    	if("".equals(value))return null;
    	return Byte.parseByte(value);
    }
    public Long getLong(String key){
    	String value = getString(key);
    	if("".equals(value))return null;
    	return Long.parseLong(value);
    }
    public Double getDouble(String key){
    	String value = getString(key);
    	if("".equals(value))return null;
    	return Double.parseDouble(value);
    }
    
    public Date getDate(String key){   	
    	try {
			return StringUtil.StringToDate(getString(key), "yyyy-MM-dd HH:mm:ss");
		} catch (ParseException e) {			
			e.printStackTrace();
			return null;
		}   	
    }
    public BigDecimal getBigDecimal(String key){
    	String value = getString(key);
    	if("".equals(value))return null;
    	return new BigDecimal(value);
    }
    public Float getFloat(String key){
    	String value = getString(key);
    	if("".equals(value))return null;
    	return Float.parseFloat(value); 
    }
}
