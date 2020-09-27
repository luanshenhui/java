package cn.com.cgbchina.related.manager;

import cn.com.cgbchina.related.dao.MessageSettingDao;
import cn.com.cgbchina.related.model.MessageSettingModel;
import com.alibaba.dubbo.common.utils.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Date;

/**
 * Created by yuxinxin on 16-4-25.
 */
@Component
@Transactional
public class MessageSettingManager {
	@Resource
	private MessageSettingDao messageSettingDao;

	/**
	 * 开关
	 *
	 * @param messageSetting
	 * @return
	 */
	public Boolean update(MessageSettingModel messageSetting) {
		if (messageSetting.getId() == null) {
			messageSetting.setDelFlag("0");
			messageSetting.setCreateTime(new Date());
			messageSettingDao.insert(messageSetting);
		} else {
			MessageSettingModel model = messageSettingDao.findById(messageSetting.getId());
			if (model == null) {
				messageSetting.setDelFlag("0");
				messageSetting.setCreateTime(new Date());
				messageSettingDao.insert(messageSetting);
			} else {
				messageSetting.setModifyTime(new Date());
				messageSettingDao.update(messageSetting);
			}
		}
		return true;
	}
}
