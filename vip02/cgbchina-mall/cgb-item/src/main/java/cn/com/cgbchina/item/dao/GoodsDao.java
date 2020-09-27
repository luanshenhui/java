package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.dto.PointPresentDto;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import com.google.common.collect.ImmutableMap;
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
	public Integer clearApproveDiff(String goodsCode){
		return getSqlSession().update("Goods.clearApproveDiff",goodsCode);
	}

	public Integer insert(GoodsModel goods) {
		return getSqlSession().insert("Goods.insert", goods);
	}

	//查询结果过多会导致出现问题，限制每次最多100条结果
	public List<GoodsModel> findAll(Map<String, Object> params) {
		return getSqlSession().selectList("Goods.findAll", params);
	}
	
	public List<GoodsModel> findAllByCC(Map<String, Object> params) {
		return getSqlSession().selectList("Goods.findAllByCC", params);
	}

    public GoodsModel findById(String code) {
        return getSqlSession().selectOne("Goods.findById", ImmutableMap.of("code",code));
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
//
//	/**
//	 * 根据条件查询商品数量
//	 *
//	 * @param params
//	 * @return
//	 */
//	public Long findGoodsCountByParams(Map<String, Object> params) {
//		return getSqlSession().selectOne("Goods.pageCount", params);
//	}

//	/**
//	 * 根据条件查询礼品数量
//	 *
//	 * @param params
//	 * @return
//	 */
//	public Long findPointGoodsCountByParams(Map<String, Object> params) {
//		return getSqlSession().selectOne("Goods.pageCountByPointsPresent", params);
//	}

	public Integer delete(GoodsModel goods) {
		return getSqlSession().delete("Goods.delete", goods);
	}

	public List<GoodsModel> findGoodsCount(Map<String, Object> params) {
		return getSqlSession().selectList("Goods.findGoodsCount", params);
	}

	public Integer findUpShelfGoodsCount(Map<String, Object> params) {
		return getSqlSession().selectOne("Goods.findUpShelfGoodsCount", params);
	}

	public Integer findDownShelfGoodsCount(Map<String, Object> params) {
		return getSqlSession().selectOne("Goods.findDownShelfGoodsCount", params);
	}

	public GoodsModel findDetailById(String code) {
		return getSqlSession().selectOne("Goods.findById", code);
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

	/**
	 * 根据商品codes 查询商品信息
	 *
	 * @param goodsCodes
	 * @return
	 */
	public List<GoodsModel> findByCodes(List goodsCodes) {
		// TODO 当goodsCodes为空时，查询所有商品信息最多100条结果
		if (null != goodsCodes && 0 != goodsCodes.size()) {
			return getSqlSession().selectList("Goods.findByCodes", goodsCodes);
		} else {
			Map<String, Object> params = Maps.newHashMap();
			return findAll(params);
		}
	}

//	public List<GoodsModel> getGoodsNameByItemId(List<ItemModel> itemModelList) {
//		return getSqlSession().selectList("Goods.getGoodsNameByItemId", itemModelList);
//	}

	/**
	 * 根据spuIds，商品名称模糊查询商品
	 *
	 * @param params 查询参数
	 * @return goodsModels
	 */
	public List<GoodsModel> findGoodsInfoByNameAndSpuIds(Map<String, Object> params) {
		return getSqlSession().selectList("Goods.findGoodsInfoByNameAndSpuIds", params);
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
	 * Description : MAL202 IVR排行列表查询 根据商品列表查出对应库存大于0且在上架时间内的商品
	 *
	 * @param goodsCodes
	 * @return
	 */
	public List<GoodsModel> findOnSaleGoodsByCode(List goodsCodes) {
		return getSqlSession().selectList("Goods.findOnSaleGoodsByCode", goodsCodes);
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

//	public List<GoodsModel> findGoodsListByConditions(Map<String, Object> params) {
//		return getSqlSession().selectList("Goods.findGoodsListByConditions", params);
//	}

	/**
	 * 根据商品code查询分期商城商品详细信息
	 *
	 * @param goodsCode
	 * @return
	 */
	public GoodsModel findGoodsByGoodsCode(/* @Param("goodsCode") */String goodsCode) {
		return getSqlSession().selectOne("Goods.findGoodsByGoodsCode", goodsCode);
	}

	/**
	 * MAL335 特殊商品列表查询 根据品牌、渠道上架查询商品
	 *
	 * @param params
	 * @return
	 */
	public List<GoodsModel> findOnSaleSPGoodsByBrand(Map<String, Object> params) {
		return getSqlSession().selectList("Goods.findOnSaleSPGoodsByBrand", params);
	}

	/**
	 * 根据商品code查询广发商城的上架商品
	 *
	 * @param params
	 * @return
	 */
	public List<GoodsModel> findOnSaleSPGoodsByIds(Map<String, Object> params) {
		return getSqlSession().selectList("Goods.findOnSaleSPGoodsByIds", params);
	}

	public List<GoodsModel> findGiftByCodes(List goodsCodes) {
		return getSqlSession().selectList("Goods.findGiftByCodes", goodsCodes);
	}

	public List<GoodsModel> findAllWxGoods(Map<String, Object> params) {
		return getSqlSession().selectList("Goods.findAllWxGoods", params);
	}

	/**
	 * 通过品牌ID取出最新上架的十条商品code
	 *
	 * @param brandId
	 * @return
	 */
	public List<String> findGoodsCodeByBrandId(String brandId) {
		return getSqlSession().selectList("Goods.findGoodsCodeByBrandId", brandId);
	}

	// ---------------------------------------------礼品区--------------------------------------------------

//	/**
//	 * 礼品管理
//	 *
//	 * @param params
//	 * @param offset
//	 * @param limit
//	 * @return
//	 */
//	public Pager<GoodsModel> findPresentListByPage(Map<String, Object> params, int offset, int limit) {
//		Long total = getSqlSession().selectOne("Goods.pageCountByPointsPresent", params);
//		if (total == 0) {
//			return Pager.empty(GoodsModel.class);
//		}
//		Map<String, Object> paramMap = Maps.newHashMap();
//		if (!params.isEmpty()) {
//			paramMap.putAll(params);
//		}
//		paramMap.put("offset", offset);
//		paramMap.put("limit", limit);
//		List<GoodsModel> data = getSqlSession().selectList("Goods.pagerByPointsPresent", paramMap);
//		return new Pager<GoodsModel>(total, data);
//	}
//
//	// 新增礼品
//	public Integer insertPresent(PointPresentDto pointPresentDto) {
//		return getSqlSession().insert("Goods.insertPresent", pointPresentDto);
//	}

	/**
	 * 根据itemIdList查询商品List
	 *
	 * @param goodsCodeList
	 * @return
	 */
	public List<GoodsModel> findGoodsListByItemCodeList(List<String> goodsCodeList) {
		return getSqlSession().selectList("Goods.findGoodsListByItemCodeList", goodsCodeList);
	}

//	// 更新礼品
//	public Integer updatePresent(PointPresentDto pointPresentDto) {
//		return getSqlSession().update("Goods.updatePresent", pointPresentDto);
//	}

	public Integer findGoodsCountByVendorId(String vendorId,String businessTypeId) {
		return getSqlSession().selectOne("Goods.findGoodsCountByVendorId",  ImmutableMap.of("vendorId", vendorId, "ordertypeId", businessTypeId));
	}

	/**
	 * 通过品牌id检索使用该品牌的商品数量
	 */
	public Long findBrandCountByBrandId(String brandsId) {
		return getSqlSession().selectOne("Goods.findBrandCountByBrandId", brandsId);
	}

	/**
	 * 根据业务类型Id取得符合条件的商品编码
	 *
	 * @param param
	 * @return
	 */
	public List<String> findGoodsCodeByOrderTypeId(Map<String, Object> param) {
		return getSqlSession().selectList("Goods.findGoodsCodeByOrderTypeId", param);
	}

	/**
	 * 根据code模糊查询
	 *
	 * @param param
	 * @return
	 */
	public List<String> findGoodsByGoodsNameAndOrderType(Map<String, Object> param) {
		return getSqlSession().selectList("Goods.findGoodsByGoodsNameAndOrderType", param);
	}

	/**
	 * 查询 根据条件 以及 item 集合
	 *
	 * @param params 查询条件
	 * @return goodsModels 返回 查询的商品集合
	 *
	 * add by zhoupeng
	 */
	public List<GoodsModel> findGoodsByIds(Map<String, Object> params) {
		return getSqlSession().selectList("Goods.findGoodsByIds", params);
	}

	public Long findGoodsBySpu(Long spuId){
		return getSqlSession().selectOne("Goods.findGoodsBySpu",spuId);
	}

	/**
	 * 更新商品信息
	 * 不带null判断
	 * @param goodsModel
	 * @return
     */
	public Integer updateWithoutNull(GoodsModel goodsModel){
		return getSqlSession().update("Goods.updateWithoutNull", goodsModel);
	}

	public Integer updateChannelYgByVendorId(String vendorId) {
		return getSqlSession().update("Goods.updateChannelYgByVendorId", vendorId);
	}

	public Integer updateChannelJfByVendorId(String vendorId) {
		return getSqlSession().update("Goods.updateChannelJfByVendorId", vendorId);
	}
	
	/**
	 * 根据类目，商品名称 模糊查询装修商品
	 *
	 * @param params
	 * @return
	 */
	public List<GoodsModel> findGoodsListByGoodsNameLikeForDecoration(Map<String, Object> params) {
		return getSqlSession().selectList("Goods.findGoodsListByGoodsNameLikeForDecoration", params);
	}
}
