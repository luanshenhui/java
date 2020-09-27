package cn.com.cgbchina.batch.service;

import com.spirit.common.model.Response;

import java.io.IOException;

/**
 * Created by tongxueying on 2016/8/23.
 */
public interface HotRankService {
    /**
     * 热门销售统计排行
     *
     */
    Response<Boolean> hotSaleRank();

    /**
     * 热门收藏排行
     *
     * @return
     */
    Response<Boolean> hotCollectionRank();

    /**
     * 供应商热销统计排行
     *
     * @return
     */
    Response<Boolean> hotSaleRankForVendor();

    /**
     * 供应商热门收藏排行
     * @return
     */
    Response<Boolean> hotCollectionRankForVendor();

    /**
     * 热销品类统计
     * @return 执行结果
     *
     * geshuo 20160902
     */
    Response<Boolean> countHotCategory();

    /**
     * 通用统计（供应商销量统计）
     * @return 执行结果
     *
     * geshuo 20160902
     */
    Response<Boolean> countHotVendor();

    /**
     * 通用统计（供应商一周数据统计）
     * @return 执行结果
     *
     * geshuo 20160902
     */
    Response<Boolean> countVendorWeekSale();

}
