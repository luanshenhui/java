package cn.com.cgbchina.batch.centralizedControl;

import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.service.OrderStatusQueryService;
import cn.com.cgbchina.batch.util.SpringUtil;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by txy on 2016/7/26.
 */
@Slf4j
public class OrderStatusQueryControl extends BaseControl {
    /**
     * 计算最佳倍率
     * @param args
     */
    public static void main(String[] args) {
        OrderStatusQueryControl synControl = new OrderStatusQueryControl();
        synControl.setBatchName("企业网银状态回查");
        synControl.setArgs(args);
        synControl.exec();
    }
    @Override
    protected Response execService() throws BatchException {
        OrderStatusQueryService orderStatusQueryService = SpringUtil.getBean(OrderStatusQueryService.class);
        return orderStatusQueryService.orderStatusQuery();
    }
}
