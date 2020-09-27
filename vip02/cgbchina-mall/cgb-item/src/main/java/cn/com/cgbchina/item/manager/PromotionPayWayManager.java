/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.manager;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import cn.com.cgbchina.item.dao.PromotionPayWayDao;
import cn.com.cgbchina.item.model.PromotionPayWayModel;

/**
 * @author 陈乐
 * @version 1.0
 * @Since 2016/7/26.
 */

@Component
@Transactional
public class PromotionPayWayManager {

	@Resource
	private PromotionPayWayDao promotionPayWayDao;

	/**
	 * 批量插入活动支付方式
	 * 
	 * @param list
	 * @return
	 */
	public Integer createPromotionPayWay(List<PromotionPayWayModel> list) {
		return promotionPayWayDao.insertAllPayWay(list);
	}
}
