package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.ItemModel;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class ItemDao extends SqlSessionDaoSupport {

    public Integer update(ItemModel item) {
        return getSqlSession().update("Item.update", item);
    }

    public Integer updateItem(ItemModel item) {
        return getSqlSession().update("Item.updateItem", item);
    }

    public Integer insert(ItemModel item) {
        return getSqlSession().insert("Item.insert", item);
    }

    public List<ItemModel> findAll() {
        return getSqlSession().selectList("Item.findAll");
    }

    public ItemModel findById(String code) {
        return getSqlSession().selectOne("Item.findById", code);
    }

    public Pager<ItemModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = (long) getSqlSession().selectList("Item.findAll", params).size();
        if (total == 0) {
            return Pager.empty(ItemModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
            paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<ItemModel> data = getSqlSession().selectList("Item.pager", paramMap);
        return new Pager<ItemModel>(total, data);
    }

    public Pager<ItemModel> findByPageExtra(Map<String, Object> params, int offset, int limit) {
        Long total = (long) getSqlSession().selectList("Item.findAllExtra", params).size();
        if (total == 0) {
            return Pager.empty(ItemModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
            paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<ItemModel> data = getSqlSession().selectList("Item.pagerExtra", paramMap);
        return new Pager<ItemModel>(total, data);
    }

    public Integer delete(ItemModel item) {
        return getSqlSession().delete("Item.delete", item);
    }

    /**
     * 根据商品编码查询相应单品的所有信息
     *
     * @param goodsCode
     * @return
     */
    public List<ItemModel> findItemDetailByGoodCode(String goodsCode) {
        return getSqlSession().selectList("Item.findItemDetailByGoodCode", goodsCode);
    }

    /**
     * 根据商品或单品编码查询单品列表
     *
     * @param code
     * @return
     */
    public List<ItemModel> findItemListByGoodsOrItemCode(String code) {
        return getSqlSession().selectList("Item.findItemListByGoodsOrItemCode", code);
    }

    /**
     * 根据商品编码列表查询单品列表
     *
     * @param goodsCodeList
     * @return
     */
    public List<ItemModel> findItemListByGoodsCodeList(List goodsCodeList) {
        return getSqlSession().selectList("Item.findItemListByGoodsCodeList", goodsCodeList);
    }

    /**
     * 根据单品编码列表查询单品列表
     *
     * @param itemCodes
     * @return
     */
    public List<ItemModel> findByCodes(List itemCodes) {
        return getSqlSession().selectList("Item.findByCodes", itemCodes);
    }

    public List<ItemModel> findNoCode(List itemCodes) {
        return getSqlSession().selectList("Item.findNoCode", ImmutableMap.of("list", itemCodes));
    }

    /**
     * 根据itemCode查询数据
     *
     * @param itemCode
     * @return add by liuhan
     */
    public ItemModel findItemDetailByCode(String itemCode) {
        return getSqlSession().selectOne("Item.findItemDetailByCode", itemCode);
    }

    /**
     * 批量插入单品信息
     *
     * @param itemList
     * @return
     */
    public Integer insertBatch(List itemList) {
        return getSqlSession().insert("Item.insertBatch", itemList);
    }

    /**
     * 查询置顶商品
     *
     * @return add by liuhan
     */
    public List<ItemModel> findAllstickFlag() {
        return getSqlSession().selectList("Item.findAllstickFlag");
    }

    /**
     * 查询置顶商品
     *
     * @return add by liuhan
     */
    public Pager<ItemModel> findAllstickFlagPager(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("Item.count", params);
        if (total == 0) {
            return Pager.empty(ItemModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
            paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<ItemModel> data = getSqlSession().selectList("Item.findAllstickFlagPager", paramMap);
        return new Pager<ItemModel>(total, data);
    }

    /**
     * 根据单品code 删除单品（逻辑删除）
     *
     * @param code
     * @author:tanliang
     * @time:2016-6-14
     */
    public Integer deleteItemByCode(String code) {
        return getSqlSession().insert("Item.deleteItemByCode", code);
    }

    /**
     * 编辑微信商品（更改排序）
     *
     * @param model
     * @return
     */
    public Integer editItemOrder(ItemModel model) {
        return getSqlSession().insert("Item.editItemOrder", model);
    }

    /**
     * 微信商品顺序check
     *
     * @param order
     * @return
     * @author TanLiang
     * @time 2016-6-15
     */
    public Long wxOrderCheck(Long order) {
        Long total = getSqlSession().selectOne("Item.wxOrderCheck", order);
        return total;
    }

    /**
     * 测试取得商品列表
     *
     * @return
     */
    public List<ItemModel> getItemListTest() {
        return getSqlSession().selectList("Item.getItemListTest");
    }

    public void updateGoodsJF(ItemModel item) {
        getSqlSession().update("Item.updateGoodsJF", item);
    }

    public void updateGoodsYG(ItemModel item) {
        getSqlSession().update("Item.updateGoodsYG", item);
    }

    public Integer updateStock(String code) {
        return getSqlSession().update("Item.updateStock", code);
    }

}