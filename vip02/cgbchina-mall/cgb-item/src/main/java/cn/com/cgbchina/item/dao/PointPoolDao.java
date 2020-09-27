package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.PointPoolModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class PointPoolDao extends SqlSessionDaoSupport {

	public Integer update(PointPoolModel pointPool) {
		return getSqlSession().update("PointPool.update", pointPool);
	}

	
	/**
	 * 逻辑删除
	 *
	 * @param id
	 * @return
	 */
	public Integer updateFordelete(Long id) {
		return getSqlSession().update("PointPool.updateFordelete", id);
	}

	public Integer insert(PointPoolModel pointPoolModel) {
		return getSqlSession().insert("PointPool.insert", pointPoolModel);
	}

	public List<PointPoolModel> findAll() {
		return getSqlSession().selectList("PointPool.findAll");
	}

	public PointPoolModel findById(Long id) {
		return getSqlSession().selectOne("PointPool.findById", id);
	}

	public Pager<PointPoolModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("PointPool.count", params);
		if (total == 0) {
			return Pager.empty(PointPoolModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<PointPoolModel> data = getSqlSession().selectList("PointPool.pager", paramMap);
		return new Pager<PointPoolModel>(total, data);
	}

	public Integer delete(PointPoolModel pointPool) {
		return getSqlSession().delete("PointPool.delete", pointPool);
	}

	/**
	 * 月份唯一性校验
	 *
	 * @param curMonth
	 * @return
	 */
	public PointPoolModel curMonthCheck(String curMonth) {
		return getSqlSession().selectOne("PointPool.curMonthCheck", curMonth);
	}

	public PointPoolModel getLastInfo(){
		return getSqlSession().selectOne("PointPool.lastInfo");
	}
	/**
	 * 获取当月积分池，如果当月未设置积分池信息，则找距离最近的一个月
	 * 商品详情页用
	 * @return
	 */
	public PointPoolModel getCurOrLastInfo(){
		return getSqlSession().selectOne("PointPool.getCurOrLastInfo");
	}

	public List<PointPoolModel> getPointPool(String curMonth) {
		return getSqlSession().selectList("PointPool.getPointPool",curMonth);
	}
    public void dealPointPoolForDate(Map<String, Object> paramMap){
        getSqlSession().update("PointPool.dealPointPoolForDate",paramMap);
    }
	
	public void dealPointPool(Map<String, Object> paramMap){
		getSqlSession().update("PointPool.dealPointPool",paramMap);
	}
	public PointPoolModel getCurMonthInfo(){
		return getSqlSession().selectOne("PointPool.getCurMonthInfo");
	}

	public Integer subtractPointPool(Map<String, Object> paramMap) {
		return getSqlSession().update("PointPool.subtractPointPool",paramMap);
	}
	
	public Integer updateById(PointPoolModel pointPool) {
		return getSqlSession().update("PointPool.updateById", pointPool);
	}
}