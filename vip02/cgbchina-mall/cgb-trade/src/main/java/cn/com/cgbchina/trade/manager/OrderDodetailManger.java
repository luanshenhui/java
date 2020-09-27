package cn.com.cgbchina.trade.manager;

import cn.com.cgbchina.trade.dao.OrderDoDetailDao;
import cn.com.cgbchina.trade.dao.OrderTransDao;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderTransModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by 11141021040453 on 2016/5/13.
 */
@Component
@Transactional
public class OrderDodetailManger {

	@Resource
	OrderDoDetailDao orderDoDetailDao;

	/**
	 * 新增订单历史明细
	 *
	 * @param orderDoDetailModel
	 * @return
	 */
	public Boolean insert(OrderDoDetailModel orderDoDetailModel) {
		return orderDoDetailDao.insert(orderDoDetailModel) == 1;
	}

	/**
	 * 新增订单历史明细表（供应商请款）
	 * @param orderDoDetailModelList
	 * @return
	 */

	@Transactional(propagation = Propagation.REQUIRED)
	public Boolean insertForReq(List<OrderDoDetailModel> orderDoDetailModelList) {
		return orderDoDetailDao.insertBatch(orderDoDetailModelList) == 1;
	}

}
