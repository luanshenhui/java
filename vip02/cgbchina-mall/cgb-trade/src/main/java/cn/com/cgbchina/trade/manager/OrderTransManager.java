package cn.com.cgbchina.trade.manager;

import cn.com.cgbchina.trade.dao.OrderTransDao;
import cn.com.cgbchina.trade.model.OrderTransModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * Created by 11141021040453 on 2016/5/13.
 */
@Component
@Transactional
public class OrderTransManager {

	@Resource
	OrderTransDao orderTransDao;

	/**
	 * 更新物流信息
	 *
	 * @param orderTransModel
	 * @return
	 */
	public Boolean update(OrderTransModel orderTransModel) {
		return orderTransDao.update(orderTransModel) == 1;
	}

	/**
	 * 新增物流信息
	 *
	 * @param orderTransModel
	 * @return
	 */
	public Boolean insert(OrderTransModel orderTransModel) {
		return orderTransDao.insert(orderTransModel) == 1;
	}

}
