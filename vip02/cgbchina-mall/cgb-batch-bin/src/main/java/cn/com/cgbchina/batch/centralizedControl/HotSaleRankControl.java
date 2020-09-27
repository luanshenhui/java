package cn.com.cgbchina.batch.centralizedControl;

import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.service.HotRankService;
import cn.com.cgbchina.batch.util.SpringUtil;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by txy on 2016/8/26.
 */
@Slf4j
public class HotSaleRankControl extends BaseControl {
    /**
     * 热销商品排行计算
     * @param args
     */
    public static void main(String[] args) {
        HotSaleRankControl synControl = new HotSaleRankControl();
        synControl.setBatchName("热销商品排行计算");
        synControl.setArgs(args);
        synControl.exec();
    }
    @Override
    protected Response execService() throws BatchException {
        HotRankService hotRankService = SpringUtil.getBean(HotRankService.class);
        return hotRankService.hotSaleRank();
    }
}
