package cn.com.cgbchina.user.manager;

import cn.com.cgbchina.user.dao.EspPublishInfDao;
import cn.com.cgbchina.user.model.EspPublishInfModel;
import cn.com.cgbchina.user.model.MemberGoodsFavoriteModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * @author Tanliang
 * @time 2016-6-6
 */

@Component
@Transactional
public class EspPublishInfManage {

	@Resource
	private EspPublishInfDao espPublishInfDao;

	public Boolean createPublish(EspPublishInfModel espPublishInfModel) {
		Integer productResult = espPublishInfDao.insert(espPublishInfModel);
		// 事物处理
		if (productResult != 1) {
			return Boolean.FALSE;
		}
		return Boolean.TRUE;
	}
}
