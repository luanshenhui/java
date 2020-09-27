/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.batch.jobs;

import cn.com.cgbchina.batch.service.BatchOrderService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * @author 11140721050130
 * @version 1.0
 * @created at 2016/7/10.
 */
@Component
@Slf4j
public class BatchCancelOrderJob {

    @Autowired
    private BatchOrderService batchOrderService;
    /**
     * run time
     */
    @Scheduled(cron = "0 0/3 * * * ?")
    public void batchUpdate() {
        log.info("调用废单处理开始。");
        batchOrderService.overdueOrderProc();
        log.info("调用废单处理结束。");
    }

}
