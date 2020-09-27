package cn.com.cgbchina.related.service;

import cn.com.cgbchina.related.dto.MessageSettingDto;
import com.spirit.common.model.Response;
import com.spirit.user.User;

/**
 * Created by yuxinxin on 16-4-24.
 */
public interface MessageSettingService {
	/**
	 * 更新开关状态
	 * 
	 * @param messageSettingDto
	 * @return
	 */
	Response<Boolean> updateMessage(MessageSettingDto messageSettingDto,User user);

	/**
	 * 查询所有开关状态
	 * 
	 * @return
	 */
	Response<MessageSettingDto> findAll();
}
