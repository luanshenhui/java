package cn.com.cgbchina.trade.manager;

import cn.com.cgbchina.trade.dao.OrderReturnTrackDao;
import cn.com.cgbchina.trade.model.OrderReturnTrackModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * Created by 11141021040453 on 2016/5/17.
 */
@Component
@Transactional
public class OrderReturnTrackManager {
	@Resource
	OrderReturnTrackDao orderReturnTrackDao;

	/**
	 * 更新退货履历
	 *
	 * @param OrderReturnTrackModel
	 * @return
	 */
	public Boolean insert(OrderReturnTrackModel OrderReturnTrackModel) {
		return orderReturnTrackDao.insert(OrderReturnTrackModel) == 1;
	}

}
