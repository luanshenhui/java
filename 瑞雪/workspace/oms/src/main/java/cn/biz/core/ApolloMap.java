/**
 * 
 */
package cn.biz.core;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.Date;
import java.util.HashMap;

import cn.rkylin.core.utils.StringUtil;

public class ApolloMap<String,Object> extends HashMap<String,Object> {	
	
	public java.lang.String getString(String key){
		Object value = get(key);
		if (null == value) return "";		
		return  get(key).toString();
	}
    public Integer getInteger(String key){
    	return Integer.parseInt(getString(key));
    }
    public Boolean getBoolean(String key){
    	return Boolean.parseBoolean(getString(key));
    }
    public Byte getByte(String key){
    	return Byte.parseByte(getString(key));
    }
    public Long getLong(String key){
    	return Long.parseLong(getString(key));
    }
    public Double getDouble(String key){
    	return Double.parseDouble(getString(key));
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
    	return new BigDecimal(getString(key));
    }
    public Float getFloat(String key){
    	return Float.parseFloat(getString(key)); 
    }
}
