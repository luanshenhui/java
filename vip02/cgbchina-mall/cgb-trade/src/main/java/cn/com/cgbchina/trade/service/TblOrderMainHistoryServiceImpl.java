/**
 * Copyright © 2016 广东发展银行 All right reserved
 */
package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.trade.dao.TblOrderCardMappingDao;
import cn.com.cgbchina.trade.dao.TblOrdermainHistoryDao;
import cn.com.cgbchina.trade.manager.OrdermainHistoryManager;
import cn.com.cgbchina.trade.model.TblOrderCardMappingModel;
import cn.com.cgbchina.trade.model.TblOrdermainHistoryModel;
import com.alibaba.dubbo.common.utils.StringUtils;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @author niufw
 * @version 1.0
 * @since 2016/8/13.
 */
@Slf4j
@Service
public class TblOrderMainHistoryServiceImpl implements TblOrderMainHistoryService {
	@Resource
	private TblOrdermainHistoryDao tblOrdermainHistoryDao;
	@Resource
	private OrdermainHistoryManager ordermainHistoryManager;
	@Resource
	private TblOrderCardMappingDao tblOrderCardMappingDao;

	/**
	 * MAL105 CC积分商城订单列表查询接口 niufw
	 * 
	 * @param cardNo
	 * @param orderMainId
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	@Override
	public Response<List<TblOrdermainHistoryModel>> findForCC(String cardNo, String orderMainId, Date startDate,
			Date endDate) {
		Response<List<TblOrdermainHistoryModel>> response = Response.newResponse();
		Map<String, Object> paramMap = Maps.newHashMap();
		// donghb 0903 start
		if (StringUtils.isNotEmpty(cardNo)) {
			paramMap.put("cardNo", cardNo.trim());// 卡号
		}
		if (StringUtils.isNotEmpty(orderMainId)) {
			paramMap.put("orderMainId", orderMainId.trim());// 主订单号
		}
		paramMap.put("ordertypeId", Contants.ORDERTYPEID_JF);
		// donghb 0903 end
		paramMap.put("startDate", startDate);// 开始时间
		paramMap.put("endDate", endDate);// 结束时间
		paramMap.put("delFlag", 0);// 删除标识位 0--未删除
		try {
			List<TblOrdermainHistoryModel> tblOrdermainHistoryModelList = tblOrdermainHistoryDao.findForCC(paramMap);
			// donghb 0903 start
			List<TblOrderCardMappingModel> cardModelList = tblOrderCardMappingDao.findByOrderMainIdOrCardNo(paramMap);
			List<String> mainIdList = Lists.newArrayList();
			boolean sameFlag = false;
			if (cardModelList != null && cardModelList.size() > 0) {
				for (TblOrderCardMappingModel cardModel : cardModelList) {
					for (TblOrdermainHistoryModel mainModel : tblOrdermainHistoryModelList) {
						if (cardModel.getOrdermainId().equals(mainModel.getOrdermainId())) {
							sameFlag = true;
							break;
						}
					}
					if (!sameFlag) {
						mainIdList.add(cardModel.getOrdermainId());
					}
				}
				if (mainIdList != null && mainIdList.size() > 0) {
					Map<String, Object> params = Maps.newHashMap();
					params.put("orderMainIdList", mainIdList);
					List<TblOrdermainHistoryModel> mainModelListForCard = tblOrdermainHistoryDao
							.findOrdersByList(params);
					tblOrdermainHistoryModelList.addAll(mainModelListForCard);
				}
			}
			// donghb 0903 end
			response.setResult(tblOrdermainHistoryModelList);
			return response;
		} catch (Exception e) {
			log.error("orderMainHistory.time.query.error", Throwables.getStackTraceAsString(e));
			response.setError("orderMainHistory.time.query.error");
			return response;
		}
	}

	/**
	 * MAL108根据主订单号查询 niufw
	 *
	 * @param orderMainId
	 * @return
	 */
	@Override
	public Response<TblOrdermainHistoryModel> findByOrderMainId(String orderMainId) {
		Response<TblOrdermainHistoryModel> response = Response.newResponse();
		if (StringUtils.isEmpty(orderMainId)) {
			response.setError("orderMainHistory.time.query.error");
			return response;
		}
		try {
			TblOrdermainHistoryModel tblOrdermainHistoryModel = tblOrdermainHistoryDao.findById(orderMainId);
			response.setResult(tblOrdermainHistoryModel);
			return response;
		} catch (Exception e) {
			log.error("orderMainHistory.time.query.error", Throwables.getStackTraceAsString(e));
			response.setError("orderMainHistory.time.query.error");
			return response;
		}
	}

	/**
	 * 更新投递方式信息
	 * 
	 * @param ordermainHistoryModel
	 * @return
	 */
	@Override
	public Response<Integer> updateOrderMainHistoryAddr(TblOrdermainHistoryModel ordermainHistoryModel) {
		Response<Integer> response = Response.newResponse();
		try {
			Integer count = ordermainHistoryManager.update(ordermainHistoryModel);
			response.setResult(count);
			return response;
		} catch (Exception e) {
			log.error("orderMainHistory.updateOrderMainHistoryAddr.error", Throwables.getStackTraceAsString(e));
			response.setError("orderMainHistory.updateOrderMainHistoryAddr.error");
			return response;
		}
	}
}
