package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.GiftRecommendationDto;
import cn.com.cgbchina.item.model.GoodsPointRegionModel;
import cn.com.cgbchina.item.model.GoodsRecommendationJfModel;
import com.spirit.common.model.Response;

import java.util.List;
import java.util.Map;


/**
 * Created by txy on 2016/8/1.
 */
public interface PointsGiftRecommendationService {
    /**
     * 创建积分区间
     *
     * @param goodsPointRegionModel
     * @return
     */
    public Response<Boolean> createPointsRegion(GoodsPointRegionModel goodsPointRegionModel);

    /**
     * 查询所有的积分区间
     *
     * @return
     */
    public Response<List<GoodsPointRegionModel>> findPointRegionAll();

    /**
     * 找出积分区间下的礼品
     *
     * @param goodsRecommendationJfModel
     * @return
     */
    public Response<List<Map<String,Object>>> findRecommendGift(GoodsRecommendationJfModel goodsRecommendationJfModel);

    /**
     * 新增积分区间下的礼品
     *
     * @param goodsRecommendationJfModel
     * @return
     */
    public Response<Boolean> createPointsGift(GoodsRecommendationJfModel goodsRecommendationJfModel);

    /**
     * 判断此积分区间是否可以推荐单品
     *
     * @param regionId
     * @return
     */
    public Response<Boolean> findPointsGiftCount(Integer regionId);

    /**
     * 推荐单品check
     * @param regionId
     * @param goodsXid
     * @return
     */
    public Response<GiftRecommendationDto> findGiftInfCheck(Integer regionId,String goodsXid,Integer minPoint, Integer maxPoint);

    /**
     * 根据goodsXid找出礼品名称
     * @param goodsXid
     * @return
     */
    public Response<GiftRecommendationDto> findGiftName(String goodsXid);

    /**
     * 删除礼品
     * @param goodsRecommendationJfModel
     * @return
     */
    public Response<Boolean> deleteGift(GoodsRecommendationJfModel goodsRecommendationJfModel);

    /**
     * 找出最大顺序
     * @return
     */
    public Response<Integer> findMaxGiftSeq();

    /**
     * 交换顺序
     * @param currentId
     * @param currentSort
     * @param changeId
     * @param changeSort
     * @return
     */
    public Response<Boolean> changeGiftSort(Integer currentId, String currentSort, Integer changeId, String changeSort);

    /**
     * 删除积分区间
     * @param param
     * @return
     */
    public Response<Boolean> deletePointsRegion(Map<String,Object> param);
}
