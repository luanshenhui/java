package cn.com.cgbchina.batch.centralizedControl;

import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.service.PromotionSyncService;
import cn.com.cgbchina.batch.util.SpringUtil;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by txy on 2016/7/26.
 */
@Slf4j
public class BatchDutchAuctionReleaseControl extends BaseControl {
    /**
     * 计算最佳倍率
     * @param args
     */
    public static void main(String[] args) {
        BatchDutchAuctionReleaseControl synControl = new BatchDutchAuctionReleaseControl();
        synControl.setBatchName("荷兰拍释放");
        synControl.setArgs(args);
        synControl.exec();
    }
    @Override
    protected Response execService() throws BatchException {
        PromotionSyncService promotionSyncService = SpringUtil.getBean(PromotionSyncService.class);
        return promotionSyncService.batchDutchAuctionRelease();
    }
}
