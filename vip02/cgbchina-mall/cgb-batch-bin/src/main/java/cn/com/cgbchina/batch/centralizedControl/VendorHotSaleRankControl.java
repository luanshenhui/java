package cn.com.cgbchina.batch.centralizedControl;

import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.service.HotRankService;
import cn.com.cgbchina.batch.util.SpringUtil;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by txy on 2016/9/2.
 */
@Slf4j
public class VendorHotSaleRankControl extends BaseControl {
    /**
     * 供应商热销商品统计
     * @param args
     */
    public static void main(String[] args) {
        VendorHotSaleRankControl synControl = new VendorHotSaleRankControl();
        synControl.setBatchName("供应商热销商品统计");
        synControl.setArgs(args);
        synControl.exec();
    }
    @Override
    protected Response execService() throws BatchException {
        HotRankService hotRankService = SpringUtil.getBean(HotRankService.class);
        return hotRankService.hotSaleRankForVendor();
    }
}
