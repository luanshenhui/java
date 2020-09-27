package com.cebbank.ccis.cebmall.item.service.indexer;

import com.cebbank.ccis.cebmall.item.dto.ItemMakeDto;
import com.cebbank.ccis.cebmall.item.dto.ItemRichDto;
import com.cebbank.ccis.cebmall.item.model.ItemModel;
import com.google.common.util.concurrent.ThreadFactoryBuilder;
import com.spirit.search.SearchExecutor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.concurrent.*;

/**
 * 准实时的dump
 *
 * @author 11140721050130
 * @version 1.0
 * @created at 2016/7/4.
 */
@Lazy(true)
@Component
@Slf4j
public class ItemRealTimeIndexer extends ItemBaseIndexer {

    public static final String ITEM_INDEX_NAME = "items";
    public static final String ITEM_INDEX_TYPE = "item";

    private final SearchExecutor searchExecutor;

    private final ExecutorService executorService;

    @Autowired
    ItemRealTimeIndexer(SearchExecutor searchExecutor) {
        this.searchExecutor = searchExecutor;
        this.executorService = new ThreadPoolExecutor(2, 4, 60L, TimeUnit.MINUTES,
                new ArrayBlockingQueue<Runnable>(1000),
                new ThreadFactoryBuilder().setNameFormat("item-indexer-%d").build(),
                new RejectedExecutionHandler() {
                    @Override
                    public void rejectedExecution(Runnable runnable, ThreadPoolExecutor executor) {
                        IndexTask indexTask = (IndexTask) runnable;
                        log.error("item(code={}) index request is rejected", indexTask.getGoodsCode());
                    }
                });
    }
//
//    /**
//     * 批量
//     *
//     * @param goodCodes
//     * @param itemMakeDto
//     */
//    public void index(List<String> goodCodes) {
//        for (String goodsCode : goodCodes) {
//            index(goodsCode);
//        }
//    }

    /**
     * 单个
     *
     * @param itemMakeDto
     */
    public void index(ItemMakeDto itemMakeDto) {
        switch (itemMakeDto.getStatus()) {
            // 商品删除，则删除该商品索引
            case DELETED:
                ItemRichDto goodsModel = new ItemRichDto();
                goodsModel.setCode(itemMakeDto.getGoodsCode());
                searchExecutor.submit(ITEM_INDEX_NAME, ITEM_INDEX_TYPE, goodsModel, SearchExecutor.OP_TYPE.DELETE);
                break;
            // 下架同样调用实时索引，因为各渠道下架不影响其他渠道搜索
            case OFF_SHELF:
            case ON_SHELF:
                IndexTask task = new IndexTask(itemMakeDto);
                this.executorService.submit(task);
                break;
        }
    }

    public void index(String goodCode) {
        ItemMakeDto itemRichDto = new ItemMakeDto();
        itemRichDto.setGoodsCode(goodCode);
        IndexTask task = new IndexTask(itemRichDto);
        this.executorService.submit(task);
    }

    public void delete(List<String> goodCodes) {
        ItemMakeDto itemMakeDto = new ItemMakeDto();
        for (String goodCode : goodCodes) {
            itemMakeDto.setGoodsCode(goodCode);
            itemMakeDto.setDelete(true);
            IndexTask task = new IndexTask(itemMakeDto);
            this.executorService.submit(task);
        }
    }

    public void delete(String goodCode) {
        ItemMakeDto itemMakeDto = new ItemMakeDto();
        itemMakeDto.setGoodsCode(goodCode);
        itemMakeDto.setDelete(true);
        IndexTask task = new IndexTask(itemMakeDto);
        this.executorService.submit(task);
    }

    private class IndexTask implements Runnable {
        private ItemMakeDto itemMakeDto;
        private IndexTask(ItemMakeDto itemMakeDto) {
            this.itemMakeDto = itemMakeDto;
        }

        @Override
        public void run() {
            if (itemMakeDto.isDelete()) {
                ItemRichDto item = new ItemRichDto();
                item.setCode(itemMakeDto.getGoodsCode());
                searchExecutor.submit(ITEM_INDEX_NAME, ITEM_INDEX_TYPE, item, SearchExecutor.OP_TYPE.DELETE);
                return;
            }
            List<ItemModel> itemList = itemDao.findItemListByGoodsCode(itemMakeDto.getGoodsCode());
            for (ItemModel itemModel : itemList) {
                ItemRichDto richItem = itemIndexs.make(itemModel, itemMakeDto);
                searchExecutor.submit(ITEM_INDEX_NAME, ITEM_INDEX_TYPE, richItem, SearchExecutor.OP_TYPE.INDEX);
            }
        }

        private String getGoodsCode() {
            return itemMakeDto.getGoodsCode();
        }
    }

}
