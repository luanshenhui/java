package cn.com.cgbchina.batch.util;

import cn.com.cgbchina.batch.service.PromotionSyncService;
import com.spirit.jms.mq.QueueMessageListener;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * Created by lvzd on 2016/9/8.
 */
public class PromotionSyncMqListener extends QueueMessageListener<String> {
    @Autowired
    private PromotionSyncService promotionSyncService;

    @Override
    public void onMsgListener(String s) {
        if (s != null && !s.isEmpty()) {
            promotionSyncService.syncDBtoRedis(s);
        }
    }
}
