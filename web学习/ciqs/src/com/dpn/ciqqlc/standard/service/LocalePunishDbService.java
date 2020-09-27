package com.dpn.ciqqlc.standard.service;

import java.util.List;
import java.util.Map;

import com.dpn.ciqqlc.standard.model.DocTypeDTO;
import com.dpn.ciqqlc.standard.model.LegalPunishModel;
import com.dpn.ciqqlc.standard.model.LocalePunishDTO;
import com.dpn.ciqqlc.standard.model.VideoDTO;

/**
 * @author
 * @since 1.0.0
 * @version 1.0.0
 */
/* *****************************************************************************
 * 备忘记录 -> 简易处罚
 * ******************************************************************
 * ************* 变更履历 ->
 * ****************************************************************************
 */
public interface LocalePunishDbService {

	/**
	 * 简易处罚列表页
	 * 
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<LocalePunishDTO> findLocalePunishes(Map<String, String> map)
			throws Exception;

	/**
	 * 简易处罚列表页
	 * 
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int findLocalePunishesCount(Map<String, String> map)
			throws Exception;

	/**
	 * 简易处罚列详情信息
	 * 
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public LocalePunishDTO localepunishInfo(Map<String, String> map)
			throws Exception;

	/**
	 * 单条简易处罚所涉及的照片和视频
	 * 
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<VideoDTO> queryPunishFiles(Map<String, String> map)
			throws Exception;

	/**
	 * 单条简易处罚所涉及的doc文件
	 * 
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<DocTypeDTO> queryPunishDocs(Map<String, String> map)
			throws Exception;

	/**
	 * 插入一条视频文件
	 * 
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int insertPunishFiles(Map<String, String> map) throws Exception;

	/**
	 * 保存检疫处罚 LocalePunishDTO 前段入参数
	 */
	public void insertLocalePunish(LocalePunishDTO dto) throws Exception;

	/**
	 * 修改检疫处罚 LocalePunishDTO 前段入参数
	 */
	public void updateLocalePunish(LocalePunishDTO dto) throws Exception;

	/**
	 * 根据业务id查询是否已经存在
	 * 
	 * @param punish_id
	 * @return
	 * @throws Exception
	 */
	public Integer findLocaleCount(String punish_id) throws Exception;

	/**
	 * 联查询 pdf 展示模型数据
	 * 
	 * @param dto
	 * @return
	 */
	public LegalPunishModel findPunishList(LocalePunishDTO dto)
			throws Exception;

	public Map<String, String> searchDetail(String punish_id) throws Exception;
}
