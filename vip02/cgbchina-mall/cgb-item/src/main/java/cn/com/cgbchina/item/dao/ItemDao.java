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
	public Integer updateWxOrder(ItemModel item){
		return getSqlSession().update("Item.updateWxOrder", item);
	}
	public Integer updateItem(ItemModel item) {
		return getSqlSession().update("Item.updateItem", item);
	}

	public Integer insert(ItemModel item) {
		return getSqlSession().insert("Item.insert", item);
	}

	public String maxId() {
		return getSqlSession().selectOne("Item.maxId");
	}

	public List<ItemModel> findAll() {
		return getSqlSession().selectList("Item.findAll");
	}

	public ItemModel findById(String code) {
		return getSqlSession().selectOne("Item.findById", code);
	}

	public Pager<ItemModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		// 查询总条数
		Long total = getSqlSession().selectOne("Item.count", paramMap);
		if (total == 0) {
			return Pager.empty(ItemModel.class);
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
	 * 根据商品或单品编码查询商品编码List
	 *
	 * @param code
	 * @return
	 */
	public List<String> findItemListByGoodsOrItemCode(String code) {
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
    public void insertBatch(List<ItemModel> itemList) {
        for (ItemModel item : itemList) {
            getSqlSession().insert("Item.insert", item);
        }
    }

	/**
	 * 置顶商品 顺序值-最大值查询
	 *
	 * @return Integer
	 * edit by zhoupeng
	 */
	public List<Integer> findAllStickOrder() {
		return getSqlSession().selectList("Item.findAllStickOrder");
	}

	/**
	 * 查询置顶商品
	 *
	 * @return add by liuhan
	 */
	public Pager<ItemModel> findAllStickFlagCount(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("Item.findAllStickFlagCount", params);

		if (total == 0) {
			return Pager.empty(ItemModel.class);
		}

		params.put("offset", offset);
		params.put("limit", limit);
		List<ItemModel> data = getSqlSession().selectList("Item.findAllStickFlagPager", params);
		return new Pager<ItemModel>(total, data);
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

	public List<ItemModel> findItemListByGoodsCode(String goodsCode) {
		return getSqlSession().selectList("Item.findItemListByGoodsCode", goodsCode);
	}

	public ItemModel findByIdAndOidOrMid(String code, String omid) {
		Map<String, Object> paramMap = Maps.newHashMap();
		if ("".equals(code)) {
			code = null;
		}
		if ("".equals(omid)) {
			omid = null;
		}
		paramMap.put("code", code);
		paramMap.put("omid", omid);
		return getSqlSession().selectOne("Item.findByIdAndOidOrMid", paramMap);
	}

	/**
	 * 根据单品编码列表查询单品礼品列表 没排序
	 *
	 * @param itemCodes
	 * @return
	 */
	public List<ItemModel> findByCodesNoOrder(List itemCodes) {
		return getSqlSession().selectList("Item.findByCodesNoOrder", itemCodes);
	}

	/**
	 * 微信商品管理分页查询
	 *
	 * @param params
	 * @param offset
	 * @param limit
	 * @return
	 */
	public Pager<ItemModel> findWxItemByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("Item.findWxItemCount", params);
		if (total == 0) {
			return Pager.empty(ItemModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<ItemModel> data = getSqlSession().selectList("Item.findWxItemByPage", paramMap);
		return new Pager<ItemModel>(total, data);
	}

	/**
	 * 根据单品编码List查询单品list(包含已删除)
	 *
	 * @param itemCodes
	 * @return
	 * @add by yanjie.cao
	 */
	public List<ItemModel> findByCodesAll(List itemCodes) {
		return getSqlSession().selectList("Item.findByCodesAll", itemCodes);
	}

	/**
	 * 根据单品编码查询单品(包含已删除)
	 *
	 * @param itemCode
	 * @return
	 * @add by yanjie.cao
	 */
	public ItemModel findByCodeAll(String itemCode) {
		return getSqlSession().selectOne("Item.findByCodeAll", itemCode);
	}


	/**
	 * 根据条件查询单品信息
	 *
	 * @param params
	 * @return
	 */
	public List<ItemModel> findItemByConditions(Map<String, Object> params) {
		return getSqlSession().selectList("Item.findItemByConditions", params);
	}

	/**
	 * 根据前十条商品CodeList查找单品信息
	 *
	 * @param goodsCodes
	 * @return
	 */
	public List<ItemModel> findTopItemListByGoodsCodeList(List goodsCodes) {
		return getSqlSession().selectList("Item.findTopItemListByGoodsCodeList", goodsCodes);
	}

	/**
	 * 根据礼品编码xid查询信息
	 * @author xiewl
	 * @param goodsXid
	 * @return
	 */
	public ItemModel findItemByXid(String goodsXid) {
		return getSqlSession().selectOne("Item.findItemByXid", goodsXid);
	}

	/**
	 * 更新单品销量
	 *
	 * @param itemModel
	 * @return
	 */
	public Integer updateItemTotal(ItemModel itemModel) {
		return getSqlSession().update("Item.updateItemTotal", itemModel);
	}

	/**
	 * 根据mid查询数据
	 *
	 * @param mid
	 * @return
	 */
	public ItemModel findItemDetailByMid(String mid) {
		return getSqlSession().selectOne("Item.findItemDetailByMid", mid);
	}

	/**
	 * 批量更新库存信息
	 * @param code
	 * @param backStockCnt
	 * @param userId
	 * @return
	 */
	public Integer updateBatchStock(String code, Integer backStockCnt, String userId) {
		Map<String, Object> param = Maps.newHashMap();
		param.put("code", code);
		param.put("backStocCnt", backStockCnt);
		param.put("userId", userId);
		return getSqlSession().update("Item.updateBatchStock", param);
	}

	/**
	 * 批量更新库存信息 礼品库存
	 *
	 * @param ItemModelList
	 * @return
	 */
	public Integer updateBatchStock(List<ItemModel> ItemModelList) {
		return getSqlSession().update("Item.updatePresentStock", ItemModelList);
	}
	/**
	 * 根据mid查询单品
	 *
	 * @param mid
	 * @return
	 */
	public ItemModel findByMid(String mid) {
		return getSqlSession().selectOne("Item.findByMid", mid);
	}

	/**
	 * 查询 是否置顶的单品
	 * @param itemParams
	 * @return
     */
	public List<ItemModel> findItemsByGoodsCodeAndStick(Map<String, Object> itemParams) {
		return getSqlSession().selectList("Item.findItemsByGoodsCodeAndStick", itemParams);
	}


	/**
	 * find GoodsCodeList By ItemCodeList
	 *
	 * @param itemIds
	 * @return
	 */
	public List<ItemModel> findGoodsCodeListByItemCodeList(List<String> itemIds) {
		return getSqlSession().selectList("Item.findGoodsCodeListByItemCodeList", itemIds);
	}

	/**
	 * MAL502 回滚库存 niufw
	 *
	 * @param itemModel
	 * @return
	 */
	public Integer rollbackBacklogByNum(ItemModel itemModel) {
		return getSqlSession().update("Item.rollbackBacklogByNum", itemModel);
	}

	/**
	 * 根据礼品编码xid查询信息
	 */
	public List<ItemModel> findItemCodeByXid(String goodsXid) {
		return getSqlSession().selectList("Item.findItemByXid", goodsXid);
	}

	/**
	 * MAL115 减掉库存
	 *
	 * @param itemModel
	 * @return
	 */
	public Integer subtractStock(ItemModel itemModel) {
		return getSqlSession().update("Item.subtractStock", itemModel);
	}


	/**
	 * 批量更新单品信息
	 *
	 * @param ItemModelList
	 * @return
	 */
	public Integer batchUpdateItemInfo(List<ItemModel> ItemModelList) {
		return getSqlSession().update("Item.updateItemInfos", ItemModelList);
	}

	public List<ItemModel> forDeltaDump(String maxCode, String lastUpdateTime, int pageSize) {
		return getSqlSession().selectList("Item.forDeltaDump",
				ImmutableMap.of("lastId", maxCode, "limit", pageSize, "compared", lastUpdateTime));
	}

	/**
	 * 检出单品信息（索引）
	 *
	 * @param maxCode
	 * @param pageSize
     * @return
     */
	public List<ItemModel> findFullItemToIndex(String maxCode, int pageSize) {
		return getSqlSession().selectList("Item.findFullItemToIndex",
				ImmutableMap.of("lastId", maxCode, "limit", pageSize));
	}

	public Long findStockByItemCode(String itemCode) {
		return getSqlSession().selectOne("Item.findStockByItemCode", itemCode);
	}

	public List<ItemModel> findStocksByItemCodes(List<String> itemCodes) {
		return getSqlSession().selectList("Item.findStocksByItemCodes", itemCodes);
	}

	public Integer updateStockForOrder(String code, Long itemCount) {
		Map<String, Object> param = Maps.newHashMap();
		param.put("code", code);
		param.put("itemCount", itemCount);
		return getSqlSession().update("Item.updateStockForOrder", param);
	}

	public Long findMidIsExist(String mid){
		return getSqlSession().selectOne("Item.findMidIsExist", mid);
	}
	
	/**
	 * 批量更新库存信息(积分商城)
	 * @param code
	 * @param backStockCnt
	 * @param userId
	 * @return
	 */
	public Integer updateRollBackStockForJF(String code, Integer backStockCnt, String userId) {
		Map<String, Object> param = Maps.newHashMap();
		param.put("code", code);
		param.put("backStocCnt", backStockCnt);
		param.put("userId", userId);
		return getSqlSession().update("Item.updateRollBackStockForJF", param);
	}

	/**
	 * 根据mid的集合查询itemCode集合
	 * 用于微信商品查询
	 *
	 * @param params 查询条件
	 * @return list itemCode集合
	 */
	public List<ItemModel> findByMids(Map<String, Object> params){
		return getSqlSession().selectList("Item.findByMids", params);
	}

	public List<ItemModel> fullDump(String lastId, int pageSize) {
		return getSqlSession().selectList("Item.forDump", ImmutableMap.of("lastId", lastId, "limit", pageSize));
	}

	/**
	 * 根据非空MIdorXid模糊查询
	 * @param midOrXid
	 * @return
	 */
	public List<String> findLikeMidOrXid(String midOrXid){
		return getSqlSession().selectList("Item.findLikeMidOrXid", midOrXid);
	}

	/**
	 * 根据非空 MIdorXid 模糊查询
	 * @param params 查询条件
	 * @return list
	 */
	public List<String> findGoodsCodesbyMidOrXid(Map<String, Object> params){
		return getSqlSession().selectList("Item.findGoodsCodesbyMidOrXid", params);
	}
	
	/**
	 * Description : 根据xid
	 * @author xiewl
	 * @since 20161002
	 * @param xids
	 * @return
	 */
	public List<ItemModel> findItemByXids(List<String> xids) {
		return getSqlSession().selectList("Item.findByXids", xids);
	}

	/**
	 * 删除微信推荐顺序
	 */
	public Integer deleteWechateWxOrder(String itemCode){
		return getSqlSession().update("Item.deleteWxOrder", itemCode);
	}


	/**
	 * 更新单品信息
	 * 不带null条件判断
	 * @param item
	 * @return
     */
	public Integer updateWithoutNull(ItemModel item) {
		return getSqlSession().update("Item.updateWithoutNull", item);
	}

	public Integer updatePrice(ItemModel item) {
		return getSqlSession().update("Item.updatePrice", item);
	}
	public List<String> findItemCodesByItemCode(String itemCode){
	    return getSqlSession().selectList("Item.findItemCodesByItemCode", itemCode);
	}

}