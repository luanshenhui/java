package com.dpn.ciqqlc.standard.service;

import java.util.List;
import java.util.Map;

import com.dpn.ciqqlc.standard.model.DocTypeDTO;
import com.dpn.ciqqlc.standard.model.OrganizesDTO;
import com.dpn.ciqqlc.standard.model.VideoDTO;
import com.dpn.ciqqlc.standard.model.CheckDocsRcdDTO;
import com.dpn.ciqqlc.standard.model.VisualDeclareDTO;

/**
 * @author
 * @since 1.0.0
 * @version 1.0.0
 */
/* *****************************************************************************
 * 备忘记录
 * -> 进出境运输工具检疫（货轮）
********************************************************************************
 * 变更履历
 * -> 
***************************************************************************** */
public interface AffirmDbService {
	
		/**
		 * 根据传入的搜索条件 查询进出境运输工具检疫（货轮）列表页
		 * @param map
		 * @return
		 * @throws Exception
		 */
	   public List<VisualDeclareDTO> findTransports(Map<String, String> map) throws Exception;
	
		/**
		 * 根据传入的搜索条件 查询进出境运输工具检疫（货轮）记录总条数
		 * @param map
		 * @return
		 * @throws Exception
		 */
		public int findTransportsCount(Map<String, String> map) throws Exception;
		
		/**
		 * 根据传入的ID条件 查询进出境运输工具检疫（货轮）单条详细记录
		 * @param transportid
		 * @return
		 * @throws Exception
		 */
		public 	VisualDeclareDTO findTransportOne(String transportid) throws Exception;
		
		/**
		 * 根据进出境运输工具检疫（货轮）的业务主键查询该详情页面所涉及的所有照片和视频 
		 * @param map
		 * @return
		 * @throws Exception
		 */
		public 	List<VideoDTO> queryTransportFiles(Map<String, String> map) throws Exception;
		
		/**
		 * 根据进出境运输工具检疫（货轮）的业务主键查询该详情页面所涉及的所有doc
		 * @param map
		 * @return
		 * @throws Exception
		 */
		public 	List<DocTypeDTO> queryTransportTemplates(Map<String, String> map) throws Exception;
		
		/**
		 * 根据传入的搜索条件 查询进出境运输工具检疫（货轮）列表页
		 * @param map
		 * @return
		 * @throws Exception
		 */
		public  List<Map<String, String>> showTransportsApp(Map<String, String> map) throws Exception;
		
		/**
		 * 根据传入的doc表格ID 查询该表格单条数据
		 * @param map
		 * @return
		 * @throws Exception
		 */
		public CheckDocsRcdDTO transportsTemplate(String str) throws Exception;
		
		VisualDeclareDTO findVsvByVslDecId(VisualDeclareDTO dto);
		
		/**
		 * webService接口专用
		 * 插入货轮
		 * @param dto
		 * @return
		 */
		int insertVSL(VisualDeclareDTO dto);
		
		/**
		 * webService接口专用
		 * 修改货轮
		 * @param dto
		 * @return
		 */
		int updateVSL(VisualDeclareDTO dto);
}
