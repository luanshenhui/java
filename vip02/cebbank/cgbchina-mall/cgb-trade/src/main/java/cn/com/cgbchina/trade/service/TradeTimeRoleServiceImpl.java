package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.dao.DeadlineModelDao;
import cn.com.cgbchina.trade.manager.DeadLineManager;
import cn.com.cgbchina.trade.model.DeadlineModel;
import com.google.common.base.Preconditions;
import com.google.common.base.Throwables;
import com.google.common.cache.CacheLoader;
import com.google.common.collect.Maps;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Map;

import static com.google.common.base.Objects.equal;
import static com.google.common.base.Preconditions.checkArgument;

/**
 * Created by 11140721050130 on 16-3-18.
 */
@Service
@Slf4j
public class TradeTimeRoleServiceImpl implements TradeTimeRoleService {
	@Resource
	private DeadlineModelDao deadlineModelDao;

	@Resource
	private DeadLineManager deadLineManager;

	@Override
	public Response<Boolean> update(DeadlineModel deadlineModel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 校验
			if (deadlineModel == null) {
			}
			Boolean result = deadLineManager.update(deadlineModel);
			if (!result) {
				response.setError("update.eroor");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("update.deanline.error", Throwables.getStackTraceAsString(e));
			response.setError("update.eroor");
			return response;
		}

	}

	@Override
	public Response<Pager<DeadlineModel>> find(Integer pageNo, Integer size, String status) {
		Response<Pager<DeadlineModel>> response = new Response<Pager<DeadlineModel>>();
		Map<String, Object> paramMap = Maps.newHashMap();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		if (StringUtils.isNotEmpty(status) && !equal(status, "0")) {
			paramMap.put("status", status);// 查询退款
		}
		try {
			Pager<DeadlineModel> pager = deadlineModelDao.findByPage(paramMap, pageInfo.getOffset(),
					pageInfo.getLimit());
			response.setResult(pager);
			return response;
		} catch (Exception e) {
			log.error("trade time qury error", Throwables.getStackTraceAsString(e));
			response.setError("trade.time.query.error");
			return response;
		}

	}

}
