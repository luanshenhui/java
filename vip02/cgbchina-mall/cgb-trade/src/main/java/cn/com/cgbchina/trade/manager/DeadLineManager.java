package cn.com.cgbchina.trade.manager;

import cn.com.cgbchina.trade.dao.DeadlineModelDao;
import cn.com.cgbchina.trade.model.DeadlineModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * Created by 11140721050130 on 2016/4/21.
 */
@Component
@Transactional
public class DeadLineManager {

	@Resource
	private DeadlineModelDao deadlineModelDao;

	public boolean update(DeadlineModel deadlineModel) {
		return deadlineModelDao.update(deadlineModel) == 1;
	}
}
