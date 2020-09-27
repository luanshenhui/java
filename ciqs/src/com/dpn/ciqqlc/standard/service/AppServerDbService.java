package com.dpn.ciqqlc.standard.service;

import java.util.List;
import java.util.Map;

import com.dpn.ciqqlc.standard.model.SelectModel;



/**
 * @author zhuqb
 * @since 1.0.0
 * @version 1.0.0
 */
/* *****************************************************************************
 * 备忘记录
 * -> 移动端访问接口
********************************************************************************
 * 变更履历
 * -> 
***************************************************************************** */
public interface AppServerDbService {
	/**************************************************************************************************
	 * 录入移动端结果的操作记录
	 * @param list
	 * @return
	 * @throws Exception
	 ***************************************************************************************************/
     public void insertResults(List<Map<String,String>>list) throws Exception;
     
     
     /**************************************************************************************************
 	 * 查询移动端录入的操作记录
 	 * @param map
 	 * @return
 	 * @throws Exception
 	 ***************************************************************************************************/
      public Map<String,String> selectResults(Map<String, String>map) throws Exception;
      
      
      /**************************************************************************************************
	  * 根据code 查询名称和值
	  * @param type
	  * @return
	  * @throws Exception
	  ***************************************************************************************************/
      public List<SelectModel> selectCodes(String type) throws Exception;
}
