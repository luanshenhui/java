package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.dto.TblGoodsPaywayDto;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Repository
public class TblGoodsPaywayDao extends SqlSessionDaoSupport {

	public Integer update(TblGoodsPaywayModel tblGoodsPayway) {
		return getSqlSession().update("TblGoodsPaywayModel.update", tblGoodsPayway);
	}

	public Integer insert(TblGoodsPaywayModel tblGoodsPayway) {
		return getSqlSession().insert("TblGoodsPaywayModel.insert", tblGoodsPayway);
	}

	public TblGoodsPaywayModel findById(String goodsPaywayId) {
		return getSqlSession().selectOne("TblGoodsPaywayModel.findById", goodsPaywayId);
	}

	public List<TblGoodsPaywayModel> findAll() {
		return getSqlSession().selectList("TblGoodsPaywayModel.findAll");
	}

	public Integer delete(TblGoodsPaywayModel tblGoodsPayway) {
		return getSqlSession().delete("TblGoodsPaywayModel.delete", tblGoodsPayway);
	}

	public Integer insertAllPayWay(List<TblGoodsPaywayModel> list) {
		return getSqlSession().insert("TblGoodsPaywayModel.insertAllPayWay", list);
	}

	public Pager<TblGoodsPaywayModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("TblGoodsPaywayModel.count", params);
		if (total == 0) {
			return Pager.empty(TblGoodsPaywayModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<TblGoodsPaywayModel> data = getSqlSession().selectList("TblGoodsPaywayModel.pager", paramMap);
		return new Pager<TblGoodsPaywayModel>(total, data);
	}

	public List<TblGoodsPaywayModel> findByGoodsIds(List<String> list) {
		return getSqlSession().selectList("TblGoodsPaywayModel.findByGoodsIds", list);
	}
	public List<TblGoodsPaywayModel> findByGoodsIdsAsc(List<String> list) {
		return getSqlSession().selectList("TblGoodsPaywayModel.findByGoodsIdsAsc", list);
	}

	public List<TblGoodsPaywayModel> findByGoodsIdsNoActive(List<String> goodsIds) {
		return getSqlSession().selectList("TblGoodsPaywayModel.findByGoodsIdsNoActive", goodsIds);
	}

	public Integer insertBatch(List<TblGoodsPaywayModel> list) {
		return getSqlSession().insert("TblGoodsPaywayModel.insertBatch", list);
	}

	public List<TblGoodsPaywayModel> findGoodsPaywayModelListByItemCode(String itemCode) {
		return getSqlSession().selectList("TblGoodsPaywayModel.findListByItemCode", itemCode);
	}

	public List getGoodsPayawy(String itemCode) {
		return getSqlSession().selectList("TblGoodsPaywayModel.getGoodsPayawy", itemCode);
	}
	public List<TblGoodsPaywayModel> findByGoodsId(String itemCode){
		return getSqlSession().selectList("TblGoodsPaywayModel.findByGoodsId", itemCode);
	}
	public List<TblGoodsPaywayModel> findGoodsPaywayByItemCodes(Map<String, Object> paywayParams) {
		return getSqlSession().selectList("TblGoodsPaywayModel.findGoodsPaywayByItemCodes", paywayParams);
	}

	public TblGoodsPaywayModel findHighestStageInfo(String goodsId) {
		return getSqlSession().selectOne("TblGoodsPaywayModel.findHighestStageInfo", goodsId);
	}
	public List<TblGoodsPaywayModel> getPayWayforItemId(TblGoodsPaywayModel tblGoodsPaywayModel) {
		return getSqlSession().selectList("TblGoodsPaywayModel.findAll", tblGoodsPaywayModel);
	}

	/**
	 * 通过单品code获取对象list
	 *
	 * @param itemCode
	 * @return
	 */
	public List<TblGoodsPaywayModel> findByItemCode(String itemCode) {
		return getSqlSession().selectList("TblGoodsPaywayModel.findByItemCode", itemCode);
	}
	/**
	 * 通过单品code获取有效的对象list
	 *
	 * @param itemCode
	 * @return
	 */
	// public List<TblGoodsPaywayModel> findCheckByItemCode(String itemCode) {
	// return getSqlSession().selectList("TblGoodsPaywayModel.findCheckByItemCode", itemCode);
	// }

	/**
	 * 查询商品支付方式表
	 *
	 * @param itemCode
	 * @return
	 */
	public List<TblGoodsPaywayModel> findGoodsPayway(String itemCode) {
		return getSqlSession().selectList("TblGoodsPaywayModel.findByItemCode", itemCode);
	}

	public Integer updatePayWayMemberLevel(TblGoodsPaywayModel tblGoodsPaywayModel) {
		return getSqlSession().update("TblGoodsPaywayModel.updatePayWayMemberLevel", tblGoodsPaywayModel);
	}

	/**
	 * 通过单品ID和分期数检索对象
	 *
	 * @param params
	 * @return
	 */

	public TblGoodsPaywayModel findByItemCodeAndStagesCode(Map<String, Object> params) {
		return getSqlSession().selectOne("TblGoodsPaywayModel.findByItemCodeAndStagesCode", params);
	}

	public List<TblGoodsPaywayModel> findInfoByItemCode(String itemCode) {
		return getSqlSession().selectList("TblGoodsPaywayModel.findInfoByItemCode", itemCode);
	}

	/**
	 * 根据单品id批量删除支付方式
	 *
	 * @param params
	 * @return
	 */
	public Integer deletePayWay(Map<String, Object> params) {
		return getSqlSession().delete("TblGoodsPaywayModel.deletePayWay", params);
	}


	/**
	 * 根据单品id返回最大分期数的支付方式
	 */
	public TblGoodsPaywayModel findMaxGoodsPayway(String itemCode) {
		return getSqlSession().selectOne("TblGoodsPaywayModel.findMaxGoodsPayway", itemCode);
	}

	/**
	 * 取得金普价
	 * @param goodsId
	 * @return
	 */
	public TblGoodsPaywayModel findJPPoints(String goodsId) {
		return getSqlSession().selectOne("TblGoodsPaywayModel.findJPPoints",goodsId);
	}

	/**
	 * 查询商品支付方式表(分期方式代码降序)
	 *
	 * @param goodsCode
	 * @return
	 */
	public List<TblGoodsPaywayModel> findByGoodsPaywayInfo(String goodsCode) {
		return getSqlSession().selectList("TblGoodsPaywayModel.findByGoodsPaywayInfo", goodsCode);
	}

	/**
	 * 查询商品支付方式表(会员等级升序)
	 *
	 * @param goodsCode
	 * @return
	 */
	public List<TblGoodsPaywayModel> findByGoodsPaywayInfoJF(String goodsCode) {
		return getSqlSession().selectList("TblGoodsPaywayModel.findByGoodsPaywayInfoJF", goodsCode);
	}

	/**
	 * 根据单品编码List查询单品list(包含已删除)
	 *
	 * @param ids
	 * @return
	 * @add by yanjie.cao
	 *
	 */
	public List<TblGoodsPaywayModel> findByCodesAll(List ids) {
		return getSqlSession().selectList("TblGoodsPaywayModel.findByCodesAll", ids);
	}

	/***
	 * 通过 goodsPayWayIdList获取ModelList(全状态查询)
	 * @param list
     * @return
	 * @add by yanjie.cao
     */
	public List<TblGoodsPaywayModel> findByGoodsPayWayIdList(List<String> list) {
		return getSqlSession().selectList("TblGoodsPaywayModel.findByGoodsPayWayIdList", list);
	}

	public List<TblGoodsPaywayModel> findByGoodsIdAndMemberLevel(Map<String, Object> params) {
		return getSqlSession().selectList("TblGoodsPaywayModel.findInfoByItemCode", params);
	}

	/**
	 *
	 * @param params
	 * @return
	 */
	public List<TblGoodsPaywayModel> findByGoodsIdList(Map<String,Object> params) {
		 return getSqlSession().selectList("TblGoodsPaywayModel.findByGoodsIdList",params);

	}
	/**
	 *
	 * @param params
	 * @return
	 */
	public List<TblGoodsPaywayModel> findByGoodsIdListNoOrder(Map<String,Object> params) {
		return getSqlSession().selectList("TblGoodsPaywayModel.findByGoodsIdListNoOrder",params);

	}

	/***
	 * 定价审核时更新商品支付表
	 * @param dto
	 * @return
	 */
	public Integer updateGoodsPaywayByGoodsIdAndIscheck(TblGoodsPaywayDto dto) {
		return getSqlSession().update("TblGoodsPaywayModel.updateGoodsPaywayByGoodsIdAndIscheck", dto);
	}


	/**
	 * 根据参数查询支付方式
	 * @param paramMap 查询参数
	 * @return 查询结果
	 *
	 * geshuo 20160818
	 */
	public List<TblGoodsPaywayModel> findGoodsPayWayByParams(Map<String,Object> paramMap){
		return getSqlSession().selectList("TblGoodsPaywayModel.findGoodsPayWayByParams",paramMap);
	}

	public List<TblGoodsPaywayModel> findPaywayByGoodsIds(String goodsId) {
		return getSqlSession().selectList("TblGoodsPaywayModel.findPaywayByGoodsIds", goodsId);
	}

	public List<TblGoodsPaywayModel> findJxpayway(String goodsId,String goodsPaywayId,String isMoney) {
		Map<String, Object> params = Maps.newHashMap();
		params.put("goodsId", goodsId);
		params.put("goodsPaywayId", goodsPaywayId);
		if("0".equals(isMoney)){
			return getSqlSession().selectList("TblGoodsPaywayModel.findJxpayway", params);
		} else {
			return getSqlSession().selectList("TblGoodsPaywayModel.findJxpayway1", params);
		}
	}

	public TblGoodsPaywayModel getBirthPayway(String goodsId){
		return getSqlSession().selectOne("TblGoodsPaywayModel.getBirthPayway", goodsId);
	}

	public Long getJPPoint(String goodsId){
		return getSqlSession().selectOne("TblGoodsPaywayModel.getJPPoint", goodsId);
	}

	public TblGoodsPaywayModel findPwById(String goodsPaywayId) {
		return getSqlSession().selectOne("TblGoodsPaywayModel.findPwById", goodsPaywayId);
	}

	public List<TblGoodsPaywayModel> findListForSearch(String itemCode){
		return getSqlSession().selectList("TblGoodsPaywayModel.findListForSearch", itemCode);
	}
}