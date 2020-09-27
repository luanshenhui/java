package com.dpn.ciqqlc.standard.service;

import java.util.List;
import java.util.Map;

import com.dpn.ciqqlc.http.form.GeneralPunishmentForm;
import com.dpn.ciqqlc.http.form.QueryBaseIo;
import com.dpn.ciqqlc.http.form.YbcfQueryIo;
import com.dpn.ciqqlc.http.result.AjaxResult;
import com.dpn.ciqqlc.standard.model.CheckDocsRcdDTO;
import com.dpn.ciqqlc.standard.model.FileInfoDto;
import com.dpn.ciqqlc.standard.model.GeneralPunishmentDTO;
import com.dpn.ciqqlc.standard.model.GeneralPunishmentHistoryDTO;
import com.dpn.ciqqlc.standard.model.LocalePunishDTO;
import com.dpn.ciqqlc.standard.model.SelectModel;
import com.dpn.ciqqlc.standard.model.UserInfoDTO;
import com.dpn.ciqqlc.standard.model.VideoFileEventModel;

public interface GeneralPunishmentService {
	
	/**
	 * history - 查询列表
	 * @param map
	 * @return
	 */
	List<GeneralPunishmentHistoryDTO> findListHistory(GeneralPunishmentHistoryDTO dto);

	List<GeneralPunishmentHistoryDTO> findHistoryByStatus(GeneralPunishmentHistoryDTO dto);
	/**
	 * history - 查询列表
	 * @param map
	 * @return
	 */
	GeneralPunishmentHistoryDTO findHistory(GeneralPunishmentHistoryDTO dto);
	
	/**
	 * 根据单号查询
	 * @param dto
	 * @return
	 */
	GeneralPunishmentHistoryDTO findStepByReportNo(GeneralPunishmentHistoryDTO dto);
	
	/**
	 * 条件查询列表 准备废弃
	 * @param map
	 * @return
	 */
	@Deprecated
	List<GeneralPunishmentDTO> findList(GeneralPunishmentForm form);
	
	/**
	 * 条件查询记录数
	 * @param map
	 * @return
	 */
	@Deprecated
	int findListCount(GeneralPunishmentForm form);
	
	
	/**
	 * 新的条件查询列表
	 * @param map
	 * @return
	 */
	List<Map<String,Object>> findNewList(YbcfQueryIo form);
	
	/**
	 * 新的条件查询记录数
	 * @param map
	 * @return
	 */
	int findNewListCount (YbcfQueryIo form);
	/**
	 * 根据id查询
	 * @param id
	 * @return
	 */
	GeneralPunishmentDTO findById(String id);
	
	/**
	 * 根据id查询
	 * @param id
	 * @return
	 */
	GeneralPunishmentDTO findNewById(String id);
	
	/**
	 * 获取当前年最新立案号
	 * @param currYear
	 * @return
	 */
	String getLatestCaseNo(String currYear);
	
	/**
	 * QLC_GENERAL_PUNISHMENT 新增
	 * @param dto
	 * @return
	 */
	int add(GeneralPunishmentDTO dto);
	
	/**
	 * QLC_GENERAL_PUNISHMENT 修改
	 * @param dto
	 * @return
	 */
	int update(GeneralPunishmentDTO dto);
	
	/**
	 * QLC_GENERAL_PUNISHMENT_HISTORY 新增
	 * @param dto
	 * @return
	 */
	int addHistory(GeneralPunishmentHistoryDTO dto);
	
	/**
	 * QLC_GENERAL_PUNISHMENT_HISTORY 修改
	 * @param dto
	 * @return
	 */
	int updateHistory(GeneralPunishmentHistoryDTO dto);
	
	/**
	 * QLC_GENERAL_PUNISHMENT 删除
	 * @param pre_report_no
	 * @return
	 */
	int delete(String pre_report_no);
	
	/**
	 * QLC_GENERAL_PUNISHMENT_HISTORY 删除
	 * @param pre_report_no
	 * @return
	 */
	int deleteHistory(GeneralPunishmentHistoryDTO dto);
	
	/**
	 * 查询 1.文档类型 2.业务主键 查询doc
	 * @param paramMap
	 * @return
	 */
	CheckDocsRcdDTO findDocByTypeNMainId(Map<String, Object> paramMap);
	
	/**
	 * 查询 1.文档类型 2.业务主键 查询doc
	 * @param paramMap
	 * @return
	 */
	int findDocCountByTypeMainId(Map<String, Object> paramMap);
	
	/**
	 * 新增文档
	 * @param dto
	 * @return
	 */
	int addDoc(CheckDocsRcdDTO dto);
	
	/**
	 * 修改文档
	 * @param dto
	 * @return
	 */
	int updateDoc(CheckDocsRcdDTO dto);
	
	/**
	 * 获取文件列表
	 * @param map
	 * @return
	 */
	List<VideoFileEventModel> videoFileEventList(Map<String, String> map);
	
	/**
	 * 保存附件
	 * @param dto
	 * @return
	 */
	int saveFile(FileInfoDto dto);
	
	/**
	 * 查询附件
	 * @param main_id
	 * @return
	 */
	FileInfoDto findFile(FileInfoDto dto);
	
	/**
	 * 修改附件
	 * @param dto
	 * @return
	 */
	int updateFile(FileInfoDto dto);
	
	/**
	 * 案件被移送完结时删除
	 * @param dto
	 * @return
	 */
	int deleteHistoryWhenFinished(GeneralPunishmentHistoryDTO dto);
	
	/**
	 * 审核通过
	 * @param dto 当前环节表记录
	 * @param currGp 当前主表记录
	 * @return
	 */
	AjaxResult adoptStep(GeneralPunishmentHistoryDTO dto,GeneralPunishmentDTO currGp,String nextStep);
	
	/**
	 * 查询文档是否填写
	 * @param map
	 * @return
	 */
	int findDocByHisoryDocId(Map<String, Object> map);
	
	/**sql 拼接*/
	String getWhereSql(List<QueryBaseIo> list);
	
	List<Map<String,String>> findPunishList(LocalePunishDTO dto);
	
	/**
	 * 部门受理局
	 * @return
	 */
	List<SelectModel> findOrgList();
	
	List<SelectModel> findSBOrgList();
	
}
