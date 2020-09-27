/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.trade.service;

import com.spirit.user.User;

import java.util.Map;

/**
 * @author jiao.wu
 * @version 1.0
 * @Since 2016/6/16.
 */
public interface PointRelatedService {
	/**
	 * 信用卡结算的场合取得最优的积分兑换比例,兑换比例小于1时有对应的值返回，不小于1时结果中各属性不存在
	 *
	 * @Param isUseBirthDiscount 是否使用生日优惠（广发商城默认是使用：true）
	 * @Param user 用户
	 * @Return
	 */
	public Map<String, Object> getBestPointScale(boolean isUseBirthDiscount, User user);
}
