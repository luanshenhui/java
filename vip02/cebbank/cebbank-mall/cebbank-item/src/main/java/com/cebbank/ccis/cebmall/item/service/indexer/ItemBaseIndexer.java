package com.cebbank.ccis.cebmall.item.service.indexer;

import com.cebbank.ccis.cebmall.item.dao.ItemDao;
import com.cebbank.ccis.cebmall.item.service.ItemIndexs;
import com.spirit.search.ESClient;
import org.springframework.beans.factory.annotation.Autowired;

abstract class ItemBaseIndexer {

    @Autowired
    protected ESClient esClient;

    @Autowired
    protected ItemDao itemDao;

    @Autowired
    protected ItemIndexs itemIndexs;
}
