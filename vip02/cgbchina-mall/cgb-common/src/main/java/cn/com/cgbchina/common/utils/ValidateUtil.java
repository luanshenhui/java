package cn.com.cgbchina.common.utils;

import java.util.Iterator;
import java.util.Set;

import javax.validation.ConstraintViolation;
import javax.validation.Validation;
import javax.validation.Validator;

public class ValidateUtil {
	public static String validateModel(Object obj) { // 验证某一个对象

		StringBuilder sb = new StringBuilder(); // 用于存储验证后的错误信息

		Validator validator = Validation.buildDefaultValidatorFactory().getValidator();

		Set<ConstraintViolation<Object>> constraintViolations = validator.validate(obj);// 验证某个对象,，其实也可以只验证其中的某一个属性的

		Iterator<ConstraintViolation<Object>> iter = constraintViolations.iterator();
		
		while (iter.hasNext()) {
			ConstraintViolation<Object> msg =iter.next();			
			if(sb.length()==0){
				sb.append(msg.getRootBean());
			}
			String message =msg.getPropertyPath()+" "+msg.getMessage()+"\n";
			sb.append(message);
		}
		return sb.toString();
	}
	public static void validateObj(Object obj){
		String res =validateModel(obj);
		if(res.length()>0){
			throw  new  RuntimeException(res); 
		}
	}
	public static void main(String[] args) {
	 
	}
}
