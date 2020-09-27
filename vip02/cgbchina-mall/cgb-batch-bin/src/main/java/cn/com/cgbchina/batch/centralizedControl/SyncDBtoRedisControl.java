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
public class SyncDBtoRedisControl extends BaseControl {
    /**
     * 同步活动数据批处理
     * @param args
     */
    public static void main(String[] args) {
        SyncDBtoRedisControl synControl = new SyncDBtoRedisControl();
        synControl.setBatchName("同步活动数据批处理");
        synControl.setArgs(args);
        synControl.exec();
    }
    @Override
    protected Response execService() throws BatchException {
        String[] args = super.getArgs();
        PromotionSyncService promotionSyncService = SpringUtil.getBean(PromotionSyncService.class);
        return promotionSyncService.syncDBtoRedis(args);

    }
}
