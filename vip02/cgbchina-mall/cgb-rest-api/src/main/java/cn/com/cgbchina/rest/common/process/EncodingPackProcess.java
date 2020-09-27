package cn.com.cgbchina.rest.common.process;

public interface EncodingPackProcess<R, T> {
	public T packing(R r, Class<T> t, String encoding);
}
