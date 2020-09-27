package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.StringUtils;
import cn.com.cgbchina.trade.model.TblOrderHistoryModel;
import com.google.common.collect.Maps;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class TblOrderHistoryDao extends SqlSessionDaoSupport {

    public Integer update(TblOrderHistoryModel tblOrderHistory) {
        return getSqlSession().update("TblOrderHistoryModel.update", tblOrderHistory);
    }


    public Integer insert(TblOrderHistoryModel tblOrderHistory) {
        return getSqlSession().insert("TblOrderHistoryModel.insert", tblOrderHistory);
    }


    public List<TblOrderHistoryModel> findAll() {
        return getSqlSession().selectList("TblOrderHistoryModel.findAll");
    }


    public TblOrderHistoryModel findById(String orderId) {
        return getSqlSession().selectOne("TblOrderHistoryModel.findById", orderId);
    }


    public Pager<TblOrderHistoryModel> findByPage(Map<String, Object> params, int offset, int limit) {
        String startTime = (String) params.get("startTime");
        String endTime = (String) params.get("endTime");
        if (!StringUtils.isEmpty(startTime)){
            params.put("startTime", DateHelper.date2string(DateTime.parse(startTime, DateTimeFormat.forPattern(DateHelper.YYYY_MM_DD)).toDate(), DateHelper.YYYY_MM_DD_HH_MM_SS));
        }
        if (!StringUtils.isEmpty(endTime)){
            params.put("endTime",DateHelper.date2string(DateTime.parse(endTime, DateTimeFormat.forPattern(DateHelper.YYYY_MM_DD)).plusDays(1).toDate(),DateHelper.YYYY_MM_DD_HH_MM_SS));
        }
        Long total = getSqlSession().selectOne("TblOrderHistoryModel.count", params);
        if (total == 0) {
        return Pager.empty(TblOrderHistoryModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
        paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<TblOrderHistoryModel> data = getSqlSession().selectList("TblOrderHistoryModel.pagerByConditions", paramMap);
        return new Pager<TblOrderHistoryModel>(total, data);
    }

    public List<TblOrderHistoryModel> findAlReq(Map<String, Object> params) {
        String startTime = (String) params.get("startTime");
        String endTime = (String) params.get("endTime");
        if (!StringUtils.isEmpty(startTime)){
            params.put("startTime", DateHelper.date2string(DateTime.parse(startTime, DateTimeFormat.forPattern(DateHelper.YYYY_MM_DD)).toDate(),DateHelper.YYYY_MM_DD_HH_MM_SS));
        }
        if (!StringUtils.isEmpty(endTime)){
            params.put("endTime",DateHelper.date2string(DateTime.parse(endTime, DateTimeFormat.forPattern(DateHelper.YYYY_MM_DD)).plusDays(1).toDate(),DateHelper.YYYY_MM_DD_HH_MM_SS));
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
            paramMap.putAll(params);
        }
        List<TblOrderHistoryModel> data = getSqlSession().selectList("TblOrderHistoryModel.findAllReq", paramMap);
        return data;
    }
   //订单管理模糊查询
    public Pager<TblOrderHistoryModel> findLikeByPage(Map<String, Object> params, int offset, int limit) {
        String startTime = (String) params.get("startTime");
        String endTime = (String) params.get("endTime");
        if (!StringUtils.isEmpty(startTime)){
            params.put("startTime", DateHelper.date2string(DateTime.parse(startTime, DateTimeFormat.forPattern(DateHelper.YYYY_MM_DD)).toDate(),DateHelper.YYYY_MM_DD_HH_MM_SS));
        }
        if (!StringUtils.isEmpty(endTime)){
            params.put("endTime",DateHelper.date2string(DateTime.parse(endTime, DateTimeFormat.forPattern(DateHelper.YYYY_MM_DD)).plusDays(1).toDate(),DateHelper.YYYY_MM_DD_HH_MM_SS));
        }
        Long total = getSqlSession().selectOne("TblOrderHistoryModel.countLikePage", params);
        if (total == 0) {
            return Pager.empty(TblOrderHistoryModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
            paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<TblOrderHistoryModel> data = getSqlSession().selectList("TblOrderHistoryModel.pagerLike", paramMap);
        return new Pager<TblOrderHistoryModel>(total, data);
    }

    //供应商撤单管理历史数据分页查询
    public Pager<TblOrderHistoryModel> findLikeByPagePart(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("TblOrderHistoryModel.countLikePart", params);
        if (total == 0) {
            return Pager.empty(TblOrderHistoryModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
            paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<TblOrderHistoryModel> data = getSqlSession().selectList("TblOrderHistoryModel.pagerLikePart", paramMap);
        return new Pager<TblOrderHistoryModel>(total, data);
    }

    /**
     * 查询所有的订单历史，不带分页
     * @param params
     * @return
     */
    public List<TblOrderHistoryModel> findLike(Map<String, Object> params) {
        String startTime = (String) params.get("startTime");
        String endTime = (String) params.get("endTime");
        if (!StringUtils.isEmpty(startTime)){
            params.put("startTime", DateHelper.date2string(DateTime.parse(startTime, DateTimeFormat.forPattern(DateHelper.YYYY_MM_DD)).toDate(),DateHelper.YYYY_MM_DD_HH_MM_SS));
        }
        if (!StringUtils.isEmpty(endTime)){
            params.put("endTime",DateHelper.date2string(DateTime.parse(endTime, DateTimeFormat.forPattern(DateHelper.YYYY_MM_DD)).plusDays(1).toDate(),DateHelper.YYYY_MM_DD_HH_MM_SS));
        }
        Long total = getSqlSession().selectOne("TblOrderHistoryModel.countLike", params);
        if (total == 0) {
            return null;
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
            paramMap.putAll(params);
        }
        paramMap.put("offset", 0);
        paramMap.put("limit", total);
        List<TblOrderHistoryModel> data = getSqlSession().selectList("TblOrderHistoryModel.pagerLike", paramMap);
        return data;
    }

    public Integer delete(TblOrderHistoryModel tblOrderHistory) {
        return getSqlSession().delete("TblOrderHistoryModel.delete", tblOrderHistory);
    }

    public Integer updateById(Map<String, Object> dataMap) {
        return getSqlSession().update("TblOrderHistoryModel.updateByIds", dataMap);
    }

    public Integer updatePassById(Map<String, Object> dataMap) {
        return getSqlSession().update("TblOrderHistoryModel.updatePassById", dataMap);
    }

    public Integer updateRefuseById(Map<String, Object> dataMap) {
        return getSqlSession().update("TblOrderHistoryModel.updateRefuseById", dataMap);
    }

    public Pager<TblOrderHistoryModel> findLikeByPageForReq(Map<String, Object> params, int offset, int limit) {
        String startTime = (String) params.get("startTime");
        String endTime = (String) params.get("endTime");
        if (!StringUtils.isEmpty(startTime)){
            params.put("startTime", DateHelper.date2string(DateTime.parse(startTime, DateTimeFormat.forPattern(DateHelper.YYYY_MM_DD)).toDate(),DateHelper.YYYY_MM_DD_HH_MM_SS));
        }
        if (!StringUtils.isEmpty(endTime)){
            params.put("endTime",DateHelper.date2string(DateTime.parse(endTime, DateTimeFormat.forPattern(DateHelper.YYYY_MM_DD)).plusDays(1).toDate(),DateHelper.YYYY_MM_DD_HH_MM_SS));
        }
        //0元秒杀订单不作为检索对象
        params.put("actTypeSecond", Contants.PROMOTION_PROM_TYPE_STRING_30);
        //供应商请款订单状态 IN(已签收，退货申请，拒绝退货申请) 作为固定检索条件
        params.put("curStatusReceive",Contants.SUB_ORDER_STATUS_0310);
        params.put("curStatusBack",Contants.SUB_ORDER_STATUS_0334);
        params.put("curStatusUnBack",Contants.SUB_ORDER_STATUS_0335);
        Long total = getSqlSession().selectOne("TblOrderHistoryModel.countLikeForReq", params);
        if (total == 0) {
            return Pager.empty(TblOrderHistoryModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
            paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<TblOrderHistoryModel> data = getSqlSession().selectList("TblOrderHistoryModel.pagerLikeForReq", paramMap);
        return new Pager<TblOrderHistoryModel>(total, data);
    }

    public List<TblOrderHistoryModel> findAllForReq(Map<String, Object> params) {
        String startTime = (String) params.get("startTime");
        String endTime = (String) params.get("endTime");
        if (!StringUtils.isEmpty(startTime)){
            params.put("startTime", DateHelper.date2string(DateTime.parse(startTime, DateTimeFormat.forPattern(DateHelper.YYYY_MM_DD)).toDate(),DateHelper.YYYY_MM_DD_HH_MM_SS));
        }
        if (!StringUtils.isEmpty(endTime)){
            params.put("endTime",DateHelper.date2string(DateTime.parse(endTime, DateTimeFormat.forPattern(DateHelper.YYYY_MM_DD)).plusDays(1).toDate(),DateHelper.YYYY_MM_DD_HH_MM_SS));
        }
        //0元秒杀订单不作为检索对象
        params.put("actTypeSecond", Contants.ORDER_ACT_TYPE_SECOND);
        //供应商请款订单状态 IN(已签收，退货申请，拒绝退货申请) 作为固定检索条件
        params.put("curStatusReceive",Contants.SUB_ORDER_STATUS_0310);
        params.put("curStatusBack",Contants.SUB_ORDER_STATUS_0334);
        params.put("curStatusUnBack",Contants.SUB_ORDER_STATUS_0335);
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
            paramMap.putAll(params);
        }
        List<TblOrderHistoryModel> data = getSqlSession().selectList("TblOrderHistoryModel.findAllForReq", paramMap);
        return data;
    }

    public Pager<String> findMainIdLikeByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("TblOrderHistoryModel.countLikeMainId", params);
        if (total == 0) {
            return Pager.empty(String.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
            paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<String> data = getSqlSession().selectList("TblOrderHistoryModel.pagerLikeMainId", paramMap);
        return new Pager<String>(total, data);
    }

    public List<TblOrderHistoryModel> findByOrderMainId(String orderMainId) {
        return getSqlSession().selectList("TblOrderHistoryModel.findByOrderMainId", orderMainId);
    }

    /**
     * 获取商城筛选条件下的子订单
     * @param params
     * @return
     */
    public List<TblOrderHistoryModel> findAllSelection(Map<String, Object> params) {
        return getSqlSession().selectList("TblOrderHistoryModel.findAllSelection", params);
    }

	/**
	 * 根据主订单号查询tblorder_history所有子订单(未删除) niufw
	 * 
	 * @param orderMainId
	 * @return
	 */
	public List<TblOrderHistoryModel> findHistoryByorderMainId(String orderMainId) {
		return getSqlSession().selectList("TblOrderHistoryModel.findHistoryByorderMainId", orderMainId);
	}
    public Integer updateStatues(TblOrderHistoryModel tblOrderHistoryModel) {
        return getSqlSession().update("TblOrderHistoryModel.updateStatues", tblOrderHistoryModel);
    }


	/**
	 * Description : 返回CC分期商城订单
	 * @param params
	 * @return
	 */
	public List<TblOrderHistoryModel> findForCCIntergral(Map<String, Object> params) {
		return getSqlSession().selectList("TblOrderHistoryModel.findForCCIntergral", params);
	}
}
