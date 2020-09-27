/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.service;

import cn.com.cgbchina.common.utils.LocalHostUtil;
import cn.com.cgbchina.item.dto.ItemMakeDto;
import cn.com.cgbchina.item.indexer.ItemBatchIndexer;
import cn.com.cgbchina.item.indexer.ItemRealTimeIndexer;
import cn.com.cgbchina.item.model.ItemModel;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author 11140721050130
 * @version 1.0
 * @created at 2016/7/5.
 */
@Service
@Slf4j
public class ItemIndexServiceImpl implements ItemIndexService {
    private final ItemBatchIndexer itemBatchIndexer;
    private final ItemRealTimeIndexer itemRealTimeIndexer;

    @Autowired
    public ItemIndexServiceImpl(ItemBatchIndexer itemBatchIndexer,
                                ItemRealTimeIndexer itemRealTimeIndexer) {
        this.itemBatchIndexer = itemBatchIndexer;
        this.itemRealTimeIndexer = itemRealTimeIndexer;
    }

    /**
     * 全量索引
     */
    @Override
    public void fullItemIndex() {
        try {
            itemBatchIndexer.fullItemIndex();
        } catch (Exception e) {
            log.error("failed to fullItemIndex", e);
        }
    }

    @Override
    public Response<Boolean> deltaDump(Integer interval) {
        Response<Boolean> result = new Response<>();
        try {
            itemBatchIndexer.deltaItemIndex(interval);
            result.setResult(Boolean.TRUE);
        } catch (Exception e) {
            log.error("failed to full dump item", e);
            result.setResult(Boolean.FALSE);
        }
        return result;
    }

//    @Override
//    public void deltaItemIndex(List<ItemModel> itemList) {
//        try {
//            // 先用循环，稍后改造
//            ItemMakeDto itemMakeDto = new ItemMakeDto();
//            for (ItemModel itemModel : itemList) {
//                itemMakeDto.setGoodsCode(itemModel.getGoodsCode());
//                itemRealTimeIndexer.index(itemMakeDto);
//            }
//        } catch (Exception e) {
//            log.error("failed to deltaItemIndex", e);
//        }
//    }

}
