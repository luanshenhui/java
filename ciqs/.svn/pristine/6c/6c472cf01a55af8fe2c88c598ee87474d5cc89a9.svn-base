package com.dpn.ciqqlc.common.util;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.util.JavaIdentifierTransformer;


public class BeanUtils {
    
    /**
     * 忽略字段的首字母大小写，将json字符串转成javabean
     * @param jsonString
     * @param beanCalss
     * @return
     */
    public static Object jsonToBeanIgnoreCase (String jsonString, Class<?> beanCalss){
    	JSONObject jsonObj1 = JSONObject.fromObject(jsonString);
		JsonConfig config = new JsonConfig();
		config.setJavaIdentifierTransformer(new JavaIdentifierTransformer() {
			/**对json中的字段处理，如果json字段中的前两个字符大写，其他情况下，把原字符串的首个字符小写处理，
			 * 与javabean的属性保持一致避免JSON传入参数首字母为大写时转化的值为空
			 */
			@Override
			public String transformToJavaIdentifier(String str) {
				str = str.toUpperCase();
				return str.toUpperCase();

			}
		});
		config.setRootClass(beanCalss);
		Object bean = JSONObject.toBean(jsonObj1,config);
		return bean;
    }
    
    //**转大写**//*  
    public static char charToUpperCase(char ch){  
        if(ch <= 122 && ch >= 97){  
            ch -= 32;  
        }  
        return ch;  
    } 
}


