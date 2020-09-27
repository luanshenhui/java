/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.batch.service.impl;

import cn.com.cgbchina.batch.service.EsCreateIndexAllService;
import cn.com.cgbchina.item.service.ItemIndexService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author A111503210500871
 * @version 1.0
 * @Since 2016/7/13
 */
@Slf4j
@Service
public class EsCreateIndexAllServiceImpl implements EsCreateIndexAllService {

    @Autowired
    private ItemIndexService itemIndexService;

    /**
     * 批量创建索引
     */
    public void createIndexAll(){
        log.info("Elasticsearch:Batch:Service CreateAllIndex by Batch Start");
        try{
            itemIndexService.fullItemIndex();
        }catch(Exception e){
            log.info("Elasticsearch:Batch:Service CreateAllIndex by Batch Error {}",e);
            e.printStackTrace();
        }
        log.info("Elasticsearch:Batch:Service CreateAllIndex by Batch End");

    }
}

