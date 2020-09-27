package cn.com.cgbchina.rest.common.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 根据注解的值获取对应的xml 节点的内容
 * 
 * @author Lizy
 *
 */
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
public @interface XMLNodeName {
	String value() default "";
}
