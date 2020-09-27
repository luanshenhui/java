package cn.rkylin.apollo.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

//import com.sun.deploy.net.HttpResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import cn.rkylin.apollo.enums.BusinessExceptionEnum;
import cn.rkylin.core.ApolloMap;
import cn.rkylin.core.IDataBaseFactory;
import cn.rkylin.core.exception.BusinessException;
import cn.rkylin.core.utils.HttpRequester;
import cn.rkylin.core.utils.HttpRespons;

/**
 * Created by Admin on 2016/7/7.
 */

@Service
public class ProjectUserService {

	@Autowired
	private IDataBaseFactory dao;

	public int updateProjectUser(ApolloMap<String, Object> params) throws Exception {
		int r = dao.update("updateProjectUser", params);
		if (r != 1) {
			throw new BusinessException(BusinessExceptionEnum.ADD_DATA.getC(), "更新用户异常！");
		}
		return r;
	}

	/**
	 * 获取人员列表信息
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> queryOAUser(ApolloMap<String, Object> params) throws Exception {
		Map<String, Object> retMap = new HashMap<String, Object>();
		HttpRespons response = null;
		response = dao.callService(params.get("index") + "", params, HttpRequester.MethodEnum.get);
		JSONObject retJson = response.getJsonResult();
		JSONObject resultUserJson = retJson.getJSONObject("result");
		if (null != resultUserJson && resultUserJson.containsKey("rows")) {
			JSONArray rowArray = resultUserJson.getJSONArray("rows");
			retMap.put("rows", rowArray);
			retMap.put("total", resultUserJson.getString("total"));
			retMap.put("page", params.getString("limit"));
			retMap.put("pageNo", resultUserJson.getString("page"));
		}else{
			retMap.put("rows", "");
			retMap.put("total", "0");
			retMap.put("page", "0");
			retMap.put("pageNo", "0");
		}
		return retMap;
	}

	/**
	 * 根据项目增加人员
	 * 
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public int addProjectUser(ApolloMap<String, Object> params) throws Exception {
		List<Object> paramList = JSON.parseArray(params.get("userList") + "");
		List<Object> newParamList = new ArrayList<Object>();
		int result = 0;
		if (null != paramList && paramList.size() > 0) {
			for (Object obj : paramList) {
				Map<String, Object> paramMap = (Map<String, Object>) obj;
				if (null != paramMap.get("projectId") && null != paramMap.get("userId")) {
					List<Object> projectUserList = dao.findForList("findProjectUser", paramMap);
					if (null == projectUserList || projectUserList.size() <= 0) {
						newParamList.add(paramMap);
					}
				}

			}
		}
		if (null != newParamList && newParamList.size() > 0) {
			result = dao.insertBatch("inserProjectUserBatch", newParamList);
		}
		if (result != newParamList.size()) {
			throw new BusinessException(BusinessExceptionEnum.ADD_DATA.getC(), "批量新增用户异常！");
		}
		return result;
	}

	public int deleteProjUser(ApolloMap<String, Object> params) throws Exception {
		return dao.delete("deleteProjUserbyWhere", params);
	}

	public int updateProjectUserStatus(ApolloMap<String, Object> params) throws Exception {
		int result = dao.update("updateProjectUserStatus", params);
		if (result != 1) {
			throw new BusinessException(BusinessExceptionEnum.ADD_DATA.getC(), "更新用户异常！");
		}
		return result;
	}

}
