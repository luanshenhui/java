/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.trade.manager;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import cn.com.cgbchina.trade.dao.OrderReturnTrackDetailDao;
import cn.com.cgbchina.trade.model.OrderReturnTrackDetailModel;

/**
 * @author yuxinxin
 * @version 1.0
 * @Since 16-7-5.
 */
@Component
@Transactional
public class OrderReturnTrackDetailManager {
	@Resource
	OrderReturnTrackDetailDao orderReturnTrackDetailDao;

	public Boolean insert(OrderReturnTrackDetailModel orderReturnTrackDetailModel) {
		return orderReturnTrackDetailDao.insert(orderReturnTrackDetailModel) == 1;
	}
}
