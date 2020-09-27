package cn.com.cgbchina.batch.service;

import java.io.IOException;

import cn.com.cgbchina.batch.model.ModifyIntegral;

/**
 * 更改积分报表（积分商城）
 * 
 * @see ModifyIntegral
 * @author huangcy
 */
public interface ModifyIntegralService {
	/**
	 * 更改积分报表
	 * 
	 * @throws IOException
	 */
	void exportModifyIntegral() throws IOException;
}
