package chinsoft.business;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

import org.apache.commons.lang.StringUtils;

import chinsoft.core.CVersion;
import chinsoft.core.DataAccessObject;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Dict1;

public class Dict1Manager {
	private static DataAccessObject dao = new DataAccessObject();
	private static List<Dict1> allDict1s = null;
	private static String LangCodeSequenceNo = "";
	
	private static ConcurrentMap<Integer, Dict1> allDict1sMap;
	
	public static void reloadDictById(String[] ids) {
		for (String id : ids) {
			Dict1 dict1 = getDict1FromDB(Integer.parseInt(id));
			if (dict1 != null) {
				allDict1sMap.put(dict1.getId(), dict1);
			} else {
				allDict1sMap.remove(id);
			}
		}
		allDict1s = new ArrayList<Dict1>(allDict1sMap.values());
		
		// sort by sequenceNO
		Collections.sort(allDict1s, new Comparator<Dict1>() {
			public int compare(Dict1 d1, Dict1 d2) {
				return d1.getSequenceno()- d2.getSequenceno();
			}
		});
	}

	public Dict1Manager() {
	}
	
	public static String getDict1NamesByIDs(String strDict1IDs) {
		String strNames = "";
		if (strDict1IDs != null && !"".equals(strDict1IDs)) {
			String[] strIDs = Utility.getStrArray(strDict1IDs);
			for (String strID : strIDs) {
				if (!"".equals(strNames)) {
					strNames += ",";
				}
				strNames += getDict1NameByID(Utility.toSafeInt(strID));
			}
		}
		return strNames;
	}

	public static String getDict1NameByID(Integer nDict1ID) {
		if (nDict1ID != null) {
			return ResourceHelper.getValue("Dict_" + nDict1ID);// resource对应名称：暂时与dict共用
		}
		return "";
	}


	/**
	 * 取得所有字典对象
	 */
	@SuppressWarnings("unchecked")
	private static List<Dict1> getAllDicts() {
		if (Dict1Manager.allDict1s == null) {
			Dict1Manager.allDict1s = (List<Dict1>) dao.getAll(Dict1.class,
					"SequenceNo");
			Dict1Manager.allDict1sMap = new ConcurrentHashMap<Integer, Dict1>();
			for (Dict1 dict1 : allDict1s) {
				Dict1Manager.allDict1sMap.put(dict1.getId(), dict1);
			}
		}

		String v = Utility.toSafeString(CVersion.getCurrentVersionID());
		if (!LangCodeSequenceNo.equals(v)) {
			for (Dict1 dict1 : Dict1Manager.allDict1s) {
				String strName = getDict1NameByID(dict1.getId());
				if (StringUtils.isNotEmpty(strName)) {
					dict1.setName(strName);
				}
			}
			LangCodeSequenceNo = v;
		}
		return Dict1Manager.allDict1s;
	}
	/**
	 * 从数据库中取得一个对象:管理用
	 */
	public static Dict1 getDict1FromDB(int nDict1ID) {
		return (Dict1) dao.getEntityByID(Dict1.class, nDict1ID);
	}
	/**
	 * 根据ID取得一个字典档
	 */
	public static Dict1 getDict1ByID(Integer nDict1ID) {
		Dict1 dict1 = null;
		if (nDict1ID <= 0) {
			return null;
		}
		try {
			if (allDict1sMap == null) {
				getAllDicts();
			}
			dict1 = allDict1sMap.get(nDict1ID);
		} catch (Exception e) {

		}
		if (dict1 != null) {
			return (Dict1) dict1.clone();
		} else {
			return null;
		}
	}

}
