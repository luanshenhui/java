package cn.com.cgbchina.batch.dao;

import cn.com.cgbchina.batch.model.MallPromotionSaleInfoBatchDto;
import cn.com.cgbchina.batch.model.PromEntry;
import cn.com.cgbchina.batch.model.PromItemEntry;
import cn.com.cgbchina.batch.model.PromotionPeriodBatchModel;
import cn.com.cgbchina.batch.model.PromotionRedisBatchModel;
import com.google.common.base.Function;
import com.google.common.collect.Collections2;
import com.google.common.collect.Lists;
import com.spirit.redis.JedisTemplate;
import com.spirit.redis.dao.RedisBaseDao;
import com.spirit.util.KeyUtil;
import lombok.extern.slf4j.Slf4j;
import org.joda.time.LocalDateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.Pipeline;
import redis.clients.jedis.Transaction;
import redis.clients.jedis.Response;

import java.util.*;

/**
 * @author wenjia.hao
 * @version 1.0
 */
@Repository
@Slf4j
public class PromotionRedisBatchDao extends RedisBaseDao<PromotionRedisBatchModel> {
    private final DateTimeFormatter dateTimeFormat = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");

    @Autowired
    public PromotionRedisBatchDao(JedisTemplate jedisTemplate) {
        super(jedisTemplate);
    }

    public void syncDBtoRedis(final List<PromotionRedisBatchModel> list) {
        // 把所有的批处理送过来的数据 存到redis中

        jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
            @Override
            public void action(Jedis jedis) {
                Pipeline pipelined = jedis.pipelined();
                for (PromotionRedisBatchModel promotionRedisModel : list) {
                    Map<String, String> stringStringMap = stringHashMapper.toHash(promotionRedisModel);
                    pipelined.hmset(
                            KeyUtil.entityId(PromotionRedisBatchModel.class, Long.valueOf(promotionRedisModel.getId())),
                            stringStringMap);
                }
                pipelined.sync();
            }
        });
    }


    public void insertIdsByDate(final List<PromEntry> ids, final String date) {
        // 维护每天的活动集合，先删除旧数据，加入即时取得新数据 每天-活动列表
        jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
            @Override
            public void action(Jedis jedis) {
                jedis.del("prom:" + date);// 删除将要维护的键
                Pipeline pipelined = jedis.pipelined();
                for (PromEntry promEntry : ids) {
                    pipelined.rpush("prom:" + date, promEntry.getId() + "," + promEntry.getPromType() + ","
                            + LocalDateTime.fromDateFields(promEntry.getBeginDate()).toString(dateTimeFormat) + ","
                            + LocalDateTime.fromDateFields(promEntry.getEndDate()).toString(dateTimeFormat) + ","
                            + promEntry.getPeriodId());
                }
                pipelined.sync();
            }
        });

    }

    /**
     * 取得redis中所有活动
     */
    public Set<String> getAllIds() {
        return jedisTemplate.execute(new JedisTemplate.JedisAction<Set<String>>() {
            @Override
            public Set<String> action(Jedis jedis) {
                // 当前redis中存在的所有活动
                return jedis.smembers("prom:id:all");
            }
        });
    }

    /**
     * 删除不在使用的活动集合 删除一对一的活动本身 删除总id集合中的值
     *
     * @param ids
     */
    public void deletePromByIds(final Iterable<String> ids) {
        //扫描过期的活动本身的基本信息
        jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
            @Override
            public void action(Jedis jedis) {
                Pipeline pipelined = jedis.pipelined();
                for (String id : ids) {
                    pipelined.del(KeyUtil.entityId(PromotionRedisBatchModel.class, id));
                    pipelined.srem("prom:id:all", id);
                }
                pipelined.sync();
            }
        });

    }
    /**
     * 往总id集合中加入新id
     */
    public void insertAllPromIds(final Iterable<String> ids) {
        jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
            @Override
            public void action(Jedis jedis) {
                Pipeline pipelined = jedis.pipelined();
                for (String id : ids) {
                    pipelined.sadd("prom:id:all", id);
                }
                pipelined.sync();
            }
        });

    }

    /**
     * 根据活动ID 查询活动基本信息
     *
     * @param id
     * @return
     */
    public PromotionRedisBatchModel findPromById(final String id) {
        return jedisTemplate.execute(new JedisTemplate.JedisAction<PromotionRedisBatchModel>() {
            @Override
            public PromotionRedisBatchModel action(Jedis jedis) {
                Map<String, String> stringStringMap = jedis
                        .hgetAll(KeyUtil.entityId(PromotionRedisBatchModel.class, id));
                return stringHashMapper.fromHash(stringStringMap);
            }
        });
    }

    /**
     * 插入单品集合 一个单品对应的活动列表
     */
    public void insertItemList(final List<PromItemEntry> list, final String date) {
        // 维护活动单品与活动的一对多映射关系 value格式：活动ID、开始时间、结束时间、场次ID
        jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
            @Override
            public void action(Jedis jedis) {
                Pipeline pipelined = jedis.pipelined();
                for (PromItemEntry temp : list) {
                    String tempKey="prom:item:" + date + ":" + temp.getItemCode();
                    //删除旧的
                    pipelined.del(tempKey);
                    for (PromEntry promEntry : temp.getPromEntries()) {
                        pipelined.rpush(tempKey, promEntry.getId() + ","
                                + LocalDateTime.fromDateFields(promEntry.getBeginDate()).toString(dateTimeFormat) + ","
                                + LocalDateTime.fromDateFields(promEntry.getEndDate()).toString(dateTimeFormat) + ","
                                + promEntry.getPeriodId());
                    }
                }
                pipelined.sync();

            }
        });
        // 库中有多少单品就维护出来一个键 保存所有单品的值 一天一个所有单品
        final Collection<String> allItemCode = Collections2.transform(list, new Function<PromItemEntry, String>() {
            @Override
            public String apply(PromItemEntry input) {
                return input.getItemCode();
            }
        });
        // 插入当天所有的参加活动的单品id集合
        jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
            @Override
            public void action(Jedis jedis) {
                jedis.rpush("prom:item:all:" + date, allItemCode.toArray(new String[allItemCode.size()]));
            }
        });

    }

    /**
     * 取得栏位数据
     */
    public Map<String, String> findAuctionsFieldsByKey(final Integer no, final String promId, final String periodId) {
        return jedisTemplate.execute(new JedisTemplate.JedisAction<Map<String, String>>() {
            @Override
            public Map<String, String> action(Jedis jedis) {
                return jedis.hgetAll("prom:auctions:fields" + no + ":" + promId + ":" + periodId);
            }
        });
    }

    /**
     * 取得等候区数据
     */
    public List<String> findAuctionsRangeListByKey(final String promId, final String periodId) {
        return jedisTemplate.execute(new JedisTemplate.JedisAction<List<String>>() {
            @Override
            public List<String> action(Jedis jedis) {
                return jedis.lrange("prom:auctions:wait:" + promId + ":" + periodId, 0, -1);
            }
        });
    }

    /**
     * 插入栏位
     */
    public void insertAuctionsFields(final Integer no, final String promId,
                                     final String periodId, final Map<String, String> paramMap) {
        jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
            @Override
            public void action(Jedis jedis) {
                jedis.del("prom:auctions:fields" + no + ":" + promId + ":" + periodId);
                Transaction t = jedis.multi();
                // 新增数据
                t.hmset("prom:auctions:fields" + no + ":" + promId + ":" + periodId, paramMap);
                t.exec();
            }
        });
    }

    /**
     * 插入备选List
     */
    public void insertAuctionsRangeList(final String promId, final String periodId, final List<String> list) {
        jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
            @Override
            public void action(Jedis jedis) {

                jedis.del("prom:auctions:wait:" + promId + ":" + periodId);
                Pipeline pipelined = jedis.pipelined();
                for (String temp : list) {
                    pipelined.rpush("prom:auctions:wait:" + promId + ":" + periodId, temp);
                }
                pipelined.sync();
            }
        });
    }

    /**
     * 根据日期 查找日期-活动 映射结果
     *
     * @param date 指定日期
     * @return
     */
    public List<String> findPromIdListByDate(final String date) {

        return jedisTemplate.execute(new JedisTemplate.JedisAction<List<String>>() {
            @Override
            public List<String> action(Jedis jedis) {

                return jedis.lrange("prom:" + date, 0, -1);
            }
        });

    }

    public void delPromTogether(final String yesterday) {
        // 删除昨天活动的聚合键
        jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
            @Override
            public void action(Jedis jedis) {
                jedis.del("prom:" + yesterday);
            }
        });

    }

    /**
     * 删除所有单品
     *
     * @param yesterday
     */
    public void delItem(final String yesterday) {
        // 首先获得昨天的所有单品与活动的映射
        final List<String> yesterItemIds = jedisTemplate.execute(new JedisTemplate.JedisAction<List<String>>() {
            @Override
            public List<String> action(Jedis jedis) {
                return jedis.lrange("prom:item:all:" + yesterday, 0L, -1L);
            }
        });
        if(yesterItemIds.size() > 0) {
            jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
                @Override
                public void action(Jedis jedis) {
                    // 删除昨天的单品聚合
                    jedis.del("prom:item:all:" + yesterday);
                    // 删除昨天的所有的单品与活动的映射关系
                    Pipeline pipelined = jedis.pipelined();
                    for (String str : yesterItemIds) {
                        pipelined.del("prom:item:" + yesterday + ":" + str);
                    }
                    pipelined.sync();
                }
            });
        }
    }
    public void delStockAndHolland(final List<PromotionPeriodBatchModel> promotionPeriodBatchModels){
        final List<String> readyToDelete=Lists.newArrayList();
        for(PromotionPeriodBatchModel temp:promotionPeriodBatchModels){
            final Integer promId = temp.getPromotionId();
            final Integer periodId=temp.getId();
            //六个荷兰拍的键
            readyToDelete.add("prom:auctions:fields1:"+promId+":"+periodId);
            readyToDelete.add("prom:auctions:fields2:"+promId+":"+periodId);
            readyToDelete.add("prom:auctions:fields3:"+promId+":"+periodId);
            readyToDelete.add("prom:auctions:fields4:"+promId+":"+periodId);
            readyToDelete.add("prom:auctions:fields5:"+promId+":"+periodId);
            readyToDelete.add("prom:auctions:fields6:"+promId+":"+periodId);
            jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
                @Override
                public void action(Jedis jedis) {
                    Set<String> stockKeys = jedis.keys("prom-period-stock:" + promId + ":" + periodId+":"+"*");
                    readyToDelete.addAll(stockKeys);
                }
            });
        }
        log.info("待删除的库存相关的键{}",readyToDelete);
        //准备删除
        jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
            @Override
            public void action(Jedis jedis) {
                Pipeline pipelined = jedis.pipelined();
                for(String id:readyToDelete){
                    pipelined.del(id);
                }
                pipelined.sync();
            }
        });


    }

    /**
     * 删除个人限购相关键
     * @param promIds
     */
    public void delUserLimitAndSale (List<String> promIds){
      final    List<String> readyToDel= Lists.newArrayList();
        //取出待删集合
        for (final String str:promIds){
            jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
                @Override
                public void action(Jedis jedis) {
                    Set<String> promUserAll = jedis.smembers("prom-user-all:" + str);
                    readyToDel.addAll(promUserAll);
                    Set<String> promSale = jedis.smembers("prom-sale-all:"+str);
                    readyToDel.addAll(promSale);
                    readyToDel.add("prom-user-all:" + str);
                    readyToDel.add("prom-sale-all:"+str);
                }
            });
        }
        log.info("准备删除的个人限购相关键{}",readyToDel);
        //准备删除
        jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
            @Override
            public void action(Jedis jedis) {
                Pipeline pipelined = jedis.pipelined();
                for(String id:readyToDel){
                    pipelined.del(id);
                }
                pipelined.sync();
            }
        });






    }


    /**
     * 回滚库存
     *
     * @param promId   活动Id
     * @param periodId 场次id
     * @param itemCode 单品id
     * @param buyCount 数量
     * @param today    日期
     * @param userId   用户id
     */
    public void updatePromSaleInfo(final String promId, final String periodId, final String itemCode, final Long buyCount, final String today, final String userId) {
        final String generalItemKey = "prom-sale:" + promId + ":" + itemCode;    //这个单品整个活动内整体的销量
        final String dateItemKey = "prom-period-sale:" + promId + ":" + periodId + ":" + itemCode;// 单品 单场销量
        final String userLimitAll = "prom-user-limit:" + promId + ":" + userId;// 当前用户整个活动购买数量
        final String userLimitToday = "prom-period-user-limit:" + promId + ":" + periodId + ":" + userId;// 当前用户 当前场次购买数量

        //维护活动销量   跟活动本身有关系
        jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
            @Override
            public void action(Jedis jedis) {
                Transaction multi = jedis.multi();
                //一个活动 一个单品  一个销量
                multi.decrBy(generalItemKey, buyCount);//减掉单品销量
                // 单场销量
                multi.decrBy(dateItemKey, buyCount);//减掉单场销量
                //用户整个活动购买记录
                multi.decrBy(userLimitAll, buyCount);//减掉用户购买数量
                //用户单日内购买记录
                multi.decrBy(userLimitToday, buyCount);//减掉用户单日购买数量
                multi.exec();
            }
        });
    }

    /**
     * 根据活动ID、单品ID 获取已购买数量
     *
     * @param promId   活动ID
     * @param periodId 场次ID
     * @param itemCode 单品CODE
     */
    public String findPromBuyCount(final String promId, final String periodId, final String itemCode) {
        final String dateItemKey = "prom-period-sale:" + promId + ":" + periodId + ":" + itemCode;// 当场销量
        return jedisTemplate.execute(new JedisTemplate.JedisAction<String>() {
            @Override
            public String action(Jedis jedis) {
                return jedis.get(dateItemKey);
            }
        });
    }

    /**
     * 取得1-6栏位数据（荷兰拍）
     *
     * @param promId 活动ID
     * @param count 取得的栏位数（暂时使用3、6）
     */
    public List<Map<String, String>> findAuctionsFieldsByKeyForSix(final String promId, final String periodId,
                                                             final Integer count) {
        final List<Map<String, String>> resultList = new ArrayList<Map<String, String>>();
        final List<Response<Map<String, String>>> result = new ArrayList<Response<Map<String, String>>>();
        jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
            @Override
            public void action(Jedis jedis) {
                Pipeline pipelined = jedis.pipelined();
                for (int i = 1; i < count + 1; i++) {
                    Response<Map<String, String>> mapResponse = pipelined
                            .hgetAll("prom:auctions:fields" + i + ":" + promId + ":" + periodId);
                    result.add(mapResponse);
                }
                pipelined.sync();
                for (Response<Map<String, String>> response : result) {
                    resultList.add(response.get());
                }
            }
        });
        return resultList;
    }

    /**
     * 根据活动ID、单品ID 获取已购买数量
     *
     * @param promId 活动ID
     * @param periodId 场次ID
     * @param itemCode 单品CODE
     * @return
     */
    public MallPromotionSaleInfoBatchDto findPromBuyCountForbatch(final String promId, final String periodId,
                                                                  final String itemCode) {
        final String generalItemKey = "prom-sale:" + promId + ":" + itemCode;// 这个单品整个活动内整体的销量
        final String dateItemKey = "prom-period-sale:" + promId + ":" + periodId + ":" + itemCode;// 当场销量
        final String promStock = "prom-period-stock:" + promId + ":" + periodId + ":" + itemCode;// 当场库存 如果查询不到 说明没从
        // db把数据同步过来 第一次访问需要同步一下db 以后就是用这个了
        return jedisTemplate.execute(new JedisTemplate.JedisAction<MallPromotionSaleInfoBatchDto>() {
            @Override
            public MallPromotionSaleInfoBatchDto action(Jedis jedis) {
                Pipeline pipelined = jedis.pipelined();
                Response<String> generalItemSale = pipelined.get(generalItemKey);
                Response<String> dateItemSale = pipelined.get(dateItemKey);
                Response<String> promStockCount = pipelined.get(promStock);// 获取库存
                pipelined.sync();
                MallPromotionSaleInfoBatchDto mallPromotionSaleInfoDto = new MallPromotionSaleInfoBatchDto();
                // 如果无销量 那么销量将没有数据 要进行空判断
                if (generalItemSale.get() != null) {
                    mallPromotionSaleInfoDto.setSaleAmountAll(Integer.valueOf(generalItemSale.get()));
                }
                if (dateItemSale.get() != null) {
                    mallPromotionSaleInfoDto.setSaleAmountToday(Integer.valueOf(dateItemSale.get()));
                }
                if (promStockCount.get() != null) {
                    mallPromotionSaleInfoDto.setStockAmountTody(Long.valueOf(promStockCount.get()));
                }
                return mallPromotionSaleInfoDto;
            }
        });
    }

    public String getRedisStock(final String promId, final String periodId, final String itemCode){
     return    jedisTemplate.execute(new JedisTemplate.JedisAction<String>() {
            @Override
            public String action(Jedis jedis) {
                return   jedis.get("prom-period-stock:"+promId+":"+periodId+":"+itemCode);
            }
        });
    }
    public void setRedisStock(final String promId, final String periodId, final String itemCode,final String stockCount){
        jedisTemplate.execute(new JedisTemplate.JedisActionNoResult() {
            @Override
            public void action(Jedis jedis) {
                jedis.set("prom-period-stock:"+promId+":"+periodId+":"+itemCode,stockCount);
            }
        });
    }


}
