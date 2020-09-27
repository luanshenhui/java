package cn.com.cgbchina.batch.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.batch.model.ModifyIntegral;

/**
 * 修改积分数据层
 * 
 * @author xiewl
 * @version 2016年5月12日 上午10:15:24
 */
@Repository
public class ModifyIntegralDao extends SqlSessionDaoSupport {

	public List<ModifyIntegral> queryDetail(Map<String, Object> params) {
		return getSqlSession().selectList("queryDetail", params);
	}
}
