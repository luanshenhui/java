package cn.com.cgbchina.trade.manager;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.trade.dao.OrderClearDao;
import cn.com.cgbchina.trade.dao.OrderSubDao;
import cn.com.cgbchina.trade.dao.TblOrderHistoryDao;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import com.google.common.collect.Maps;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by 11150721040343 on 16-4-29.
 */
@Component
@Transactional
public class RequestMoneyManager {
	@Autowired
	private OrderSubDao orderSubDao;
	@Autowired
	private TblOrderHistoryDao tblOrderHistoryDao;
	@Autowired
	private OrderClearDao orderClearDao;
	@Autowired
	private OrderDodetailManger orderDodetailManger;

	/**
	 * 根据orderId更新请款状态(供应商请款申请)
	 * 
	 * @param list
	 * @return
	 */
	public Integer updateById(List<String> list,List<OrderDoDetailModel> ordeOderDoDetailModels) {
		Map<String, Object> dataMap = Maps.newHashMap();
		dataMap.put("list", list);
		dataMap.put("sinStatusNm", Contants.SUB_SIN_STATUS_Nm_0332);
		orderDodetailManger.insertForReq(ordeOderDoDetailModels);
		tblOrderHistoryDao.updateById(dataMap);
		return orderSubDao.updateById(dataMap);
	}

	/**
	 * 根据orderId更新请款状态（运营商拒绝请款）
	 * 
	 * @param dataMap
	 * @return
	 */
	public Integer updateRefuseById(HashMap<String, Object> dataMap) {
		dataMap.put("sinStatusNm", Contants.SUB_SIN_STATUS_Nm_0333);
		tblOrderHistoryDao.updateRefuseById(dataMap);
		//插入历史表
		orderDodetailManger.insertForReq((List) dataMap.get("orderDoDetailModelList"));
		return orderSubDao.updateRefuseById(dataMap);
	}

	/**
	 * 根据orderId更新请款状态（运营商同意请款）
	 * 
	 * @param dataMap
	 * @return
	 */
	public Integer updatePassById(HashMap<String, Object> dataMap) {
		dataMap.put("sinStatusNm", Contants.SUB_SIN_STATUS_Nm_0350);
		tblOrderHistoryDao.updatePassById(dataMap);
		//插入历史表
		orderDodetailManger.insertForReq((List) dataMap.get("orderDoDetailModelList"));
		orderClearDao.insertBatch((List)dataMap.get("orderClearModelList"));
		return orderSubDao.updatePassById(dataMap);
	}
}
