package cn.com.cgbchina.rest.common.aspect;

import org.aspectj.lang.JoinPoint;
import org.springframework.aop.ThrowsAdvice;
import org.springframework.stereotype.Component;

import com.spirit.util.JsonMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class ServiceExceptionAspect implements ThrowsAdvice {
	JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
	private StringBuilder logStr = new StringBuilder();

	public void afterThrowing(JoinPoint point, Exception ex) {

		StringBuilder sb = new StringBuilder();
		sb.append("【外部接口异常】方法：");
		sb.append(point.getSignature().getDeclaringTypeName());
		sb.append(".");
		sb.append(point.getSignature().getName());
		if (point.getArgs().length > 0) {
			for (Object obj : point.getArgs()) {
				if (obj != null) {
					String json = jsonMapper.toJson(obj);
					sb.append("\n传入参数类型：\n" + obj.getClass() + "\n");
					sb.append("传入参数:\n" + json + "\n");
				} else {
					sb.append("\n没有传入参数：\n");
				}
			}

		}
		sb.append("异常方法：" + point.getSignature() + "\n");
		sb.append("异常信息:\n");
		log.error(sb.toString(), ex);
	}

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
