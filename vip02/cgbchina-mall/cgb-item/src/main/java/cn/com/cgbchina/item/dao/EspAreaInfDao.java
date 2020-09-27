package cn.com.cgbchina.item.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;

import cn.com.cgbchina.item.model.EspAreaInfModel;

@Repository
public class EspAreaInfDao extends SqlSessionDaoSupport {

	public Integer update(EspAreaInfModel espAreaInf) {
		return getSqlSession().update("EspAreaInfModel.update", espAreaInf);
	}

	public Integer insert(EspAreaInfModel espAreaInf) {
		return getSqlSession().insert("EspAreaInfModel.insert", espAreaInf);
	}

	public List<EspAreaInfModel> findAll() {
		return getSqlSession().selectList("EspAreaInfModel.findAll");
	}

	public EspAreaInfModel findById(Long id) {
		return getSqlSession().selectOne("EspAreaInfModel.findById", id);
	}

	public Pager<EspAreaInfModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("EspAreaInfModel.pageCount", params);
		if (total == 0) {
			return Pager.empty(EspAreaInfModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<EspAreaInfModel> data = getSqlSession().selectList("EspAreaInfModel.pager", paramMap);
		return new Pager<EspAreaInfModel>(total, data);
	}

	public Integer delete(EspAreaInfModel espAreaInf) {
		return getSqlSession().delete("EspAreaInfModel.delete", espAreaInf);
	}

	/**
	 * 查询分区信息
	 *
	 * @param paramaMap 查询参数
	 * @return 查询结果
	 *         <p/>
	 *         geshuo 20160728
	 */
	public List<EspAreaInfModel> findAreaInfoByParams(Map<String, Object> paramaMap) {
		return getSqlSession().selectList("EspAreaInfModel.findAreaInfoByParams", paramaMap);
	}

	/**
	 * 顺序重复校验
	 *
	 * @param areaSeq
	 * @return
	 */
	public Long checkpartitionSort(Integer areaSeq) {
		Long total = getSqlSession().selectOne("EspAreaInfModel.checkPartitionSort", areaSeq);
		return total;
	}

	/**
	 * 检验分区名称是否存在
	 *
	 * @param areaName
	 * @return
	 */
	public Long checkGiftpartition(String areaName) {
		Long total = getSqlSession().selectOne("EspAreaInfModel.checkGiftPartition", areaName);
		return total;
	}

	/**
	 * 检验分区code是否存在
	 *
	 * @param areaId
	 * @returncheckGiftpartition
	 */
	public Long checkpartitionCode(String areaId) {
		Long total = getSqlSession().selectOne("EspAreaInfModel.checkPartitionCode", areaId);
		return total;
	}

	/**
	 * 分区查询
	 *
	 * @param offset
	 * @param limit
	 * @return
	 */
	public Pager<EspAreaInfModel> findNameByAll(int offset, int limit) {
		Long total = getSqlSession().selectOne("EspAreaInfModel.findNameByAllCount");
		if (total == 0) {
			return Pager.empty(EspAreaInfModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<EspAreaInfModel> data = getSqlSession().selectList("EspAreaInfModel.findNameByAll", paramMap);
		return new Pager<EspAreaInfModel>(total, data);
	}

	/**
	 * 查询分区信息
	 * 
	 * @return
	 */
	public List<EspAreaInfModel> findByAreaId(Map<String, Object> paramaMap) {
		return getSqlSession().selectList("EspAreaInfModel.findByAreaId",paramaMap);
	}

	/**
	 * 根据AreaId查询分区信息
	 */
	public EspAreaInfModel findEspAreaInfByAreaId(String areaId) {
		return getSqlSession().selectOne("EspAreaInfModel.findEspAreaInfByAreaId", areaId);
	}
}