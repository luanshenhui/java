package com.dpn.ciqqlc.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.dpn.ciqqlc.common.util.Constants;
import com.dpn.ciqqlc.standard.model.ExpFoodProdPsnRdmDTO;
import com.dpn.ciqqlc.standard.model.SelectModel;
import com.dpn.ciqqlc.standard.model.UserInfoDTO;
import com.dpn.ciqqlc.standard.service.AppServerDbService;

@Repository("appServerDbServ")
public class AppServerDb implements AppServerDbService{
	
	 /**
     * sqlSession.
     * @since 1.0.0
     */
    @Autowired
    @Qualifier("blankSST")
    private SqlSession sqlSession = null;
    
    /******************************************************************************************************************************
     * 
     ******************************************************************************************************************************/
    
	public void insertResults(List<Map<String, String>> list) throws Exception {
		for(Map<String,String> item:list){                                                                //循环insert数据
//			item.put("opr_user", "操作人");
			sqlSession.insert("SQL.APPS.insertResults",item);
		}
	}
    
    /******************************************************************************************************************************
     * 
     ******************************************************************************************************************************/
	public Map<String, String> selectResults(Map<String, String> map)throws Exception {
		return sqlSession.selectOne("SQL.APPS.selectResults", map);
	}

	/******************************************************************************************************************************
     * 
     ******************************************************************************************************************************/
	public List<SelectModel> selectCodes(String type) throws Exception {
		return sqlSession.selectList("SQL.APPS.selectCodes", type);
	}

	/**
	 *  查找code跟name
	 * @param type 字典表Tpye
	 * @return 证件下拉列表
	 */	
	public List<SelectModel> findNameAndCode(String type) {
		List<SelectModel> list = null;
		list = this.sqlSession.selectList("SQL.COMM.listCodeName",type);
		return  list;
	}

	/**
	 * 查找当前人科室
	 * @param request
	 * @param dept_code
	 * @return
	 */
	public List<SelectModel> findDeptCode(HttpServletRequest request,String dept_code) {
		UserInfoDTO user=(UserInfoDTO)request.getSession().getAttribute(Constants.USER_KEY);
		if(null!=user){
			user.setDept_code(dept_code);
			return this.sqlSession.selectList("SQL.COMM.findDeptCode",user);
		}else{
			return new ArrayList<SelectModel>();
		}
	}

	public void updateRadmPerson(ExpFoodProdPsnRdmDTO ePsnRdm) {
		sqlSession.update("SQL.EXPFOODPOF.updateRadmPerson",ePsnRdm);
	}
}
