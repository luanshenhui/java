package cn.com.cgbchina.batch.util;

import cn.com.cgbchina.batch.service.ApplyPaymentExportService;
import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.trade.dto.OrderQueryConditionDto;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.jms.mq.QueueMessageListener;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Created by zjq on 2016/12/26.
 */
@Slf4j
public class ApplypaymentExportListener extends QueueMessageListener<OrderQueryConditionDto> {
    @Autowired
    private ApplyPaymentExportService applyPaymentExportService;
    // 线程池
    private ExecutorService executorService = Executors.newCachedThreadPool();

    @Override
    public void onMsgListener(final OrderQueryConditionDto conditionDto) {
        executorService.submit(new Runnable() {
            public void run() {
                try {
                    Map<String, Object> param  =  assembledData(conditionDto);
                    applyPaymentExportService.deleteApplyFileExcel(conditionDto.getFindUserId());
                    applyPaymentExportService.applyPaymentExport(param);
                } catch (Exception e) {
                    log.error("SmsUploadMqListener eroor : {}" , Throwables.getStackTraceAsString(e));
                }
            }
        });
    }

    private Map<String, Object> assembledData(OrderQueryConditionDto conditionDto){
       Map<String, Object> map = Maps.newHashMap();
        //固定数值
        map.put("delFlag", Contants.DEL_INTEGER_FLAG_0);
        //传输数值转换
        if(!Strings.isNullOrEmpty(conditionDto.getStartTime())){
            map.put("startTime",conditionDto.getStartTime());
        }
        if(!Strings.isNullOrEmpty(conditionDto.getEndTime())){
            map.put("endTime",conditionDto.getEndTime());
        }
        if(!Strings.isNullOrEmpty(conditionDto.getSinStatusId())){
            map.put("sinStatusId",conditionDto.getSinStatusId());
        }
        if(!Strings.isNullOrEmpty(conditionDto.getOrdertypeId())){
            map.put("ordertypeId",conditionDto.getOrdertypeId());
        }
        if(!Strings.isNullOrEmpty(conditionDto.getCardno())){
            map.put("cardno",conditionDto.getCardno());
        }
        if(!Strings.isNullOrEmpty(conditionDto.getOrderId())){
            map.put("orderId",conditionDto.getOrderId());
        }
        if(!Strings.isNullOrEmpty(conditionDto.getVendorSnm())){
            map.put("vendorSnm",conditionDto.getVendorSnm());
        }
        if(!Strings.isNullOrEmpty(conditionDto.getOrdermainId())){
            map.put("ordermainId",conditionDto.getOrdermainId());
        }
        if(!Strings.isNullOrEmpty(conditionDto.getGoodsNm())){
            map.put("goodsNm",conditionDto.getGoodsNm());
        }
        if(!Strings.isNullOrEmpty(conditionDto.getRoleFlag())){
            map.put("roleFlag",conditionDto.getRoleFlag());
        }
        if(!Strings.isNullOrEmpty(conditionDto.getVendorId())){
            map.put("vendorId",conditionDto.getVendorId());
        }
        if(!Strings.isNullOrEmpty(conditionDto.getActTypeSecond())){
            map.put("actTypeSecond",conditionDto.getActTypeSecond());
        }
        if(!Strings.isNullOrEmpty(conditionDto.getCurStatusReceive())){
            map.put("curStatusReceive",conditionDto.getCurStatusReceive());
        }
        if(!Strings.isNullOrEmpty(conditionDto.getCurStatusBack())){
            map.put("curStatusBack",conditionDto.getCurStatusBack());
        }
        if(!Strings.isNullOrEmpty(conditionDto.getCurStatusUnBack())){
            map.put("curStatusUnBack",conditionDto.getCurStatusUnBack());
        }
        if(!Strings.isNullOrEmpty(conditionDto.getSystemType())){
            map.put("systemType",conditionDto.getSystemType());
        }
        if(!Strings.isNullOrEmpty(conditionDto.getTabNumber())){
            map.put("tabNumber",conditionDto.getTabNumber());
        }
        if(!Strings.isNullOrEmpty(conditionDto.getMiaoshaActionFlag())){
            map.put("miaoshaActionFlag",conditionDto.getMiaoshaActionFlag());
        }
        if(!Strings.isNullOrEmpty(conditionDto.getGoodssendFlag())){
            map.put("goodssendFlag",conditionDto.getGoodssendFlag());
        }
        if(!Strings.isNullOrEmpty(conditionDto.getTblFlag())){
            map.put("tblFlag",conditionDto.getGoodssendFlag());
        }
        if(!Strings.isNullOrEmpty(conditionDto.getFindUserId())){
            map.put("findUserId",conditionDto.getFindUserId());
        }
        return map;
    }
}
