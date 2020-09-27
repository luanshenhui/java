/**
 * Copyright © 2016 广东发展银行 All right reserved
 */
package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.trade.dao.OrderMainDao;
import cn.com.cgbchina.trade.dao.TblOrderCardMappingDao;
import cn.com.cgbchina.trade.manager.OrderMainManager;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.TblOrderCardMappingModel;
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
public class TblOrderMainServiceImpl implements TblOrderMainService {
	@Resource
	private OrderMainDao orderMainDao;
	@Resource
	private OrderMainManager orderMainManager;
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
	public Response<List<OrderMainModel>> findForCC(String cardNo, String orderMainId, Date startDate,
			Date endDate) {
		Response<List<OrderMainModel>> response = Response.newResponse();
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
			List<OrderMainModel> orderMainModelList = orderMainDao.findForCC(paramMap);
			// donghb 0903 start
			//TODO : 获取卡号订单映射表有什么意义？没有意义就删了！！！
//			List<TblOrderCardMappingModel> cardModelList = tblOrderCardMappingDao.findByOrderMainIdOrCardNo(paramMap);
//			List<String> mainIdList = Lists.newArrayList();
//			if (cardModelList != null && cardModelList.size() > 0 && 
//					orderMainModelList != null && orderMainModelList.size() >0) {
//				for (TblOrderCardMappingModel cardModel : cardModelList) {
//					boolean sameFlag = true;
//					for (OrderMainModel mainModel : orderMainModelList) {
//						if (cardModel.getOrdermainId().equals(mainModel.getOrdermainId())) {
//							sameFlag = false;
//							break;
//						}
//					}
//					if (sameFlag) {//去重复
//						mainIdList.add(cardModel.getOrdermainId());
//					}
//				}
//				if (mainIdList != null && mainIdList.size() > 0) {
//					Map<String, Object> params = Maps.newHashMap();
//					params.put("orderMainIdList", mainIdList);
//					List<OrderMainModel> mainModelListForCard = orderMainDao.findOrdersByList(params);
//					orderMainModelList.addAll(mainModelListForCard);
//				}
//			}
			// donghb 0903 end
			response.setResult(orderMainModelList);
			return response;
		} catch (Exception e) {
			log.error("orderMain.time.query.error", Throwables.getStackTraceAsString(e));
			response.setError("orderMain.time.query.error");
			return response;
		}
	}

	/**
	 * 根据主订单号查询
	 *
	 * @param orderMainId
	 * @return
	 */
	@Override
	public Response<OrderMainModel> findByOrderMainId(String orderMainId) {
		Response<OrderMainModel> response = Response.newResponse();
		if (StringUtils.isEmpty(orderMainId)) {
			response.setError("orderMain.time.query.error");
			return response;
		}
		try {
			OrderMainModel orderMainModel = orderMainDao.findByOrderMainId(orderMainId);
			response.setResult(orderMainModel);
			return response;
		} catch (Exception e) {
			log.error("orderMain.time.query.error", Throwables.getStackTraceAsString(e));
			response.setError("orderMain.time.query.error");
			return response;
		}
	}

	/**
	 * insert主订单 接口MAL501
	 */
	@Override
	public Response<Integer> insertTblOrderMain(OrderMainModel orderMainModel) {
		Response<Integer> response = Response.newResponse();
		try {
			Integer updateFlg = orderMainManager.insert(orderMainModel);
			response.setResult(updateFlg);
			return response;
		} catch (Exception e) {
			log.error("orderMain.time.query.error", Throwables.getStackTraceAsString(e));
			response.setError("orderMain.time.query.error");
			return response;
		}
	}

	/**
	 * update主订单 接口MAL501
	 */
	@Override
	public Response<Integer> updateTblOrderMain(OrderMainModel orderMainModel) {
		Response<Integer> response = Response.newResponse();
		try {
			Integer updateFlg = orderMainManager.updateTblOrderMain(orderMainModel);
			response.setResult(updateFlg);
			return response;
		} catch (Exception e) {
			log.error("orderMain.time.query.error", Throwables.getStackTraceAsString(e));
			response.setError("orderMain.time.query.error");
			return response;
		}
	}

	/**
	 * 更新投递方式信息
	 * 
	 * @param orderMainModel
	 * @return
	 */
	@Override
	public Response<Integer> updateOrderMainAddr(OrderMainModel orderMainModel) {
		Response<Integer> response = Response.newResponse();
		try {
			Integer count = orderMainManager.updateOrderMainAddr(orderMainModel);
			response.setResult(count);
			return response;
		} catch (Exception e) {
			log.error("orderMain.updateOrderMainAddr.error", Throwables.getStackTraceAsString(e));
			response.setError("orderMain.updateOrderMainAddr.error");
			return response;
		}
	}
}
