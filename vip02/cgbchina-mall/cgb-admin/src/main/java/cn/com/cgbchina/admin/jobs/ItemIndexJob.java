package cn.com.cgbchina.admin.jobs;

import cn.com.cgbchina.admin.controller.AdminLeaders;
import cn.com.cgbchina.item.service.ItemIndexService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * Created by 11140721050130 on 2016/8/21.
 */
@Component
@Slf4j
public class ItemIndexJob {

    private final ItemIndexService indexService;

    private final AdminLeaders adminLeader;

    @Autowired
    public ItemIndexJob(ItemIndexService indexService, AdminLeaders adminLeader) {
        this.indexService = indexService;
        this.adminLeader = adminLeader;
    }

    /**
     * run every midnight
     */
    @Scheduled(cron = "0 0 0 * * ?")
    public void fullDump() {
        boolean isLeader = this.adminLeader.isLeader();
        if (!isLeader) {
            log.info("current admin leader is:{}, return redirect", adminLeader.currentLeaderId());
            return;
        }
        log.info("[CRON-JOB]search item refresh job begin");
        indexService.fullItemIndex();
        log.info("[CRON-JOB]search item refresh job ends");


    }

    /**
     * run every 15 minutes;
     */
    @Scheduled(cron = "0 0/15 * * * ?")  //每隔15分钟触发一次
    public void deltaDump() {
        boolean isLeader = this.adminLeader.isLeader();
        if (!isLeader) {
            log.info("current admin leader is:{}, return redirect", adminLeader.currentLeaderId());
            return;
        }

        log.info("[DELTA_DUMP_ITEM] item delta dump start");
        indexService.deltaDump(15);
        log.info("[DELTA_DUMP_ITEM] item delta finished");
    }
}
