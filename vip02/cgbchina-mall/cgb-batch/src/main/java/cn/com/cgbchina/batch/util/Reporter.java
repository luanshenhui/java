package cn.com.cgbchina.batch.util;

import lombok.Getter;
import lombok.Setter;

import java.lang.reflect.Method;

/**
 * Created by 11150121040023 on 2016/8/18.
 */
@Setter
@Getter
public class Reporter {
    private Object target;
    private Method method;
    private Class<?> returnType;
    private String id;
    private String name;
    private Class<?>[] parameterTypes;
    private String ordertypeId;
}
