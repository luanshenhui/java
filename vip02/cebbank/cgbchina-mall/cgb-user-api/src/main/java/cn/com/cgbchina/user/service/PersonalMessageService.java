package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.dto.PersonalMessageDto;
import cn.com.cgbchina.user.model.PersonalMessageModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

/**
 * add by tanliang
 */
public interface PersonalMessageService {

	/**
	 * 我的消息分页tab数据
	 * 
	 * @param pageNo
	 * @param size
	 * @param type
	 * @return
	 */
	public Response<Pager<PersonalMessageDto>> findAll(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("type") String type,@Param("user")User user);

	/**
	 * 更新所有消息（已读）
	 * 
	 * @param personalMessageModel
	 * @return
	 */
	public Response<Boolean> updateAllMessage(PersonalMessageModel personalMessageModel);
}
