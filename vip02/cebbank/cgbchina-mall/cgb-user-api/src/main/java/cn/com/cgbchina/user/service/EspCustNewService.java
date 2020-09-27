package cn.com.cgbchina.user.service;


import com.spirit.common.model.Response;

import java.util.List;

/**
 * @author
 * @version 1.0
 * @Since 2016/6/6.
 */
public interface EspCustNewService {

	/**
	 * 更新使用生日次数
	 *
	 * @param custId
	 * @return
	 */
	public Response<Integer> updateBirthUsedCount(String custId);
}
