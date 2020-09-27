package cn.com.cgbchina.common.utils;

import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

/**
 * Created by guixin1.ma on 2016/7/27.
 */
public class CollectionHelper {

	/**
	 * 通过比对key值获取Lists的交集（多对一）
	 *
	 * @param listMain       关联List
	 * @param keyMain        关联list-keys
	 * @param lists          被关联list
	 * @param keys		       被关联list-keys
	 * @param pageSize       每页显示条数
	 * @param pageDataAble  是否需要返回分页信息
	 *
	 * @return Map<String ,Object>
	 *     totalCount  分页信息-总条数
	 *     pageCount   分页信息-总页数
	 *     resultList  结果集
	 */
	public Map<String,Object> ProcessListsMany2One(List<Map<String ,Object>> listMain,
												  String [] keyMain,
												  List<Map<String ,Object>> [] lists,
												  String [] keys,
												  int startNum,
												  int pageSize,
												  boolean pageDataAble){
		if(pageSize == 0) pageSize = 999999999;
		Map<String ,Object> returnMap = new HashMap<String,Object>();
		List<Map<String ,Object>> resultList = new ArrayList<Map<String ,Object>>();
		int custNum = 0;
		for(int i = 0 ; i < listMain.size() ; i++){
			for(int s = 0 ; s < lists.length ; s++){
				String str = listMain.get(i).get(keyMain[s]).toString();
				List<Map<String ,Object>> list = lists[s];
				for(int j = 0 ; j < list.size() ; j++){
					String strs = list.get(j).get(keys[s]).toString();
					if(str.compareTo(strs) == 0){
						Iterator<Map.Entry<String, Object>> it = ((Map)list.get(j)).entrySet().iterator();
						while (it.hasNext()) {
							Entry<String, Object> entry = it.next();
							if(listMain.get(i).get(entry.getKey()) == null && !keys[s].equals(entry.getKey())  && entry.getValue() != null ){
								listMain.get(i).put(entry.getKey(), entry.getValue());
							}
						}

						if(s == lists.length - 1){
							if(custNum >= startNum && resultList.size() < pageSize){
								resultList.add(listMain.get(i));
								if(resultList.size() == pageSize && !pageDataAble){
									returnMap.put("resultList", resultList);
									return returnMap;
								}
							}
							custNum ++ ;
						}
					}
				}
			}
		}
		if(pageDataAble){
			int totalCount = custNum;
			int pageCount = 0;
			if(totalCount==0){
				pageCount=0;
			}else if(totalCount<=pageSize){
				pageCount=1;
			}else{
				if(totalCount%pageSize>0){
					pageCount=totalCount/pageSize+1;
				}else{
					pageCount=totalCount/pageSize;
				}
			}
			returnMap.put("totalCount", totalCount);
			returnMap.put("pageCount", pageCount);
		}
		returnMap.put("resultList", resultList);
		return returnMap;
	}

}
