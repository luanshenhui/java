package cn.com.cgbchina.batch.util;

import cn.com.cgbchina.batch.service.OrderExportService;
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
 * Created by lvzd on 2016/9/8.
 */
@Slf4j
public class OrderExportMqListener extends QueueMessageListener<OrderQueryConditionDto> {
    @Autowired
    private OrderExportService orderExportService;
    // 线程池
    private ExecutorService executorService = Executors.newCachedThreadPool();

    @Override
    public void onMsgListener(final OrderQueryConditionDto conditionDto) {
        executorService.submit(new Runnable() {
            public void run() {
                try {
                    Map<String, Object> param  =  assembledData(conditionDto);
                    orderExportService.deleteOrderExcel(conditionDto.getFindUserId(), conditionDto.getOrdertypeId());
                    orderExportService.runOrderExport(param);
                } catch (Exception e) {
                    log.error("SmsUploadMqListener eroor : {}" , Throwables.getStackTraceAsString(e));
                }
            }
        });
    }

    private Map<String, Object> assembledData(OrderQueryConditionDto conditionDto){
        // 构造返回值及参数
        Map<String, Object> paramMap = Maps.newHashMap();
        // 默认选择逻辑删除
        paramMap.put("delFlag", Contants.DEL_INTEGER_FLAG_0);
        // 判断订单账号是否为空
        if (!Strings.isNullOrEmpty(conditionDto.getOrderId())) {
            paramMap.put("orderId", conditionDto.getOrderId().trim());
        }
        // 判断订单类型是否为空
        if (!Strings.isNullOrEmpty(conditionDto.getGoodsType())) {
            paramMap.put("goodsType", conditionDto.getGoodsType());
        }
        // 判断分期类型为空
        if (!Strings.isNullOrEmpty(conditionDto.getOrdertypeId())) {
            paramMap.put("ordertypeId", conditionDto.getOrdertypeId());
        }
        // 判断订单类型为空
        if (!Strings.isNullOrEmpty(conditionDto.getCurStatusId())) {
            paramMap.put("curStatusId", conditionDto.getCurStatusId());
        }
        // 判断渠道是否为空
        if (!Strings.isNullOrEmpty(conditionDto.getSourceId())) {
            paramMap.put("sourceId", conditionDto.getSourceId());
        }
        //goodsId
        if (!Strings.isNullOrEmpty(conditionDto.getGoodsId())) {
            paramMap.put("goodsId",conditionDto.getGoodsId());
        }

        // 判断时间是否为空
        if (!Strings.isNullOrEmpty(conditionDto.getStartTime())) {
            paramMap.put("startTime", conditionDto.getStartTime());
        }
        if (!Strings.isNullOrEmpty(conditionDto.getEndTime())) {
            paramMap.put("endTime", conditionDto.getEndTime());
        }
        // 判断商品名称为空
        if (!Strings.isNullOrEmpty(conditionDto.getGoodsNm())) {
            paramMap.put("goodsNm", conditionDto.getGoodsNm().trim());
        }

        // 判断银行卡号为空
        if (!Strings.isNullOrEmpty(conditionDto.getCardno())) {
            paramMap.put("cardno", conditionDto.getCardno().trim());
        }
        // 判断客户名称为空
        if (!Strings.isNullOrEmpty(conditionDto.getMemberName())) {
            paramMap.put("memberName", conditionDto.getMemberName());
        }
        // 判断供应商为空
        if (!Strings.isNullOrEmpty(conditionDto.getVendorSnm())) {
            paramMap.put("vendorSnm", conditionDto.getVendorSnm().trim());
        }
        if (!Strings.isNullOrEmpty(conditionDto.getCustType())){
            paramMap.put("custType", conditionDto.getCustType().trim());
        }
        if (!Strings.isNullOrEmpty(conditionDto.getLimitFlag())){
            paramMap.put("limitFlag", conditionDto.getLimitFlag().trim());
        }
        if (!Strings.isNullOrEmpty(conditionDto.getFindUserId())){
            paramMap.put("findUserId",conditionDto.getFindUserId());
        }

        return paramMap;
    }
}
