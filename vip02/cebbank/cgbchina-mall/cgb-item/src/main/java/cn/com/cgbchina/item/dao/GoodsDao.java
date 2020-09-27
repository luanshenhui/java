package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class GoodsDao extends SqlSessionDaoSupport {

    public Integer update(GoodsModel goods) {
        return getSqlSession().update("Goods.update", goods);
    }

    public Integer insert(GoodsModel goods) {
        return getSqlSession().insert("Goods.insert", goods);
    }

    public List<GoodsModel> findAll(Map<String, Object> params) {
        return getSqlSession().selectList("Goods.findAll", params);
    }

    public GoodsModel findById(String code) {
        return getSqlSession().selectOne("Goods.findById", code);
    }

    public Pager<GoodsModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("Goods.pageCount", params);
        if (total == 0) {
            return Pager.empty(GoodsModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
            paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<GoodsModel> data = getSqlSession().selectList("Goods.pager", paramMap);
        return new Pager<GoodsModel>(total, data);
    }

    /**
     * 根据条件查询商品数量
     * @param params
     * @return
     */
    public Long findGoodsCountByParams(Map<String, Object> params){
        return getSqlSession().selectOne("Goods.pageCount", params);
    }

    public Integer delete(GoodsModel goods) {
        return getSqlSession().delete("Goods.delete", goods);
    }

    public List<GoodsModel> findGoodsCount(Map<String, Object> params) {
        return getSqlSession().selectList("Goods.findGoodsCount", params);
    }

    public Integer findUpShelfGoodsCount(Map<String, Object> params){
        return getSqlSession().selectOne("Goods.findUpShelfGoodsCount",params);
    }

    public Integer findDownShelfGoodsCount(Map<String, Object> params){
        return getSqlSession().selectOne("Goods.findDownShelfGoodsCount",params);
    }
    public GoodsModel findDetailById(String code) {
        return getSqlSession().selectOne("Goods.findDetailById", code);
    }

    /**
     * 根据code模糊查询
     *
     * @param goodsName
     * @return
     */
    public List<String> findGoodsByGoodsName(String goodsName) {
        return getSqlSession().selectList("Goods.findGoodsByGoodsName", goodsName);
    }

    /**
     * 批量更新商品状态
     *
     * @param goodsModelList
     * @return
     */
    public Integer updateAllGoodsStatus(List<GoodsModel> goodsModelList) {

        return getSqlSession().update("Goods.updateAllGoodsStatus", goodsModelList);
    }

    /**
     * 根据供应商ID下架该供应商下所有渠道的所有商品
     *
     * @param vendorId
     * @return
     */
    public Integer updateChannelByVendorId(String vendorId) {
        return getSqlSession().update("Goods.updateChannelByVendorId", vendorId);
    }

    public List<GoodsModel> findByCodes(List goodsCodes) {
        return getSqlSession().selectList("Goods.findByCodes", goodsCodes);
    }

    public List<GoodsModel> getGoodsNameByItemId( List<ItemModel> itemModelList) {
        return getSqlSession().selectList("Goods.getGoodsNameByItemId", itemModelList);
    }

    /**
     * 根据类目，商品名称模糊查询商品
     *
     * @param goodsModel
     * @return
     */
    public List<String> findGoodsByGoodsNameLike(GoodsModel goodsModel) {
        return getSqlSession().selectList("Goods.findGoodsByGoodsNameLike", goodsModel);
    }

    /**
     * 获取当前供应商下可用商品codeList
     *
     * @param params
     * @return
     */

    public List<String> findGoodsInVendor(Map<String, Object> params) {
        return getSqlSession().selectList("Goods.findGoodsInVendor", params);
    }

    /**
     * 根据产品id查询商品（产品用）
     *
     * @param productId
     * @return
     * @author :tanliang
     * @time:2016-6-20
     */

    public List<GoodsModel> findGoodsByProductId(Long productId) {
        return getSqlSession().selectList("Goods.findGoodsByProductId", productId);
    }

    /**
     * 根据类目，商品名称，供应商名称，品牌 模糊查询商品
     *
     * @param params
     * @return
     */
    public List<GoodsModel> findGoodsListByGoodsNameLikeForProm(Map<String, Object> params) {
        return getSqlSession().selectList("Goods.findGoodsListByGoodsNameLikeForProm", params);
    }

    /**
     * 判断分区下是否有礼品
     *
     * @param code
     * @return
     * @author:tongxueying
     * @time:2016-6-28
     */
    public Long checkUsedPartition(String code) {
        Long total = getSqlSession().selectOne("Goods.checkUsedPartition", code);
        return total;
    }

    public List<GoodsModel> findGoodsListByConditions(Map<String,Object> params){
        return getSqlSession().selectList("Goods.findGoodsListByConditions",params);
    }
}