package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.manager.OrderStatusQueryManager;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created by Xiehongri on 2016/7/11.
 * 企业网银状态回查-商城
 */
@Service
@Slf4j
public class OrderStatusQueryServiceImpl implements OrderStatusQueryService {
    @Autowired
    private OrderStatusQueryManager orderStatusQueryManager;

    @Override
    public Response<Boolean> orderStatusQuery() {
        Response<Boolean> response = new Response<>();
        try{
            log.info("企业网银状态回查开始......");
            orderStatusQueryManager.orderStatusQuery();
            log.info("企业网银状态回查结束......");
            response.setResult(Boolean.TRUE);
            return response;
        } catch (BatchException e) {
            log.error("企业网银状态回查失败..... erro:{}", Throwables.getStackTraceAsString(e));
            response.setError(Throwables.getStackTraceAsString(e));
            return response;
        }
    }
}
