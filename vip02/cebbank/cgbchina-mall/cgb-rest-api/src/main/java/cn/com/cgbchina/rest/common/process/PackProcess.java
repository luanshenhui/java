package cn.com.cgbchina.rest.common.process;

/**
 * Comment: Created by 11150321050126 on 2016/4/27.
 */
public interface PackProcess<R, T> {
	public T packing(R r, Class<T> t) throws Exception;
}
