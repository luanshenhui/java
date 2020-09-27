package com.dpn.ciqqlc.standard.service;

import java.util.List;
import java.util.Map;

import com.dpn.ciqqlc.standard.model.UserConfigurationDTO;
import com.dpn.ciqqlc.standard.model.UserConfigurationModel;
import com.dpn.ciqqlc.standard.model.UserVisit;
import com.dpn.ciqqlc.standard.model.VisitConfigurationDTO;

public interface UserConfigDbService {

	int insertUserConfiguration(UserConfigurationDTO dto);
	
	int updateUserConfiguration(UserConfigurationDTO dto);
	
	/**
	 * 根据id删除用户访问路径
	 * @param dto
	 * @return
	 */
	int delUserConfiguration(UserConfigurationDTO dto);
	
	/**
	 * 批量删除
	 * @param map
	 * @return
	 */
	int bathcDelUserConfiguration(Map<String,Object> map);
	
	
	int insertVisitConf(VisitConfigurationDTO dto);
	
	int UpdateVisitConf(VisitConfigurationDTO dto);
	
	int batchDelVisitConf(Map<String,Object> map);
	
	/**
	 * 查询登录用户所有的访问路径
	 * @param um
	 * @return
	 */
	List<UserConfigurationModel> findUserConfigList(UserConfigurationModel um);
	
	int findUserConfigListCount(UserConfigurationModel um);
	
	/**
	 * 系统中的路径
	 * @param dto
	 * @return
	 */
	List<VisitConfigurationDTO> findVisitConfigList(VisitConfigurationDTO dto);
	
	VisitConfigurationDTO findVisitConfigById(VisitConfigurationDTO dto);
	
	/**
	 * 查询用户列表
	 * @param map
	 * @return
	 */
	List<UserVisit> findUsersV(Map<String, String> map)throws Exception;
	
	/**
	 * 查询用户列表记录数
	 * @param map
	 * @return
	 */
	int findUsersCountV(Map<String, String> map)throws Exception;
}
