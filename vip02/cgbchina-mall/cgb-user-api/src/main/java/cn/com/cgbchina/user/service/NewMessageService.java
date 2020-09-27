package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.dto.MessageDto;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;
import com.spirit.user.User;

/**
 * Created by 张成 on 16-4-25.
 */
public interface NewMessageService {
	/**
	 * 查找供应商未读消息个数
	 * 
	 * @return Integer 消息个数
	 */
	public Response<Long> find(@Param("_USER_") User user);

	/**
	 * 站内消息插入
	 *
	 * @param messageDto 输入参数
	 * @return 是否成功 失败原因
	 * message.is.empty:参数有空值， insert.vendor.message.error：插入供应商消息失败
	 * insert.personal.message.error：插入个人消息失败   insert.message.error： 插入失败
	 */
	public Response insertUserMessage(MessageDto messageDto);
}
