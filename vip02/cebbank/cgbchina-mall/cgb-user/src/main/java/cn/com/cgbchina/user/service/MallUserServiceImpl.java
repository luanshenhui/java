/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.user.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.user.dao.MemberLogonHistoryDao;
import cn.com.cgbchina.user.dao.UserRedisDao;
import cn.com.cgbchina.user.model.MemberLogonHistoryModel;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

import static com.google.common.base.Preconditions.checkArgument;
import static com.spirit.util.Arguments.notNull;

/**
 * @author wusy
 * @version 1.0
 * @Since 2016/7/2.
 */
@Service
@Slf4j
public class MallUserServiceImpl implements MallUserService {

	@Resource
	private MemberLogonHistoryDao memberLogonHistoryDao;

	@Resource
	private UserRedisDao userRedisDao;

	/**
	 * 登录log信息登录
	 *
	 * @param custId
	 * @param clientIP
	 * @param clientMacAdress
	 * @param status
	 * @return
	 */
	@Override
	public Response<Long> mallLoginLog(String custId, String clientIP, String clientMacAdress, String status) {
		Response<Long> result = new Response<Long>();

		try {
			checkArgument(notNull(custId), "login.custId.empty");
			checkArgument(notNull(clientIP), "login.clientIP.empty");
			checkArgument(notNull(clientMacAdress), "login.clientMacAdress.empty");
			checkArgument(notNull(status), "login.status.empty");

			// 登录同时不管成功与否，都向登录历史表中插入一条数据
			MemberLogonHistoryModel memberLogonHistoryModel = new MemberLogonHistoryModel();
			memberLogonHistoryModel.setIpAddress(clientIP);
			memberLogonHistoryModel.setCustId(custId);
			memberLogonHistoryModel.setMacAddress(clientMacAdress);
			memberLogonHistoryModel.setStatus(status);
			memberLogonHistoryModel.setDelFlag(Contants.DEL_FLAG_0);
			memberLogonHistoryDao.insert(memberLogonHistoryModel);

			Long id = memberLogonHistoryModel.getId();
			result.setResult(id);

		} catch (IllegalArgumentException e) {
			log.error("fail to login with userName:{} ,error:{}", custId, e.getMessage());
			result.setError(e.getMessage());
		} catch (IllegalStateException e) {
			log.error("fail to login with userName:{} ,error:{}", custId, e.getMessage());
			result.setError(e.getMessage());
		} catch (Exception e) {
			log.error("fail to login with userName:{} ,cause:{}", custId, Throwables.getStackTraceAsString(e));
			result.setError("user.login.fail");
		}
		return result;
	}

	/**
	 * 更新退出时间
	 *
	 * @param id
	 * @return
	 */
	@Override
	public Response updateLogoutTime(Long id) {
		Response result = new Response();
		try {
			memberLogonHistoryDao.updateLogoutTime(id);
			result.setSuccess(true);

		} catch (IllegalArgumentException e) {
			log.error("fail to logout with userName:{} ,error:{}", id, e.getMessage());
			result.setError("user.logout.fail");
			result.setResult(false);
		} catch (IllegalStateException e) {
			log.error("fail to logout with userName:{} ,error:{}", id, e.getMessage());
			result.setError("user.logout.fail");
			result.setResult(false);
		} catch (Exception e) {
			log.error("fail to logout with userName:{} ,cause:{}", id, Throwables.getStackTraceAsString(e));
			result.setError("user.logout.fail");
			result.setResult(false);
		}

		return result;
	}

	/**
	 * 查询日志登录信息
	 *
	 * @param custId
	 * @return
	 */
	@Override
	public Response<Boolean> selectLoginLog(String custId) {
		Response<Boolean> result = new Response<Boolean>();
		try {
			checkArgument(notNull(custId), "login.custId.empty");
			// 查询登录日志
			List<MemberLogonHistoryModel> MemberLogs = memberLogonHistoryDao.findSuccessByCustId(custId);
			if (MemberLogs != null && MemberLogs.size() > 0) {
				result.setResult(true);
			} else {
				result.setResult(false);
			}

		} catch (IllegalArgumentException e) {
			log.error("fail to login with userName:{} ,error:{}", custId, e.getMessage());
			result.setError("user.select.log.fail");
			result.setResult(false);
		} catch (IllegalStateException e) {
			log.error("fail to login with userName:{} ,error:{}", custId, e.getMessage());
			result.setError("user.select.log.fail");
			result.setResult(false);
		} catch (Exception e) {
			log.error("fail to login with userName:{} ,cause:{}", custId, Throwables.getStackTraceAsString(e));
			result.setError("user.select.log.fail");
			result.setResult(false);
		}

		return result;
	}

	/**
	 * 查询登录白名单信息(是否有userid)
	 *
	 * @param custId
	 * @return
	 */
	@Override
	public Response<Boolean> findWhiteCustIdList(String custId) {
		Response<Boolean> response = new Response<Boolean>();
		//  查询数据
		try {
			List<String> list = userRedisDao.findWhiteCustIdList();
			// 白名单不存在
			if(list == null || list.size() == 0){
				log.error("user.login.white.empty");
				response.setError("user.login.white.empty");
				return response;
			}
			// 用户ID是否存在白名单中
			boolean bool = list.contains(custId);
			if(!bool){
				response.setResult(false);
				return response;
			}
			response.setResult(true);
			return response;
		} catch (Exception e) {
			log.error("business.find.web.login.error", Throwables.getStackTraceAsString(e));
			response.setError("business.find.web.login.error");
			return response;
		}
	}
}
