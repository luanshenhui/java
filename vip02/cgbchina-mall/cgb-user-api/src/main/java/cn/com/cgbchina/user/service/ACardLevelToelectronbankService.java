/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.model.ACardLevelToelectronbankModel;
import com.spirit.common.model.Response;

import java.util.List;

/**
 * 
 */
public interface ACardLevelToelectronbankService {

	/**
	 * 查询卡等级
	 * 
	 * @return
	 */
	public Response<List<ACardLevelToelectronbankModel>> findCard();

	/**
	 * 查询 卡等级 信息
	 *
	 * @return
	 */
	public Response<ACardLevelToelectronbankModel> findCardByCardLevelNbr(String cardLevelNbr);

	/**
	 * 根据卡等级代码列表查询详细信息
	 * @param idList 卡等级代码列表
	 * @return 查询结果
	 *
	 * geshuo 20160721
	 */
	public Response<List<ACardLevelToelectronbankModel>> findCardLevelByIdList(List<String> idList);
}
