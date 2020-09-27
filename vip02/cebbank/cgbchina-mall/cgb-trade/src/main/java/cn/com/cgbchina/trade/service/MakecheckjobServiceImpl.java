/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.dao.TblMakecheckjobHistoryDao;
import cn.com.cgbchina.trade.model.TblMakecheckjobHistoryModel;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * @author liuhan
 * @version 1.0
 * @Since 16-6-15.
 */
@Service
@Slf4j
public class MakecheckjobServiceImpl implements MakecheckjobService {
	@Resource
	TblMakecheckjobHistoryDao tblMakecheckjobHistoryDao;

	/**
	 * 查询对账失败
	 *
	 * @param pageNo
	 * @param size
	 * @param startOpedate
	 * @param endOpedate
	 * @return
	 */
	@Override
	public Response<Pager<TblMakecheckjobHistoryModel>> find(@Param("pageNo") Integer pageNo,
			@Param("size") Integer size, @Param("startOpedate") String startOpedate,
			@Param("endOpedate") String endOpedate, @Param("user") User user) {
		// 实例化返回Response
		Response<Pager<TblMakecheckjobHistoryModel>> response = new Response<Pager<TblMakecheckjobHistoryModel>>();
		List<TblMakecheckjobHistoryModel> tblMakecheckjobHistoryModelList = Lists.newArrayList();
		Map<String, Object> paramMap = Maps.newHashMap();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		try {
			// 查询条件
			paramMap.put("offset", pageInfo.getOffset());
			paramMap.put("limit", pageInfo.getLimit());
			if (StringUtils.isNotEmpty(startOpedate)) {
				paramMap.put("startOpedate", startOpedate);
			}
			if (StringUtils.isNotEmpty(endOpedate)) {
				paramMap.put("endOpedate", endOpedate);
			}

			Pager<TblMakecheckjobHistoryModel> pager = tblMakecheckjobHistoryDao.findByPageQuery(paramMap,
					pageInfo.getOffset(), pageInfo.getLimit());
			// 查询信息存在的情况下
			if (pager.getTotal() > 0) {
				// 获取pager的每一行信息
				List<TblMakecheckjobHistoryModel> tblMakecheckjobHistoryList = pager.getData();
				for (TblMakecheckjobHistoryModel tblMakecheckjobHistoryModel : tblMakecheckjobHistoryList) {
					tblMakecheckjobHistoryModelList.add(tblMakecheckjobHistoryModel);
				}
			}
			response.setResult(
					new Pager<TblMakecheckjobHistoryModel>(pager.getTotal(), tblMakecheckjobHistoryModelList));
			return response;
		} catch (Exception e) {
			log.error("tblMakecheckjobHistory.query.error", Throwables.getStackTraceAsString(e));
			response.setError("tblMakecheckjobHistory.query.error");
			return response;
		}
	}

	/**
	 * 查询对账失败异常
	 *
	 * @param pageNo
	 * @param size
	 * @param startOpedate
	 * @param endOpedate
	 * @return
	 */
	@Override
	public Response<Pager<TblMakecheckjobHistoryModel>> findError(@Param("pageNo") Integer pageNo,
			@Param("size") Integer size, @Param("startOpedate") String startOpedate,
			@Param("endOpedate") String endOpedate, @Param("user") User user) {
		// 实例化返回Response
		Response<Pager<TblMakecheckjobHistoryModel>> response = new Response<Pager<TblMakecheckjobHistoryModel>>();
		List<TblMakecheckjobHistoryModel> tblMakecheckjobHistoryModelList = Lists.newArrayList();
		Map<String, Object> paramMap = Maps.newHashMap();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		try {
			// 查询条件
			paramMap.put("offset", pageInfo.getOffset());
			paramMap.put("limit", pageInfo.getLimit());
			if (StringUtils.isNotEmpty(startOpedate)) {
				paramMap.put("startOpedate", startOpedate);
			}
			if (StringUtils.isNotEmpty(endOpedate)) {
				paramMap.put("endOpedate", endOpedate);
			}

			Pager<TblMakecheckjobHistoryModel> pager = tblMakecheckjobHistoryDao.findByPageQueryError(paramMap,
					pageInfo.getOffset(), pageInfo.getLimit());
			// 查询信息存在的情况下
			if (pager.getTotal() > 0) {
				// 获取pager的每一行信息
				List<TblMakecheckjobHistoryModel> tblMakecheckjobHistoryList = pager.getData();
				for (TblMakecheckjobHistoryModel tblMakecheckjobHistoryModel : tblMakecheckjobHistoryList) {
					tblMakecheckjobHistoryModelList.add(tblMakecheckjobHistoryModel);
				}
			}
			response.setResult(
					new Pager<TblMakecheckjobHistoryModel>(pager.getTotal(), tblMakecheckjobHistoryModelList));
			return response;
		} catch (Exception e) {
			log.error("tblMakecheckjobHistory.query.error", Throwables.getStackTraceAsString(e));
			response.setError("tblMakecheckjobHistory.query.error");
			return response;
		}
	}
}
