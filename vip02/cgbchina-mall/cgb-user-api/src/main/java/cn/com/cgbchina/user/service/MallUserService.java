/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.user.service;

import com.spirit.common.model.Response;

/**
 * @author wusy
 * @version 1.0
 * @Since 2016/7/2.
 */
public interface MallUserService {
	/**
	 * 登录log信息登录
	 * 
	 * @param custId
	 * @param clientIP
	 * @param clientMacAdress
	 * @param status
	 * @return
	 */
	public Response<Long> mallLoginLog(String custId, String clientIP, String clientMacAdress, String status);

	/**
	 * 更新退出时间
	 *
	 * @param id
	 * @return
	 */
	public Response updateLogoutTime(Long id);

	/**
	 * 查询日志登录信息
	 * 
	 * @param custId
	 * @return
	 */
	public Response<Boolean> selectLoginLog(String custId);

	/**
	 * 查询登录白名单信息
	 *
	 * @param custId
	 * @return
	 */
	public Response<Boolean> findWhiteCustIdList(String custId);
}
