package cn.com.cgbchina.batch.centralizedControl;

import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.service.OpsOrderProgressSearchService;
import cn.com.cgbchina.batch.util.SpringUtil;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by txy on 2016/7/26.
 */
@Slf4j
public class OpsOrderProgressSearchControl extends BaseControl {
    /**
     * OPS订单状态查询服务
     * @param args
     */
    public static void main(String[] args) {
        OpsOrderProgressSearchControl synControl = new OpsOrderProgressSearchControl();
        synControl.setBatchName("OPS订单状态查询服务");
        synControl.setArgs(args);
        synControl.exec();
    }
    @Override
    protected Response execService() throws BatchException {
        OpsOrderProgressSearchService opsOrderProgressSearchService = SpringUtil.getBean(OpsOrderProgressSearchService.class);
        return opsOrderProgressSearchService.sendOPSOrderToBPS();
    }
}
