package cn.com.cgbchina.batch.dao;

import cn.com.cgbchina.batch.model.ApplyPayModel;
import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.StringUtils;
import com.google.common.collect.Maps;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * Created by zjq on 2016/12/26.
 */
@Repository
public class ApplyPaymentExportDao extends SqlSessionDaoSupport {
    public List<ApplyPayModel> findAllForReq(Map<String, Object> params) {
        String tblFlag = (String)params.get("tblFlag");
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
        List<ApplyPayModel> data = null;
        if ("1".equals(tblFlag)) {
            data = getSqlSession().selectList("ApplyPayment.findHisForReq", paramMap);
        }else {
            data = getSqlSession().selectList("ApplyPayment.findOrdForReq", paramMap);
        }
        return data;
    }

    public List<ApplyPayModel> findAlReq(Map<String, Object> params) {
        String tblFlag = (String)params.get("tblFlag");
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
        List<ApplyPayModel> data = null;
        if ("1".equals(tblFlag)) {
            data = getSqlSession().selectList("ApplyPayment.findHisReq", paramMap);
        }else {
            data = getSqlSession().selectList("ApplyPayment.findOrdReq", paramMap);
        }
        return data;
    }
}
