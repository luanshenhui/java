package cn.com.cgbchina.batch.dao;

import cn.com.cgbchina.batch.model.CommendRankBatchModel;
import cn.com.cgbchina.batch.model.HotRankModel;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * Created by tongxueying on 2016/8/24.
 */
@Repository
public class HotRankDao extends BaseDao {
    /**
     * 单品销量查询（热销商品排行）
     *
     * @param findParam
     * @return
     */
    public List<HotRankModel> findItemList(Map<String, Object> findParam) {
        return getSqlSession().selectList("HotRank.findItemList", findParam);
    }


    /**
     * 删除之前排行的数据
     *
     * @param param
     * @return
     */
    public Integer updateRank(Map<String, Object> param) {
        return getSqlSession().update("HotRank.updateRank", param);
    }

    /**
     * 插入广发商城热门排行
     *
     * @param createYgParam
     * @return
     */
    public Integer createRank(Map<String, Object> createYgParam) {
        return getSqlSession().insert("HotRank.insertRank", createYgParam);
    }

    /**
     * 单品销量查询（热门收藏排行）
     *
     * @param collectionParam
     * @return
     */
    public List<HotRankModel> findItemListForCollection(Map<String, Object> collectionParam) {
        return getSqlSession().selectList("HotRank.findItemListForCollection", collectionParam);
    }

    /**
     * 查询满足条件的供应商Id
     *
     * @param selectParam
     * @return
     */
    public List<String> findValidVendorId(Map<String, Object> selectParam) {
        return getSqlSession().selectList("HotRank.findValidVendorId", selectParam);
    }

    /**
     * 单品销量查询（供应商热销商品排行）
     *
     * @param selectParam
     * @return
     */
    public List<HotRankModel> findVendorHotSaleItem(Map<String, Object> selectParam) {
        return getSqlSession().selectList("HotRank.findVendorHotSaleItem", selectParam);
    }

    /**
     * 单品销量查询（供应商热门收藏排行）
     *
     * @param param
     * @return
     */
    public List<HotRankModel> findVendorHotCollectionItem(Map<String, Object> param) {
        return getSqlSession().selectList("HotRank.findVendorHotCollectionItem", param);
    }

    /**
     * 查询热销品类排行
     * @param paramMap 查询参数
     * @return 查询结果
     *
     * geshuo 20160902
     */
    public List<HotRankModel> findHotCategory(Map<String,Object> paramMap){
        return getSqlSession().selectList("HotRank.findHotCategory",paramMap);
    }

    /**
     * 批量插入通用排行表
     * @param modelList 待插入数据
     * @return 插入结果
     *
     * geshuo 20160902
     */
    public Integer insertBatchRank(List<CommendRankBatchModel> modelList){
        return getSqlSession().insert("HotRank.insertBatchCommendRank",modelList);
    }

    /**
     * 查询热销供应商
     * @param paramMap 查询参数
     * @return 查询结果
     *
     * geshuo 20160902
     */
    public List<HotRankModel> findHotVendor(Map<String,Object> paramMap){
        return getSqlSession().selectList("HotRank.findHotVendor",paramMap);
    }

    /**
     * 查询供应商用户数和订单成交数
     * @param paramMap 查询参数
     * @return 查询结果
     *
     * geshuo 20160902
     */
    public List<HotRankModel> findVendorCountData(Map<String,Object> paramMap){
        return getSqlSession().selectList("HotRank.findVendorCountData",paramMap);
    }

    /**
     * 判断是否已经统计过
     * @param paramMap 统计参数
     * @return 已存在的数据数量
     *
     * geshuo 20160908
     */
    public Long checkDataCount(Map<String,Object> paramMap){
        return getSqlSession().selectOne("HotRank.checkDataCount", paramMap);
    }

}
