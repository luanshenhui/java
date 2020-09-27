package cn.rkylin.apollo.service;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import cn.rkylin.apollo.common.util.SnoGerUtil;
import cn.rkylin.apollo.enums.BusinessExceptionEnum;
import cn.rkylin.apollo.utils.FileUtil;
import cn.rkylin.core.ApolloMap;
import cn.rkylin.core.IDataBaseFactory;
import cn.rkylin.core.exception.BusinessException;

/**
 * Created by Admin on 2016/7/8.
 */

@Service
public class ProjectRuleService {
	@Autowired
	private IDataBaseFactory dao;
	@Autowired
	ProjectRuleAttachService projectRuleAttachService;

	@Value("#{api_properties.uploadDir}")
	private String uploadDir = "";

	@Value("#{api_properties.uploadURL}")
	private String uploadURL;

	@Value("#{api_properties.downloadURL}")
	private String downloadURL;

	/**
	 * 新增结算规则
	 * 
	 * @param params
	 * @param files
	 * @return
	 * @throws Exception
	 */
	public int addProjectRule(ApolloMap<String, Object> params, MultipartFile[] files) throws Exception {
		String ruleId = SnoGerUtil.getUUID();
		params.put("rule_id", ruleId);
		int result = dao.update("insertProjSettleRule", params);
		if (result != 1) {
			throw new BusinessException(BusinessExceptionEnum.ADD_DATA.getC(), "新增结算规则异常！");
		}
		if (null != files && files.length > 0) {
			for (int i = 0; i < files.length; i++) {
				MultipartFile file = files[i];
				if (StringUtils.isNotBlank(file.getOriginalFilename())) {
					if (!FileUtil.saveFile(uploadDir, file)) {
						throw new BusinessException(BusinessExceptionEnum.ADD_DATA.getC(), "上传结算规则异常！");
					}
					String uploadFileName = file.getOriginalFilename();
					ApolloMap<String, Object> apolloMap = new ApolloMap<String, Object>();
					apolloMap.put("projectId", params.get("rule_project_id"));
					apolloMap.put("ruleId", ruleId);
					apolloMap.put("status", 1);
					apolloMap.put("createUserId", params.get("user_id"));
					apolloMap.put("createUserName", params.get("user_name"));
					apolloMap.put("uploadPath", uploadDir);
					apolloMap.put("fileName", uploadFileName);
					projectRuleAttachService.addProjectRuleAttach(apolloMap);
				}
			}
		}

		return result;
	}

	/**
	 * 更新结算规则
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public int updateProjectRule(ApolloMap<String, Object> params, MultipartFile[] files) throws Exception {
		int result = dao.update("updateProjectRule", params);
		if (result != 1) {
			throw new BusinessException(BusinessExceptionEnum.ADD_DATA.getC(), "更新结算规则异常！");
		}
		if (null != files && files.length > 0) {
			for (int i = 0; i < files.length; i++) {
				MultipartFile file = files[i];
				if (StringUtils.isNotBlank(file.getOriginalFilename())) {
					if (!FileUtil.saveFile(uploadDir, file)) {
						throw new BusinessException(BusinessExceptionEnum.ADD_DATA.getC(), "上传结算规则异常！");
					}
					String uploadFileName = file.getOriginalFilename();
					ApolloMap<String, Object> apolloMap = new ApolloMap<String, Object>();
					apolloMap.put("projectId", params.get("rule_project_id"));
					apolloMap.put("ruleId", params.get("rule_id"));
					apolloMap.put("status", 1);
					apolloMap.put("createUserId", params.get("user_id"));
					apolloMap.put("createUserName", params.get("user_name"));
					apolloMap.put("uploadPath", uploadDir);
					apolloMap.put("fileName", uploadFileName);
					projectRuleAttachService.addProjectRuleAttach(apolloMap);
				}
			}
		}
		return result;
	}

	/**
	 * 删除结算规则-（修改状态）
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public int updateProjectRuleStatus(ApolloMap<String, Object> params) throws Exception {
		int result = dao.update("updateProjectRuleStatus", params);
		if (result != 1) { // add by zhangXinyuan 如果存在修改多条数据返回的肯定不是1
							// 导致进入自定义异常事务回滚无法修改成功.
			throw new BusinessException(BusinessExceptionEnum.ADD_DATA.getC(), "更新结算规则状态异常！");
		}
		return result;
	}

	/**
	 * 获取数据库表最大id
	 * 
	 * @return
	 * @throws Exception
	 */
	public int getMaxId() throws Exception {
		int maxNo = 0;
		try {
			List<Map<String, Object>> maxIdList = dao.findForList("findMaxProjectRuleId", null);
			if (null != maxIdList && maxIdList.size() > 0) {
				Map<String, Object> maxIdMap = (Map<String, Object>) maxIdList.get(0);
				if (null != maxIdMap.get("maxId")) {
					maxNo = Integer.parseInt(StringUtils.isNotEmpty(maxIdMap.get("maxId").toString())
							? maxIdMap.get("maxId").toString() : "0");
				}
			}
		} catch (Exception e) {
			throw new BusinessException(BusinessExceptionEnum.ADD_DATA.getC(), "获取最大ID异常");
		}
		return maxNo;
	}

}
