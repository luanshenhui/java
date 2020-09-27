package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.model.MemberLogonHistoryModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.util.List;

/**
 *
 */
public interface LogonHistoryService {

	/**
	 * 查找会员登录历史表
	 *
	 * @return
	 */
	public Response<List<MemberLogonHistoryModel>> findLogonHistory(@Param("pageNo") Integer pageNo,
			@Param("size") Integer size, @Param("user") User user);

	/**
	 * 登录时，插入一条记录
	 * 
	 * @param memberLogonHistoryModel
	 * @return
	 */
	public Response<Boolean> insertLogon(MemberLogonHistoryModel memberLogonHistoryModel);

}
