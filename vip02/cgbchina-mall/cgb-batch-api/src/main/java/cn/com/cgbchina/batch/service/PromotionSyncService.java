package cn.com.cgbchina.batch.service;

import com.spirit.common.model.Response;

/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/7/15.
 */
public interface PromotionSyncService {
    /**
     * 同步db到redis
     * @return
     */
     Response<Boolean> syncDBtoRedis();

     /**
      * 同步db到redis Test用
      * @return
      */
     Response<Boolean> syncDBtoRedis(String... para);

     /**
      * 荷兰拍活动数据刷新
      * @return
      */
     Response<Boolean> batchProm();

     /**
      * 荷兰拍释放批处理
      *
      * geshuo 20160726
      */
     Response<Boolean> batchDutchAuctionRelease();

   /**
    *  荷兰拍单个订单释放库存操作
    * @return
     */
     Response<Boolean> batchAuctionStockRelease(String[] args);
}
