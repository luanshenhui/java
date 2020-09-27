package cn.com.cgbchina.promotion.service;

import java.util.Map;

import com.spirit.common.model.Response;

import cn.com.cgbchina.promotion.model.EspActRemindModel;

/**
 * 活动提醒
 */
public interface EspActRemindService {

	/**
	 * 添加活动提醒
	 * 
	 * @param espActRemindModel 添加数据
	 * @return 添加结果
	 *
	 *         geshuo 20160722
	 */
	public Response<Integer> insert(EspActRemindModel espActRemindModel);

	/**
	 * 根据参数逻辑删除
	 * 
	 * @param paramMap 删除参数
	 * @return 删除结果
	 *
	 *         geshuo 20160722
	 */
	public Response<Integer> deleteRemindByParams(Map<String, Object> paramMap);
	
	/**
	 * 查询是否设置过提醒  设置提醒 true else false
	 * @param espActRemindModel 添加数据
	 * @return boolean
	 * 
	 */
	public Response<Boolean> findIsRemidByGoods (EspActRemindModel espActRemindModel);
}
