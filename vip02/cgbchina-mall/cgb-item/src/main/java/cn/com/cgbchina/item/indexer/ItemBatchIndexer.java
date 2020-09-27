/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.indexer;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dao.GoodsDao;
import cn.com.cgbchina.item.dao.ItemDao;
import cn.com.cgbchina.item.dao.TblGoodsPaywayDao;
import cn.com.cgbchina.item.dto.ItemMakeDto;
import cn.com.cgbchina.item.dto.ItemRichDto;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import com.google.common.base.Function;
import com.google.common.base.Predicate;
import com.google.common.base.Stopwatch;
import com.google.common.base.Throwables;
import com.google.common.collect.FluentIterable;
import com.google.common.collect.Lists;
import com.spirit.common.model.Pager;
import lombok.extern.slf4j.Slf4j;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * @author 11140721050130
 * @version 1.0
 * @created at 2016/7/4.
 */
@Lazy(true)
@Component
@Slf4j
public class ItemBatchIndexer extends ItemBaseIndexer {

    private static final String INDEX_NAME = "items";
    private static final String INDEX_TYPE = "item";
    private static final int PAGE_SIZE = 500;

    private static final DateTimeFormatter DATE_TIME_FORMAT = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");

    @Autowired
    private ItemDao itemDao;
    @Autowired
    private static final ItemRichDto DUMB = new ItemRichDto();

    public void fullItemIndex() {
        log.info("[FULL_DUMP_ITEM] full item refresh start");
        Stopwatch stopwatch = Stopwatch.createStarted();
        String lastId = itemDao.maxId();  //scan from maxId+1
        int returnSize = PAGE_SIZE;
        int handled = 0;
        while (returnSize == PAGE_SIZE) {
            List<ItemModel> items = itemDao.fullDump(lastId, PAGE_SIZE);
            final List<String> invalidIds = Lists.newArrayList();
            if (!items.isEmpty()) {
                //handle all status except deleted items
                Iterable<ItemRichDto> valid = filterdValidItems(items, invalidIds);
                esClient.index(INDEX_NAME, INDEX_TYPE, valid);
                esClient.delete(INDEX_NAME, INDEX_TYPE, invalidIds);
                handled += items.size();
                lastId = items.get(items.size() - 1).getId();
                log.info("has indexed {} items,and last handled id is {}", handled, lastId);
                returnSize = items.size();
            } else {
                break;
            }
        }
        stopwatch.stop();
        log.info("[FULL_DUMP_ITEM] full item refresh end, took {} ms", stopwatch.elapsed(TimeUnit.MILLISECONDS));
    }

    /**
     * 15 分钟内更新的商品信息，批量构建索引
     *
     * @param interval 时间参数
     */
    public void deltaItemIndex(Integer interval) {
        log.info("[DELTA_DUMP_ITEM] item delta dump start");
        String lastUpdateTime = DATE_TIME_FORMAT.print(new DateTime().minusMinutes(interval));
        Stopwatch stopwatch = Stopwatch.createStarted();
        String maxCode = itemDao.maxId();  //scan from maxCode
        int returnSize = PAGE_SIZE;
        int handled = 0;
        while (returnSize == PAGE_SIZE) {
            List<ItemModel> items = itemDao.forDeltaDump(maxCode, lastUpdateTime, PAGE_SIZE);
            if (!items.isEmpty()) {
                List<String> invalidIds = Lists.newArrayList();
                Iterable<ItemRichDto> valid = filterdValidItems(items, invalidIds);

                esClient.index(INDEX_NAME, INDEX_TYPE, valid);
                esClient.delete(INDEX_NAME, INDEX_TYPE, invalidIds);
                handled += items.size();
                log.info("has indexed {} items,and last handled id is {}", handled, maxCode);
                returnSize = items.size();
            } else {
                break;
            }
        }
        stopwatch.stop();
        log.info("[DELTA_DUMP_ITEM] item delta finished,cost {} millis,handled {} items", stopwatch.elapsed(TimeUnit.MILLISECONDS), handled);
    }

    /**
     *批量更新索引用（全体构建， 每隔15分钟的查缺补漏）
     */
    private Iterable<ItemRichDto> filterdValidItems(final List<ItemModel> valid, final List<String> invalidIds) {
        return FluentIterable.from(valid).transform(new Function<ItemModel, ItemRichDto>() {
            @Override
            public ItemRichDto apply(ItemModel input) {
                try {
                    return itemIndexs.make(input, null);
                } catch (Exception e) {
                    log.error("can not make rich item for item (id={}), cause:{}", input.getId(), Throwables.getStackTraceAsString(e));
                    invalidIds.add(input.getId());
                    return DUMB;
                }
            }
        }).filter(new Predicate<ItemRichDto>() {
            @Override
            public boolean apply(ItemRichDto input) {
                return input.getId() != null;
            }
        });
    }

}
