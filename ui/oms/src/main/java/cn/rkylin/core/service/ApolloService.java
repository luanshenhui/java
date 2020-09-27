package cn.rkylin.core.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageInfo;

import cn.rkylin.core.ApolloRet;
import cn.rkylin.core.ApolloUtil;
import cn.rkylin.core.IDataBaseFactory;
import cn.rkylin.core.utils.HttpRequester.MethodEnum;
import cn.rkylin.oms.common.export.IExport;
import cn.rkylin.core.utils.HttpRespons;

@Service("commonService")
public class ApolloService implements IExport {

	@Autowired
	@Qualifier("dataBaseFactory")
	private IDataBaseFactory dataBaseFactory;

	@SuppressWarnings("rawtypes")
	public List findForList(Map<String, Object> reqMap) throws Exception {

		String index = (String) reqMap.get(ApolloUtil.INDEX_PARAM);
		if (index == null)
			return null;
		return dataBaseFactory.findForList(index, reqMap);
	}

	public <E> List<E> findForList(String pageStatement, String quickSearch) throws Exception {
		if (StringUtils.isEmpty(pageStatement)) {
			return null;
		}
		List<E> returnList = dataBaseFactory.findList(pageStatement, quickSearch);
		return returnList;
	}
	
	public <E> List<E> findForList(String pageStatement, Map reqMap) throws Exception {
		if (StringUtils.isEmpty(pageStatement)) {
			return null;
		}
		List<E> returnList = dataBaseFactory.findList(pageStatement, reqMap);
		return returnList;
	}

	public <E> List<E> findPage(String pageStatement, E paramObj) throws Exception {
		if (StringUtils.isEmpty(pageStatement)) {
			return null;
		}
		List<E> returnList = dataBaseFactory.findAllList(pageStatement, paramObj);
		return returnList;
	}
	
	public HttpRespons getApiData(Map<String, Object> reqMap) throws Exception {
		String index = (String) reqMap.get(ApolloUtil.INDEX_PARAM);
		if (index == null)
			return null;
		return dataBaseFactory.callService(index, reqMap, MethodEnum.post);
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Map findByPage(int pageNo, int pageSize, Map reqMap) throws Exception {

		String index = (String) reqMap.get(ApolloUtil.INDEX_PARAM);
		if (index == null)
			return null;

		PageInfo<ApolloRet> list = dataBaseFactory.findByPage(pageNo, pageSize, index, reqMap);
		Map result = new HashMap();
		result.put("rows", list.getList());
		result.put("pageSize", list.getPageSize());
		result.put("pageNo", list.getPageNum());
		result.put("total", list.getTotal());
		return result;
	}

	public <E> PageInfo<E> findPage(int pageNo, int pageSize, String pageStatement, E paramObj) throws Exception {
		if (StringUtils.isEmpty(pageStatement)) {
			return null;
		}
		PageInfo<E> returnList = dataBaseFactory.findPage(pageNo, pageSize, pageStatement, paramObj);
		return returnList;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Map getMapInfo(int pageNo, int pageSize, Map reqMap) throws Exception {

		String index = (String) reqMap.get(ApolloUtil.INDEX_PARAM);
		if (index == null)
			return null;

		PageInfo<ApolloRet> list = dataBaseFactory.findByPage(pageNo, pageSize, index, reqMap);
		Map result = new HashMap();
		result.put("data", list.getList());
		return result;
	}

	/**
	 * 用于导出excel文件
	 */
	@Override
	public <E> List<E> execExport(String pageStatement, Map reqMap) throws Exception {
		return findForList(pageStatement, reqMap);
	}
}
