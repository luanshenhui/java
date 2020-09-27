package cn.com.cgbchina.rest.common.process;

/**
 * Comment: Created by 11150321050126 on 2016/4/27.
 */
public interface ValidProcess<T> {
	boolean valid(T obj);
}
