package cn.com.cgbchina.item.indexer;

import cn.com.cgbchina.item.dao.ItemDao;
import com.spirit.search.ESClient;
import org.springframework.beans.factory.annotation.Autowired;

abstract class ItemBaseIndexer {

    @Autowired
    protected ESClient esClient;

    @Autowired
    protected ItemDao itemDao;
}
