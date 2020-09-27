package cn.com.cgbchina.rest.common.utils;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.Set;

import javax.validation.ConstraintViolation;
import javax.validation.Validation;
import javax.validation.Validator;

public class ValidateUtil {
	public static String validateModel(Object obj) { // 验证某一个对象
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		StringBuilder sb = new StringBuilder("【验证异常】" + sdf.format(new Date()) + "\n"); // 用于存储验证后的错误信息

		Validator validator = Validation.buildDefaultValidatorFactory().getValidator();

		Set<ConstraintViolation<Object>> constraintViolations = validator.validate(obj);// 验证某个对象,，其实也可以只验证其中的某一个属性的

		Iterator<ConstraintViolation<Object>> iter = constraintViolations.iterator();
		boolean FailFlag = false;
		while (iter.hasNext()) {
			FailFlag = true;
			ConstraintViolation<Object> vailObj = iter.next();
			String message = vailObj.getMessage();
			sb.append(vailObj.getRootBeanClass().getName() + " " + vailObj.getPropertyPath() + " " + message + "\n");
		}
		if (FailFlag) {
			throw new RuntimeException(sb.toString());
		}
		return sb.toString();
	}
}
