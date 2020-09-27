package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderQueryModel;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class OrderMainDao extends SqlSessionDaoSupport {

	public Integer update(OrderMainModel orderMainModel) {
		return getSqlSession().update("OrderMain.update", orderMainModel);
	}

	public Integer updateSourceId(OrderMainModel orderMainModel) {
		return getSqlSession().update("OrderMain.updateSourceId", orderMainModel);
	}

	public Integer insert(OrderMainModel orderMainModel) {
		orderMainModel.setCreateTimeStr(DateHelper.date2string(orderMainModel.getCreateTime(), DateHelper.YYYY_MM_DD_HH_MM_SS));
		orderMainModel.setModifyTimeStr(DateHelper.date2string(orderMainModel.getCreateTime(), DateHelper.YYYY_MM_DD_HH_MM_SS));
		return getSqlSession().insert("OrderMain.insert", orderMainModel);
	}

	public List<OrderMainModel> findAll() {
		return getSqlSession().selectList("OrderMain.findAll");
	}

	public OrderMainModel findById(String ordermainId) {
		return getSqlSession().selectOne("OrderMain.findById", ordermainId);
	}

	public OrderMainModel findByIdUnion(String ordermainId) {
		return getSqlSession().selectOne("OrderMain.findByIdUnion", ordermainId);
	}

	public Pager<OrderMainModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("OrderMain.count", params);
		if (total == 0) {
			return Pager.empty(OrderMainModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<OrderMainModel> data = getSqlSession().selectList("OrderMain.pager", paramMap);
		return new Pager<OrderMainModel>(total, data);
	}

	public Integer delete(OrderMainModel orderMainModel) {
		return getSqlSession().delete("OrderMain.delete", orderMainModel);
	}

	public List<OrderMainModel> findByOrderMainIds(Map<String, Object> params) {
		return getSqlSession().selectList("OrderMain.selectByOrdermainIds", params);
	}

	public List<String> findOrderMainIdById(String orderMainId) {
		return getSqlSession().selectList("OrderMain.findOrderMainIdById", orderMainId);
	}

	public Integer updateLockedFlag(String ordermainId) {
		return getSqlSession().update("OrderMain.updateLockedFlag", ordermainId);
	}

	public List<OrderMainModel> findCheckAccMain(String create_date) {
		return getSqlSession().selectList("OrderMain.findCheckAccOrderMain", create_date);
	}

	public List<OrderMainModel> findCCCheckAccOrder(String create_date) {
		return getSqlSession().selectList("OrderMain.findCCCheckAccOrder", create_date);
	}

	public List<OrderMainModel> findJfList() {
		return getSqlSession().selectList("OrderMain.findJfList");
	}

	public Integer updateCheckStatus(String create_date) {
		return getSqlSession().update("OrderMain.updateCheckStatus", create_date);
	}

	public List<OrderMainModel> findCreatDate() {
		return getSqlSession().selectList("OrderMain.findCreatDate");
	}

	public List<OrderMainModel> findOrdersByList(Map<String, Object> params) {
		return getSqlSession().selectList("OrderMain.findOrdersByList", params);
	}

	/**
	 * 获取未删除OrderMainModel by ordermainId
	 * 
	 * @param ordermainId
	 * @return
	 */
	public OrderMainModel findByOrderMainId(String ordermainId) {
		return getSqlSession().selectOne("OrderMain.findByOrderMainId", ordermainId);
	}

	/**
	 * MAL105 CC积分商城订单列表查询接口 niufw
	 * 
	 * @param params
	 * @return
	 */
	public List<OrderMainModel> findForCC(Map<String, Object> params) {
		return getSqlSession().selectList("OrderMain.findForCC", params);
	}

	public Integer updateOrderCardNoForMain(String ordermainId, String payAccountNo) {
		Map<String, Object> params = Maps.newHashMap();
		params.put("ordermainId", ordermainId);
		params.put("payAccountNo", payAccountNo);
		return getSqlSession().update("OrderMain.updateOrderCardNoForMain", params);
	}

	public Integer updateorderMainStatusUnderControl(Map<String, Object> params) {
		return getSqlSession().update("OrderMain.updateorderMainStatusUnderControl", params);
	}

	/**
	 * MAL502更新主订单状态(上边的update用不了，mapper问题) niufw
	 *
	 * @param orderMainModel
	 * @return
	 */
	public Integer updateForMAL502(OrderMainModel orderMainModel) {
		return getSqlSession().update("OrderMain.updateForMAL502", orderMainModel);
	}

	/**
	 * MAL501
	 */
	public Integer updateTblOrderMain(OrderMainModel orderMainModel) {
		return getSqlSession().update("OrderMain.updateTblOrderMain", orderMainModel);
	}

	public List<String> findOrderMainIdByAcceptedNo(String acceptedNo) {
		return getSqlSession().selectList("OrderMain.findOrderMainIdByAcceptedNo", acceptedNo);
	}

	public Integer updateOrderMainStatus(OrderMainModel orderMainModel) {
		return getSqlSession().update("OrderMain.updateOrderMainStatus",orderMainModel);
	}

	/**
	 * MAL109 订单投递信息修改
	 * @param orderMainModel
	 * @return
	 */
	public Integer updateOrderMainAddr(OrderMainModel orderMainModel) {
		return getSqlSession().update("OrderMain.updateOrderMainAddr",orderMainModel);
	}

	/**
	 * MAL401更新主订单状态(上边的update用不了，mapper问题) niufw
	 *
	 * @param orderMainModel
	 * @return
	 */
	public Integer updateForMAL401(OrderMainModel orderMainModel) {
		return getSqlSession().update("OrderMain.updateForMAL401", orderMainModel);
	}

	/**
	 * MAL113 查询订单信息
	 * @param params
	 * @return
	 */
	public List<String> findOrderMainfor113(Map<String,Object> params){
		return getSqlSession().selectList("OrderMain.findOrderMainfor113",params);
	}
	
	
	/**
	 * MAL308使用 根据证件号 查询客户号
	 * 
	 * */
	public List<String> findCreateOperNoByCertNo(String certNo){
	    return getSqlSession().selectList("OrderMain.findCreateOperNoByCertNo",certNo);
	}

}