package cn.rkylin.apollo.service;

import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.rkylin.apollo.enums.BusinessExceptionEnum;
import cn.rkylin.core.ApolloMap;
import cn.rkylin.core.IDataBaseFactory;
import cn.rkylin.core.exception.BusinessException;

@Service
public class ProjectRuleAttachService {
	private static final Log log = LogFactory.getLog(ProjectRuleAttachService.class);

	@Autowired
	private IDataBaseFactory dao;

	/**
	 * 增加结算规则上传文件的关系数据
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public int addProjectRuleAttach(ApolloMap<String, Object> params) throws Exception {
		int result = dao.insert("insertPorjectRuleAttach", params);
		if (result != 1) {
			throw new BusinessException(BusinessExceptionEnum.ADD_DATA.getC(), "增加结算规则上传信息异常！");
		}
		return result;
	}

	/**
	 * 修改结算规则上传文件关系表状态
	 * 
	 * @param params
	 * @return
	 * @throws BusinessException
	 * @throws Exception
	 */
	public int updateProjectRuleAttach(ApolloMap<String, Object> params) throws BusinessException, Exception {
		int result = 0;
		try {
			result = dao.update("updatePorjectRuleAttach", params);
		} catch (BusinessException e) {
			throw new BusinessException(BusinessExceptionEnum.ADD_DATA.getC(), "禁用结算规则上传关联表状态异常！");
		} catch (Exception e) {
			log.error("禁用结算规则上传关联表状态异常！", e);
		}
		return result;
	}
	
	/**
	 * 根据项目ID 规则ID 查询未删除的上传文件
	 * @param params
	 * @return
	 * @throws BusinessException
	 * @throws Exception
	 */
	public List<Map<String, Object>> findProjectRuleAttach(ApolloMap<String, Object> params)
			throws BusinessException, Exception {
		List<Map<String, Object>> projectRuleAttachList = null;
		try {
			projectRuleAttachList = dao.findForList("findPorjectRuleAttach", params);
		} catch (BusinessException e) {
			throw new BusinessException(e, "1001", "根据项目ID和规则ID查询上传文件异常！");
		} catch (Exception e) {
			log.error("根据项目ID和规则ID查询上传文件异常", e);
		}
		return projectRuleAttachList;
	}

}
