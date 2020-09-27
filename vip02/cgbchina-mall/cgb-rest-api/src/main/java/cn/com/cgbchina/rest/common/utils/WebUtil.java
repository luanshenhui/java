package cn.com.cgbchina.rest.common.utils;

import java.beans.IntrospectionException;
import java.beans.PropertyDescriptor;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.InetAddress;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.net.UnknownHostException;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class WebUtil {
	public static String getlocalIP() {
		try {
			return InetAddress.getLocalHost().getHostAddress();
		} catch (UnknownHostException e) {
			throw new RuntimeException("获取本地失败IP" + e);
		}
	}
	
	public static <T> void converBeanToUrl(T model){
		 try {
			 converBeanCore(model,1);
			} catch (SecurityException | IllegalAccessException
					| IllegalArgumentException | InvocationTargetException
					| UnsupportedEncodingException | IntrospectionException e) {
				log.error("[urlencode失败]"+e.getMessage(),e);
			}
	}
	public static <T> void converUrlToBean(T model){
		 try {
			 converBeanCore(model,0);
			} catch (SecurityException | IllegalAccessException
					| IllegalArgumentException | InvocationTargetException
					| UnsupportedEncodingException | IntrospectionException e) {
				log.error("[urlencode失败]"+e.getMessage(),e);
			}
	}
	private static <T> void converBeanCore(T model,int type) throws IntrospectionException, IllegalAccessException, IllegalArgumentException, InvocationTargetException, UnsupportedEncodingException{
		Field[] fields = model.getClass().getDeclaredFields();
		 for(Field field:fields){
			 PropertyDescriptor pd=new PropertyDescriptor(field.getName(), model.getClass());
			 Method read = pd.getReadMethod();
			 if(read!=null){
				 Object obj = read.invoke(model);
				 String content=null;
				 if(obj!=null){
					 if(type==1){
						 content=URLEncoder.encode(String.valueOf(obj),"UTF-8");
					 }else{
						 content=URLDecoder.decode(String.valueOf(obj),"UTF-8");
					 }
					 Method write = pd.getWriteMethod();
					 write.invoke(model, content);
				 }
			 }
		 }
	}
}
