package cn.com.cgbchina.user.manager;

import cn.com.cgbchina.user.dao.MemberLogonHistoryDao;
import cn.com.cgbchina.user.model.MemberLogonHistoryModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * Created by 11140721050130 on 2016/5/8.
 */
@Component
@Transactional
public class LogonHistoryManager {

	@Resource
	private MemberLogonHistoryDao memberLogonHistoryDao;

	/**
	 * 登录时，添加一条记录
	 *
	 * @param memberLogonHistoryModel
	 * @return
	 */
	public boolean insertLogon(MemberLogonHistoryModel memberLogonHistoryModel) {
		// 调用接口
		Integer flag = memberLogonHistoryDao.insertLogon(memberLogonHistoryModel);
		if (flag > 0) {
			return true;
		}
		return false;
	}
}
