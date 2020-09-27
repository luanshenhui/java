package cn.com.cgbchina.user.manager;

import cn.com.cgbchina.user.dao.PersonalMessageDao;
import cn.com.cgbchina.user.model.PersonalMessageModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

@Component
@Transactional
public class PersonalMessageManager {
	@Resource
	private PersonalMessageDao personalMessageDao;

	/**
	 * 消息全部已读功能
	 *
	 * @param personalMessageMode
	 * @return
	 */
	public boolean updateAllMessage(PersonalMessageModel personalMessageMode) {
		// 事物处理
		Integer updateResult = personalMessageDao.updateMessage(personalMessageMode);
		if (updateResult == 0) {
			return Boolean.FALSE;
		}
		return Boolean.TRUE;
	}
}
