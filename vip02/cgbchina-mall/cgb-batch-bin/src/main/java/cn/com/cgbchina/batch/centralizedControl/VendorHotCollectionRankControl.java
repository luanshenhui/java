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
public class VendorHotCollectionRankControl extends BaseControl{
    /**
     * 供应商热门收藏排行
     * @param args
     */
    public static void main(String[] args) {
        VendorHotCollectionRankControl synControl = new VendorHotCollectionRankControl();
        synControl.setBatchName("供应商热门收藏排行");
        synControl.setArgs(args);
        synControl.exec();
    }
    @Override
    protected Response execService() throws BatchException {
        HotRankService hotRankService = SpringUtil.getBean(HotRankService.class);
        return hotRankService.hotCollectionRankForVendor();
    }
}
