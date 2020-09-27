package cn.com.cgbchina.item.indexer;

import cn.com.cgbchina.item.dao.GoodsDao;
import cn.com.cgbchina.item.dao.ItemDao;
import cn.com.cgbchina.item.service.ItemIndexs;
import com.spirit.search.ESClient;
import org.springframework.beans.factory.annotation.Autowired;

abstract class ItemBaseIndexer {

    @Autowired
    protected ESClient esClient;

    @Autowired
    protected ItemDao itemDao;

    @Autowired
    protected GoodsDao goodsDao;

    @Autowired
    protected ItemIndexs itemIndexs;
}
