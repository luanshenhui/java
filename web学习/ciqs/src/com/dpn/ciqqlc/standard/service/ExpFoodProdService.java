package com.dpn.ciqqlc.standard.service;

import java.util.List;
import java.util.Map;

import com.dpn.ciqqlc.http.form.ExpFoodProdForm;
import com.dpn.ciqqlc.standard.model.CheckDocsRcdDTO;
import com.dpn.ciqqlc.standard.model.EfpeApplyDTO;
import com.dpn.ciqqlc.standard.model.EfpeRegulatoryModel;
import com.dpn.ciqqlc.standard.model.ExpFoodProdCheckDto;
import com.dpn.ciqqlc.standard.model.ExpFoodProdDTO;
import com.dpn.ciqqlc.standard.model.ExpFoodProdPsnRdmDTO;
import com.dpn.ciqqlc.standard.model.ExpFoodProdReportDto;
import com.dpn.ciqqlc.standard.model.FileInfoDto;
import com.dpn.ciqqlc.standard.model.QlcEfpePsnDto;
import com.dpn.ciqqlc.standard.model.VideoFileEventModel;

public interface ExpFoodProdService {
	
	/**
	 * 条件查询列表
	 * @param map
	 * @return
	 */
	List<EfpeApplyDTO> findList(ExpFoodProdForm form);
	
	List<EfpeApplyDTO> findListApp(ExpFoodProdForm form);
	
	/**
	 * 条件查询记录数
	 * @param map
	 * @return
	 */
	int findListCount(ExpFoodProdForm form);
	
	/**
	 * 根据id查询
	 * @param id
	 * @return
	 */
	EfpeApplyDTO findById(String id);
	
	/**
	 * 添加记录
	 * @param dto
	 * @return
	 */
	int add(ExpFoodProdDTO dto);
	
	/**
	 * 查询 1.文档类型 2.业务主键 查询doc
	 * @param paramMap
	 * @return
	 */
	CheckDocsRcdDTO findDocByTypeNMainId(Map<String, String> paramMap);
	
	List<VideoFileEventModel> videoFileEventList(Map<String, String> map);
	
	
	/**
	 * 查找 随机人员信息
	 * @param foodProdPsnRdmDTO
	 * @return
	 */
	List<ExpFoodProdPsnRdmDTO> findByPseon(ExpFoodProdPsnRdmDTO foodProdPsnRdmDTO);
	
	/**
	 * 查找随机人员基础信息表
	 * @param foodProdPsnRdmDTO
	 * @return
	 * @throws Exception 
	 */
	List<ExpFoodProdPsnRdmDTO> findByBasePseon(ExpFoodProdPsnRdmDTO foodProdPsnRdmDTO) throws Exception;
	
	int insterPersonRdm(ExpFoodProdPsnRdmDTO foodProdPsnRdmDTO) throws Exception;
	/**
	 * 分页查询
	 * @param ExpFoodProdPsnRdmDTO
	 * @return
	 */
	int findPersonCount(ExpFoodProdPsnRdmDTO dto);

	/**
	 * 无分页查询列表
	 * @param dto
	 * @return
	 */
	List<ExpFoodProdPsnRdmDTO> findAllPseon(ExpFoodProdPsnRdmDTO dto);

	/**
	 * 知识库分页列表
	 * @param dto
	 * @return
	 * @throws Exception 
	 */
//	List<FileInfoDto> findFileInfo(FileInfoDto dto) throws Exception;

	/**
	 * 知识库数据数量
	 * @param dto
	 * @return
	 * @throws Exception 
	 */
//	int findFileCount(FileInfoDto dto) throws Exception;

	/**
	 * 知识库数据数量
	 * @param dto
	 * @return
	 * @throws Exception 
	 */
	void saveUpload(FileInfoDto dto) throws Exception;
	
	/**
	 * 企业监督检查表查询
	 * @param applyid
	 * @return
	 * @throws Exception
	 */
	List<ExpFoodProdCheckDto> findCheckList(String applyid) throws Exception;

	/**
	 * 人员随机获取
	 * @param dto
	 * @return
	 * @throws Exception 
	 */
	List<ExpFoodProdPsnRdmDTO> findRadmPeson(ExpFoodProdPsnRdmDTO dto) throws Exception;

	List<ExpFoodProdReportDto> findFoodProdReport (
			ExpFoodProdReportDto expFoodProdReport)throws Exception;

	List<QlcEfpePsnDto> findByBasePseon2(QlcEfpePsnDto efpePsn)throws Exception;

	List<EfpeRegulatoryModel> findEfpeRegulatoryList(EfpeRegulatoryModel form);

	int findEfpeRegulatoryListCount(EfpeRegulatoryModel form);

	List<EfpeRegulatoryModel> findEfpeRegulatory(
			EfpeRegulatoryModel efpeRegulatoryModel) throws Exception;

	List<EfpeRegulatoryModel> findEfpeRegulatoryAll(EfpeRegulatoryModel model);

	List<EfpeRegulatoryModel>  findEfpeRegulatoryAll2(EfpeRegulatoryModel form);

	
}
