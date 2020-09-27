package cn.rkylin.apollo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.rkylin.apollo.enums.BusinessExceptionEnum;
import cn.rkylin.core.ApolloMap;
import cn.rkylin.core.IDataBaseFactory;
import cn.rkylin.core.exception.BusinessException;

/**
 * Created by Admin on 2016/6/29.
 */

@Service
public class ProjectService {
	@Autowired
	private IDataBaseFactory dao;

	public int addProject(ApolloMap<String, Object> params) throws Exception {
		int r = dao.insert("insertProject", params);
		if (r != 1) {
			throw new BusinessException(BusinessExceptionEnum.ADD_DATA.getC(), "添加项目异常！");
		}
		return r;
	}

	public int modifyProject(ApolloMap<String, Object> params) throws Exception {
		int r = dao.update("modifyProject", params);
		if (r != 1) {
			throw new BusinessException(BusinessExceptionEnum.ADD_DATA.getC(), "修改项目异常！");
		}
		return r;
	}

	/**
	 * 根据项目名称查询是否已经存在
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> findProjectNameByWhere(ApolloMap<String, Object> params) throws Exception {
		return dao.findForList("findProjectNameByWhere", params);
	}
	
	/**
	 * 根据条件下载项目管理列表数据
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> findProjectByWhere(ApolloMap<String, Object> params) throws Exception {
		return dao.findForList("findProjectByWhere", params);
	}

	/**
	 * 查询字典表根据配置的表名称查询
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> findSysDicFmProject(ApolloMap<String, Object> params) throws Exception {
		return dao.findForList("findSysDicFmTable", params);

	}
	
	/**
	 * 项目编号自动增长
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public int updateSeqProject(ApolloMap<String, Object> params)throws Exception{
		return dao.update("incrSeqProjectCode", params);
	}

}
