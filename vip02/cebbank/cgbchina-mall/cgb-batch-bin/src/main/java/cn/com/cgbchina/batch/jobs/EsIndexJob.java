/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.batch.jobs;

import cn.com.cgbchina.batch.service.EsCreateIndexAllService;
import cn.com.cgbchina.common.utils.DateHelper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * @author A111503210500871
 * @version 1.0
 * @Since 2016/7/13
 */
@Component
@Slf4j
public class EsIndexJob {

    @Autowired
    private EsCreateIndexAllService esCreateIndexAllService;

    /**
     * 批量创建索引
     */
    @Scheduled(cron = "0 0/59 * * * ?")
    public void batchCreateIndexAll(){
        log.info("Elasticsearch:Batch createIndexAll Start at:{}", DateHelper.getCurrentTime());
        try{
            esCreateIndexAllService.createIndexAll();
        }catch(Exception e){
            log.error("Elasticsearch:Batch createIndexAll Error {}", e);
        }

        log.info("Elasticsearch:Batch createIndexAll End at:{}", DateHelper.getCurrentTime());
    }
}

