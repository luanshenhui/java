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
public class BatchPromControl extends BaseControl {
    /**
     * 计算最佳倍率
     * @param args
     */
    public static void main(String[] args) {
        BatchPromControl synControl = new BatchPromControl();
        synControl.setBatchName("荷兰拍实时");
        synControl.setArgs(args);
        synControl.exec();
    }
    @Override
    protected Response execService() throws BatchException {
        PromotionSyncService promotionSyncService = SpringUtil.getBean(PromotionSyncService.class);
        return promotionSyncService.batchProm();
    }
}
