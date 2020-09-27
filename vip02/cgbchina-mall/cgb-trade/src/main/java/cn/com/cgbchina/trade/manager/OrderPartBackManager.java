package cn.com.cgbchina.trade.manager;

import cn.com.cgbchina.trade.dao.OrderPartBackDao;
import cn.com.cgbchina.trade.dao.OrderReturnTrackDao;
import cn.com.cgbchina.trade.model.OrderPartBackModel;
import cn.com.cgbchina.trade.model.OrderReturnTrackModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * Created by yuxinxin on 16-5-10.
 */
@Component
@Transactional
public class OrderPartBackManager {
	@Resource
	private OrderPartBackDao orderPartBackDao;
	@Resource
	private OrderReturnTrackDao orderReturnTrackDao;

	/**
	 * 更新退货状态 供应商端使用此方法
	 *
	 * @param orderPartBackModel
	 * @return
	 */
	public Boolean insert(OrderReturnTrackModel orderPartBackModel) {
		return orderReturnTrackDao.insert(orderPartBackModel) == 1;
	}

	/**
	 * 更新退货状态时向履历表中插入数据
	 *
	 * @param orderPartBackModel
	 * @return
	 */
	public Boolean update(OrderPartBackModel orderPartBackModel) {
		return orderPartBackDao.update(orderPartBackModel) == 1;
	}

	/**
	 * 批量更新退货状态
	 * 
	 * @param params
	 * @return
	 */
	public Integer updateAllGoodsStatus(Map<String, Object> params) {
		return orderPartBackDao.updateAll(params);
	}

	public Boolean insertList(List<OrderReturnTrackModel> orderReturnTrackModelList) {
		return orderReturnTrackDao.insertList(orderReturnTrackModelList) == 1;
	}

	/**
	 * 更新退货状态 供应商端使用此方法
	 *
	 * @param orderPartBackModel
	 * @return
	 */
	public Boolean insert(OrderPartBackModel orderPartBackModel) {
		return orderPartBackDao.insert(orderPartBackModel) == 1;
	}

	/**
	 * 新增退货申请
	 * 
	 * @param orderPartBackModel
	 * @return
	 */
	public Boolean insertBackOrder(OrderPartBackModel orderPartBackModel) {
		return orderPartBackDao.insert(orderPartBackModel) == 1;
	}
}
