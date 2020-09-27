package cn.com.cgbchina.user.service;

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
}
