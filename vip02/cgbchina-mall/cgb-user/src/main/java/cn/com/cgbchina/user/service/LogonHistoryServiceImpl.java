package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.dao.MemberLogonHistoryDao;
import cn.com.cgbchina.user.manager.LogonHistoryManager;
import cn.com.cgbchina.user.model.MemberLogonHistoryModel;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 *
 */
@Slf4j
@Service
public class LogonHistoryServiceImpl implements LogonHistoryService {

	@Resource
	private MemberLogonHistoryDao memberLogonHistoryDao;

	@Resource
	private LogonHistoryManager logonHistoryManager;

	@Override
	public Response<List<MemberLogonHistoryModel>> findLogonHistory(Integer pageNo, Integer size, User user) {
		Response<List<MemberLogonHistoryModel>> response = new Response<List<MemberLogonHistoryModel>>();

//		PageInfo pageInfo = new PageInfo(pageNo, size);

		Map<String, Object> paramMap = Maps.newHashMap();
		paramMap.put("custId", user.getId());

		try {

			// 调用接口
			List<MemberLogonHistoryModel> result = memberLogonHistoryDao.findLogonHistory(paramMap);
			response.setResult(result);
			return response;
		} catch (Exception e) {
			log.error("goods.consult.query.error", Throwables.getStackTraceAsString(e));
			response.setError("goods.consult.query.error");
			return response;
		}
	}

	/**
	 * 登录时，插入一条记录
	 *
	 * @param memberLogonHistoryModel
	 * @return
	 */
	@Override
	public Response<Boolean> insertLogon(MemberLogonHistoryModel memberLogonHistoryModel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 调用接口
			Boolean result = logonHistoryManager.insertLogon(memberLogonHistoryModel);
			if (!result) {
				response.setError("insert.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("insert.error", Throwables.getStackTraceAsString(e));
			response.setError("insert.error");
			return response;
		}
	}

}
