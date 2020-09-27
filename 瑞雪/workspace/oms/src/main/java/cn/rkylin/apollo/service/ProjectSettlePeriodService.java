package cn.rkylin.apollo.service;

import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.rkylin.core.ApolloMap;
import cn.rkylin.core.IDataBaseFactory;

/**
 * （业务层的方法名称要和事务中的传播定义名称一致除查询外） 账期管理操作
 * 
 * @author zxy
 *
 */
@Service
public class ProjectSettlePeriodService {
	private static final Log log = LogFactory.getLog(ProjectSettlePeriodService.class);
	@Autowired
	private IDataBaseFactory dao;
	
	public List<Map<String,Object>> findProjectSettlePeriod(ApolloMap<String,Object> params) throws Exception{
		params.put("id", "");
		return dao.findForList("findProjectSettlePeriod", params);
	}

	/**
	 * 增加账期
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public int addProjectSettlePeriod(ApolloMap<String, Object> params) throws Exception {
		return dao.insert("inserProjectSettlePeriod", params);

	}

	/**
	 * 修改账期
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public int updateProjectSettlePeriod(ApolloMap<String, Object> params) throws Exception {
		return dao.update("updateProjectSettlePeriod", params);
	}

}
