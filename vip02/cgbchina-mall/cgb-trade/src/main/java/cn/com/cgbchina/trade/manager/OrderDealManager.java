package cn.com.cgbchina.trade.manager;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.trade.dao.OrderMainDao;
import cn.com.cgbchina.trade.dao.OrderOutSystemDao;
import cn.com.cgbchina.trade.dao.OrderSubDao;
import cn.com.cgbchina.trade.dao.TblOrderExtend1Dao;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderOutSystemModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.TblOrderExtend1Model;
import com.google.common.collect.Maps;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Map;

/**
 * Created by 11141021050225 on 2016/9/23.
 */
@Component
@Transactional
public class OrderDealManager {
    @Resource
    private OrderMainDao orderMainDao;
    @Resource
    private TblOrderExtend1Dao tblOrderExtend1Dao;
    @Resource
    private OrderOutSystemDao orderOutSystemDao;
    @Resource
    private OrderSubDao orderSubDao;

    public Integer updateLockedFlag(String ordermainId){
        return orderMainDao.updateLockedFlag(ordermainId);
    }

    public Integer insert(TblOrderExtend1Model tblOrderExtend1){
        return tblOrderExtend1Dao.insert(tblOrderExtend1);
    }
    @Transactional
    public Integer insert(OrderOutSystemModel orderOutSystem){
        return orderOutSystemDao.insert(orderOutSystem);
    }

    private static Map<String, String> sourceMap = Maps.newHashMap();

    public void updateSourceId(String sourceId, String orderMainId) {
        if (sourceMap.size() == 0) {
            makeSourceMap();
        }
        if (!sourceMap.containsKey(sourceId)) {
            return;
        }
        String sourceNm = sourceMap.get(sourceId);
        OrderMainModel orderMainModel = new OrderMainModel();
        orderMainModel.setOrdermainId(orderMainId);
        orderMainModel.setSourceId(sourceId);
        orderMainModel.setSourceNm(sourceNm);
        orderMainDao.updateSourceId(orderMainModel);

        OrderSubModel orderSubModel = new OrderSubModel();
        orderSubModel.setOrdermainId(orderMainId);
        orderSubModel.setSourceId(sourceId);
        orderSubModel.setSourceNm(sourceNm);
        orderSubDao.updateByOrderMainId(orderSubModel);
    }

    private Map<String, String> getSourceMap() {
        return sourceMap;
    }
    private void makeSourceMap() {
        // 渠道id00: 商城01: callcenter02: ivr渠道03: 手机商城
        sourceMap.put(Contants.CHANNEL_MALL_CODE, "商城");
        sourceMap.put(Contants.CHANNEL_CC_CODE, "CallCenter");
        sourceMap.put(Contants.CHANNEL_IVR_CODE, "IVR");
        sourceMap.put(Contants.CHANNEL_PHONE_CODE, "手机商城");
        sourceMap.put(Contants.CHANNEL_IVR_CODE, "短信");
        sourceMap.put(Contants.CHANNEL_APP_CODE, "APP");
        sourceMap.put(Contants.CHANNEL_MALL_WX_CODE, "广发银行(微信)");
        sourceMap.put(Contants.CHANNEL_CREDIT_WX_CODE, "广发信用卡(微信)");
    }

}
