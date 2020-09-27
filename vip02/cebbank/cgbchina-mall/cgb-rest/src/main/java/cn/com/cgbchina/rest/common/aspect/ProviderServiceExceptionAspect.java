package cn.com.cgbchina.rest.common.aspect;

import org.aspectj.lang.JoinPoint;
import org.springframework.aop.ThrowsAdvice;
import org.springframework.stereotype.Component;

import com.spirit.util.JsonMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class ProviderServiceExceptionAspect implements ThrowsAdvice {
	JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
	private StringBuilder logStr = new StringBuilder();

	public void afterReturn(JoinPoint point, Object returnValue) {
		logStr.delete(0, logStr.length());
		logStr.append("【外部接口调用】\n方法：");
		logStr.append(point.getSignature().getDeclaringTypeName());
		logStr.append(".");
		logStr.append(point.getSignature().getName());
		logStr.append("\n 传入参数：\n");
		logStr.append(jsonMapper.toJson(point.getArgs()));
		logStr.append("\n 返回参数:\n");
		logStr.append(jsonMapper.toJson(returnValue));
		log.info(logStr.toString());
	}

}
