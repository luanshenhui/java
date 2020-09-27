package com.dpn.ciqqlc.standard.service;

import java.util.List;
import java.util.Map;

import com.dpn.ciqqlc.standard.model.CheckDocsRcdDTO;
import com.dpn.ciqqlc.standard.model.DeclarationDTO;
import com.dpn.ciqqlc.standard.model.HlthCheckDTO;
import com.dpn.ciqqlc.standard.model.ImageDTO;
import com.dpn.ciqqlc.standard.model.MailSteamerChkDealDTO;
import com.dpn.ciqqlc.standard.model.MailSteamerChkDealModel;
import com.dpn.ciqqlc.standard.model.MailSteamerDTO;
import com.dpn.ciqqlc.standard.model.MailSteamerHlthCheckModel;
import com.dpn.ciqqlc.standard.model.MailSteamerResultDTO;
import com.dpn.ciqqlc.standard.model.MailSteamerRmkDTO;
import com.dpn.ciqqlc.standard.model.MailSteamerSampDTO;
/**
 * @author
 * @since 1.0.0
 * @version 1.0.0
 */
/**************************************************************************
 * 进出境运输工具检疫（邮轮）
 **************************************************************************/

public interface MailSteamerService {
	/**
	 * 根据传入的搜索条件 查询进出境运输工具检疫（邮轮）列表页执法全过程记录查询
	 * @param map
	 * @return
	 * @throws Exception
	 */
   public List<MailSteamerDTO> findEnforcementprocessList(Map<String, String> map) throws Exception;

	/**
	 * 根据传入的搜索条件 查询进出境运输工具检疫（邮轮）记录总条数执法全过程记录查询
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int findEnforcementprocessCount(Map<String, String> map) throws Exception;
	
	/**
	 * 根据传入的ID条件 查询进出境运输工具检疫（邮轮）单条详细记录
	 * @param processId
	 * @return
	 * @throws Exception
	 */
	public 	Map<String, String>  findEnforcementprocessById(String processId) throws Exception;	
	
	/**
	 * 根据进出境运输工具检疫（邮轮）的业务主键查询该详情页面所涉及的所有照片和视频 
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> getfileList(Map<String, String> map) throws Exception;
	/**
	 * 根据进出境运输工具检疫（邮轮）的业务主键查询该详情页面所涉及的所有doc
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> getDocList(Map<String, String> map) throws Exception;
	
	/**
	 * 根据传入的doc表格ID 查询该表格单条数据
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> processtemplate(String doc_id) throws Exception;
	
	
	/**
	 * 根据传入的搜索条件 查询进出境运输工具检疫（邮轮）列表页入境检疫申报查询
	 * @param map
	 * @return
	 * @throws Exception
	 */
   public List<DeclarationDTO> findDeclarationlist(Map<String, String> map) throws Exception;

	/**
	 * 根据传入的搜索条件 查询进出境运输工具检疫（邮轮）记录总条数入境检疫申报查询
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int findDeclarationCount(Map<String, String> map) throws Exception;
	
	
	/**
	 * 根据业务主键查询一般监督或专项监督列表页面
	 * @param map
	 * @return
	 * @throws Exception
	 */
   public List<HlthCheckDTO> getHlthcheckList(Map<String, String> map) throws Exception;
   
   /**
	 * 查询 1.文档类型 2.业务主键 查询doc
	 * @param paramMap
	 * @return
	 */
	public CheckDocsRcdDTO findDocByTypeNMainId(Map<String, String> paramMap);
   
   /**
	 * 根据传入的搜索条件 查询进出境运输工具检疫（邮轮）列表页邮轮业务卫生监督表查询
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HlthCheckDTO> findHlthchecklist(Map<String, String> map) throws Exception;

	/**
	 * 根据传入的搜索条件 查询进出境运输工具检疫（邮轮）记录总条数邮轮业务卫生监督表查询
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int findHlthcheckCount(Map<String, String> map) throws Exception;
	
	/**
	 * 根据传入的搜索条件 查询进出境运输工具检疫（邮轮）业务卫生监督表详情；
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<HlthCheckDTO> getHlthcheckdetail(Map<String, String> map) throws Exception;
	
	/**
	 * 
	 * @param dec_master_id
	 * @return
	 * @throws Exception
	 */
	public HlthCheckDTO getLatestCheck(String dec_master_id) throws Exception;
	
	/**
	 * 
	 * @param dec_master_id
	 * @return
	 * @throws Exception
	 */
	public MailSteamerSampDTO getLatestSamp(String dec_master_id) throws Exception;
	
	
	public MailSteamerChkDealDTO getLatestDeal(String dec_master_id) throws Exception;
	
	public List<Map<String, String>> getLastResult(String dec_master_id) throws Exception;
	
	/**
	 * 根据传入app的搜索条件 查询进出境运输工具检疫（邮轮）记录
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<MailSteamerDTO> findMailSteamerList(MailSteamerDTO mailsteamer) throws Exception;
	
	/**
	 * 根据id或dec_master_id查询邮轮表
	 * @param mailsteamer
	 * @return
	 * @throws Exception
	 */
	public MailSteamerDTO findMailSteamerOne(MailSteamerDTO mailsteamer) throws Exception;
	
	/**
	 * 根据传入传入id和环节类型查询
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<ImageDTO> getImgeList(Map<String, String> map)throws Exception;
	
	/**
	 * 根据传入的搜索条件 查询进出境运输工具检疫（邮轮）业务卫生监督表详情；
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> findHlthcheckdetail(Map<String, String> map) throws Exception;
	
	
	/**
	 * 单据数据存储邮轮业务检疫处理表
	 * */
	void insertMailChkDeal(MailSteamerChkDealModel mailSteamerChkDealModel);
	
	/**
	 * 单据数据存储邮轮业务卫生监督表
	 * */
	void insertMailHlthCheck(MailSteamerHlthCheckModel mailSteamerHlthCheckModel);
	
	/**
	 * 单据数据存储邮轮业务表（抽样）
	 * */
	void insertMailSamp(MailSteamerSampDTO mailSteamerSampDTO);
	
	/**
	 * 根据传入传入id邮轮业务表数据
	 * @param map
	 * @return
	 * @throws Exception
	 */
	
	public  MailSteamerRmkDTO findMailSteamerRmkByDecMasterId(String mailId);
	
	/**
	 * 接口文档3.27 - 邮轮检疫处理查询列表 
	 * @param dec_master_id
	 * @return
	 */
	public List<MailSteamerChkDealDTO> findMailSteamerChkDealList(String dec_master_id);
	
	/**
	 * 接口文档3.28 - 邮轮检疫处理新增
	 * @param mailSteamerChkDealDTO
	 */
	void insertMailChkDealSingle(MailSteamerChkDealDTO mailSteamerChkDealDTO);
	
	/**
	 * 邮轮业务表插入记录
	 * @param dto
	 */
	int insertMailSteamerRmk(MailSteamerRmkDTO dto);
	
	/**
	 * 邮轮业务表修改记录
	 * @param dto
	 * @return
	 */
	int updateMailSteamerRmkById(MailSteamerRmkDTO dto);
	
	/**
	 * 根据传入的搜索条件 查询进出境运输工具检疫（邮轮）采样
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<MailSteamerSampDTO> findSampList(Map<String, String> map) throws Exception;

	/**
	 * 根据传入的搜索条件 查询进出境运输工具检疫（邮轮）采样
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int findSampCount(Map<String, String> map) throws Exception;
	
	/**
	 * 查询检疫处理
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<MailSteamerChkDealDTO> findChkDealList(Map<String, String> map) throws Exception;

	/**
	 * 查询检疫处理记录数
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public int findChkDealCount(Map<String, String> map) throws Exception;
	
	/**
	 * 邮轮结果判定
	 * @param mailSteamerChkDealModel
	 */
	void insertMailResult(MailSteamerResultDTO dto);
	
	List<MailSteamerSampDTO> findSamp(String proc_main_id,String doc_type);
	
	MailSteamerChkDealModel findMailDeal(Map<String, String> paramMap);
	
	List<Map<String, String>> findClyj();
	
	List<Map<String, String>> findSampById(String proc_main_id);
	
	List<Map<String, String>> findChekDetail(String proc_main_id,String proc_type);
}
