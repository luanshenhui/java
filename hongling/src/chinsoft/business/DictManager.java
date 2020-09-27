package chinsoft.business;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringUtils;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.criterion.Restrictions;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.output.XMLOutputter;

import chinsoft.core.CVersion;
import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.CurableStyle;
import chinsoft.entity.Dict;
import chinsoft.entity.Lapel;
import chinsoft.entity.Userdictprice;

public class DictManager {
	private static DataAccessObject dao = new DataAccessObject();
	private static List<Dict> allDicts = null;
//	private static List<Dict> allDictsSortByID = null;
//	private static ArrayList<Integer> allDictIDs = null;
	private static String LangCodeSequenceNo = "";
//	private static String LangCodeSequenceID = "";
	
	private static ConcurrentMap<Integer, Dict> allDictsMap;
	
	public static void reloadDictById(String[] ids) {
		for (String id : ids) {
			Dict dict = getDictFromDB(Integer.parseInt(id));
			if (dict != null) {
				allDictsMap.put(dict.getID(), dict);
			} else {
				allDictsMap.remove(id);
			}
		}
		allDicts = new ArrayList<Dict>(allDictsMap.values());
		
		// sort by sequenceNO
		Collections.sort(allDicts, new Comparator<Dict>() {
			public int compare(Dict d1, Dict d2) {
				return d1.getSequenceNo() - d2.getSequenceNo();
			}
		});
	}

	// / <summary>
	// / 默认取得所有字典
	// / </summary>
	public DictManager() {

	}
	
	public static String getDictNamesByIDs(String strDictIDs) {
		String strNames = "";
		if (strDictIDs != null && !"".equals(strDictIDs)) {
			String[] strIDs = Utility.getStrArray(strDictIDs);
			for (String strID : strIDs) {
				if (!"".equals(strNames)) {
					strNames += ",";
				}
				strNames += getDictNameByID(Utility.toSafeInt(strID));
			}
		}
		return strNames;
	}

	public static String getDictNameByID(Integer nDictID) {
		if (nDictID != null) {
			return ResourceHelper.getValue("Dict_" + nDictID);
		}
		return "";
	}

	// / <summary>
	// / 取得所有字典对象
	// / </summary>
	// / <returns></returns>
	@SuppressWarnings("unchecked")
	private static List<Dict> getAllDicts() {
		if (DictManager.allDicts == null) {
			DictManager.allDicts = (List<Dict>) dao.getAll(Dict.class,
					"SequenceNo");
			DictManager.allDictsMap = new ConcurrentHashMap<Integer, Dict>();
			for (Dict dict : allDicts) {
				DictManager.allDictsMap.put(dict.getID(), dict);
			}
		}

		String v = Utility.toSafeString(CVersion.getCurrentVersionID());
		if (!LangCodeSequenceNo.equals(v)) {
			for (Dict dict : DictManager.allDicts) {
				String strName = getDictNameByID(dict.getID());
				if (StringUtils.isNotEmpty(strName)) {
					dict.setName(strName);
				}
			}
			LangCodeSequenceNo = v;
		}
		return DictManager.allDicts;
	}

	// / <summary>
	// / 取得所有字典对象
	// / </summary>
	// / <returns></returns>
	/*
	@SuppressWarnings("unchecked")
	private static List<Dict> getAllDictsSortByID() {
		if (DictManager.allDictsSortByID == null) {
			DictManager.allDictsSortByID = (List<Dict>) dao.getAll(Dict.class,
					"ID");
		}

		String v = Utility.toSafeString(CVersion.getCurrentVersionID());
		if (!LangCodeSequenceID.equals(v)) {
			for (Dict dict : DictManager.allDictsSortByID) {
				String strName = getDictNameByID(dict.getID());
				if (StringUtils.isNotEmpty(strName)) {
					dict.setName(strName);
				}
			}
			LangCodeSequenceID = v;
		}

		return allDictsSortByID;
	}

	private static ArrayList<Integer> getAllDictIDs() {
		if (DictManager.allDictIDs == null
				|| DictManager.allDictIDs.size() <= 0) {
			DictManager.allDictIDs = new ArrayList<Integer>();
			List<Dict> allDictsSortByIDs = DictManager.getAllDictsSortByID();
			for (Dict dict : allDictsSortByIDs) {
				DictManager.allDictIDs.add(dict.getID());
			}
		}
		return DictManager.allDictIDs;
	}
	*/

	public static void DictToResource(Integer nVersionID) {
		@SuppressWarnings("unchecked")
		List<Dict> dicts = (List<Dict>) dao.getAll(Dict.class, "ID");
		;
		if (dicts == null || dicts.size() == 0) {
			LogPrinter.error("Dict表为空！");
			return;
		}
		String strResourceFileName = ResourceHelper.getResourceDictFileName();
		if (strResourceFileName.length() == 0) {
			LogPrinter.error("生成XML路径为空:" + strResourceFileName);
		}
		// 创建XML根节点 root;
		Element root = new Element("root");
		root.setAttribute("version", "1.0");
		// 根节点添加到文档中；
		Document Doc = new Document(root);
		for (Dict dict : dicts) {
			root.addContent("\n");
			root.addContent("\t");
			String id = "Dict_" + dict.getID();
			String strName = dict.getName().trim();
			if (CVersion.En.getID().equals(nVersionID)) {
				strName = Utility.toSafeString(dict.getEn()).trim();
			}
			if (CVersion.De.getID().equals(nVersionID)) {
				strName = Utility.toSafeString(dict.getDe()).trim();
			}
			if (CVersion.Fr.getID().equals(nVersionID)) {
				strName = Utility.toSafeString(dict.getFr()).trim();
			}
			if (CVersion.Ja.getID().equals(nVersionID)) {
				strName = Utility.toSafeString(dict.getJa()).trim();
			}
			// 创建节点 data;
			Element data = getXMLElement(id, strName);
			root.addContent(data);
		}
		root.addContent("\n");
		XMLOutputter XMLOut = new XMLOutputter();

		try {
			XMLOut.output(Doc, new FileOutputStream(strResourceFileName));
		} catch (FileNotFoundException e) {
			LogPrinter.error("没有找到文件：" + strResourceFileName + ","
					+ e.getMessage());
		} catch (IOException e) {
			LogPrinter.error("生成XML文件出错：" + strResourceFileName + ","
					+ e.getMessage());
		}

	}

	private static Element getXMLElement(String id, String strName) {
		Element data = new Element("data");
		data.addContent("\n");
		data.addContent("\t");
		data.addContent("\t");
		data.setAttribute("name", id);
		Element value = new Element("value");
		value.addContent(strName);
		data.addContent(value);
		data.addContent("\n");
		data.addContent("\t");
		return data;
	}

	// / <summary>
	// / 清除内存中的字典档
	// / </summary>
//	public static void clear() {
//		DictManager.allDicts = null;
//	}

	public static boolean haveChildDict(int nDictID) {
		List<Dict> all = getAllDicts();
		for (Dict dict : all) {
			if (dict.getParentID() == nDictID) {
				return true;
			}
		}
		return false;
	}

	// / <summary>
	// / 根据分类取得字典列表
	// / </summary>
	// / <param name="dictCategory"/>
	// / <returns></returns>
	public static List<Dict> getDicts(int nCategoryID) {
		List<Dict> dicts = new ArrayList<Dict>();

		for (Dict dict : DictManager.getAllDicts()) {
			if (dict.getCategoryID() == nCategoryID) {
				dicts.add((Dict) dict.clone());
			}
		}

		return dicts;
	}

	// / <summary>
	// / 从DICT表中取得相应类别字典档集合,取多级别的用该函数.第一级别.nParentID为0
	// / </summary>
	// / <param name="dictCategory"/>
	// / <returns></returns>
	public static List<Dict> getDicts(int nCategoryID, int nParentID) {

		List<Dict> dicts = new ArrayList<Dict>();
		List<Dict> dictsByCategoryID = getDicts(nCategoryID);
		for (Dict dict : dictsByCategoryID) {
			if (dict.getParentID() == nParentID) {
				dicts.add((Dict) dict.clone());
			}
		}

		return dicts;
	}

	public static Dict getTopDictBySub(Integer nSubDictID) {
		Dict sub = DictManager.getDictByID(nSubDictID);
		if (sub != null) {
			List<Dict> dicts = DictManager.getDicts(sub.getCategoryID(), 0);
			for (Dict dict : dicts) {
				if (dict.getCode().equals(sub.getCode().subSequence(0, 4))) {
					return (Dict) dict.clone();
				}

			}
		}
		return null;
	}

	// / <summary>
	// / 根据ID取得一个字典档
	// / </summary>
	// / <param name="strDictID"/>
	// / <returns></returns>
	public static Dict getDictByID(Integer nDictID) {
		Dict dict = null;
		if (nDictID <= 0) {
			return null;
		}
		try {
//			int nIndex = Collections.binarySearch(DictManager.getAllDictIDs(),
//					nDictID);
//			dict = DictManager.getAllDictsSortByID().get(nIndex);
			if (allDictsMap == null) {
				getAllDicts();
			}
			dict = allDictsMap.get(nDictID);
		} catch (Exception e) {

		}
		if (dict != null) {
			return (Dict) dict.clone();
		} else {
			return null;
		}

	}

	// / <summary>
	// / 从数据库中取得一个对象:管理用
	// / </summary>
	// / <param name="?"/>
	// / <returns></returns>
	public static Dict getDictFromDB(int nDictID) {
		return (Dict) dao.getEntityByID(Dict.class, nDictID);
	}

	// / <summary>
	// / 根据ID删除一个字典档
	// / </summary>
	// / <param name="nDictID"/>
	public void deleteDictFromDB(int nDictID) {
		dao.remove(Dict.class, nDictID + "");
	}

	// 设置编码
	private Dict setCode(Dict dict, Session session) {
		// 根据ParentID和CategoryID取得当前级别最大的编码

		String hql = " SELECT MAX(Code) FROM Dict  WHERE ParentID = ? AND PategoryID = ? ";
		SQLQuery query = session.createSQLQuery(hql);
		query.setInteger(0, dict.getParentID());
		query.setInteger(1, dict.getCategoryID());
		String MAXcode = (String) query.uniqueResult();
		String strCode;
		// 如果当前级别最大编码不存在,则设置为ParentCode + 0001
		if (MAXcode == null || MAXcode.length() < 4) {
			Dict parentDict = (Dict) (session.createCriteria(Dict.class)
					.add(Restrictions.eq("ParentID", dict.getParentID()))
					.list().get(0));
			if (parentDict != null) {
				strCode = parentDict.getCode();
			} else {
				strCode = "";
			}

			strCode += "0001";
		} else {
			// 原来的Code+1
			String strTemp = "0000"
					+ Integer.parseInt(MAXcode.substring(MAXcode.length() - 4,
							MAXcode.length())) + 1;
			strTemp = strTemp.substring(strTemp.length() - 4, strTemp.length());
			strCode = MAXcode.substring(0, MAXcode.length() - 4) + strTemp;
		}
		dict.setCode(strCode);

		return dict;
	}

	// / <summary>
	// / 保存一个字典当
	// / </summary>
	// / <param name="DICT"/>
	public void saveDict(Dict dict) {
		Transaction transaction = null;
		Session session = null;
		try {
			session = DataAccessObject.openSession();
			transaction = session.beginTransaction();
			if (dict.getID() == 0) {
				// 设置编码,只是新增时需要设置
				setCode(dict, session);
				dao.save(session, dict);
			} else {
				dao.update(session, dict);
			}
			transaction.commit();
		} catch (Exception e) {
			transaction.rollback();
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
	}
	
	public void saveDicts(Dict dict) {
		Transaction transaction = null;
		Session session = null;
		try {
			session = DataAccessObject.openSession();
			transaction = session.beginTransaction();
			dao.save(session, dict);
			transaction.commit();
		} catch (Exception e) {
			transaction.rollback();
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
	}

	// 根据ParentID取值
	public List<Dict> getDictByKeyword(int nParentID, String strKeyword) {
		List<Dict> dictList = DictManager.getDicts(1, nParentID);
		List<Dict> newList = new ArrayList<Dict>();
		for (Dict dict : dictList) {
			if (dict.getEcode().toLowerCase().startsWith(strKeyword)) {
				newList.add(dict);
			}
		}
		return CurrentInfo.getAuthorityFunction(newList);
	}

	// 根据前面扣和驳头型得到对应的驳头宽
	@SuppressWarnings({ "static-access", "unchecked" })
	public String getLapelWidthId(String strFrontButtonId,
			String strLapelStyleId) {
		List<Lapel> list = null;
		Query query = dao
				.openSession()
				.createQuery(
						"FROM Lapel l where l.buttonID =:buttonID  and l.lapelID =:lapelID ");
		query.setInteger("buttonID", Utility.toSafeInt(strFrontButtonId));
		query.setInteger("lapelID", Utility.toSafeInt(strLapelStyleId));
		list = query.list();
		Lapel lapel = list.get(0);
		String strLapelWidthId = Utility.toSafeString(lapel.getWidthID());
		return strLapelWidthId;

	}

	/**
	 * 获取发货周期，去掉周天
	 * 
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Dict> getApplyDeliveryDays() {
		List<Dict> list = new ArrayList<Dict>();
		String hql = "From Dict d WHERE d.CategoryID=:CategoryID AND d.ID<>:ID";

		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setInteger("CategoryID",
					CDict.DICT_CATEGORY_APPLY_DELIVERY_DAYS);
			query.setInteger("ID", CDict.Sunday.getID());
			list = query.list();
		} catch (HibernateException e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return list;
	}

	/**
	 * 获取没有关联指定面料价格的经营单位
	 * 
	 * @param code
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Dict> getAreaNoPrice(String code) {
		List<Dict> list = new ArrayList<Dict>();
		String sql = "From Dict d WHERE d.CategoryID=49 and not exists(select 1 from FabricPrice f where f.FabricCode=:code and d.ID=f.AreaId)";
		try {
			Query query = DataAccessObject.openSession().createQuery(sql);
			query.setString("code", code);
			list = query.list();
		} catch (HibernateException e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return list;
	}

	@SuppressWarnings("unchecked")
	public List<Userdictprice> getDictPrices(int nPageIndex, int pageSize,
			String strMemberName, String strCode) {
		List<Userdictprice> list = new ArrayList<Userdictprice>();
		StringBuffer hql = new StringBuffer();
		hql.append(" FROM Userdictprice up where up.username=:strMemberName");
		try {
			if (strCode != null) {
				hql.append(" AND up.code like :strCode");
			}
			Query query = DataAccessObject.openSession().createQuery(
					hql.toString());
			query.setString("strMemberName", strMemberName);
			if (strCode != null) {
				query.setString("strCode", "%" + strCode + "%");
			}
			list = query.list();
		} catch (HibernateException e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return list;
	}

	public long getDictPriceCount(String strMemberName, String strCode) {
		long count = 0;
		StringBuffer hql = new StringBuffer();
		hql.append("SELECT COUNT(*)  FROM Userdictprice up where up.username=:strMemberName");
		try {
			if (strCode != null) {
				hql.append(" AND up.code like :strCode");
			}
			Query query = DataAccessObject.openSession().createQuery(
					hql.toString());
			query.setString("strMemberName", strMemberName);
			if (strCode != null) {
				query.setString("strCode", "%" + strCode + "%");
			}
			count = Utility.toSafeLong(query.uniqueResult());
		} catch (HibernateException e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return count;
	}

	public String removeDictPrice(String removeID) {
		if (removeID.equals("")) {
			return "请选择待删除项";
		}

		Transaction transaction = null;
		Session session = null;
		try {
			session = DataAccessObject.openSession();
			transaction = session.beginTransaction();
			String hql = "DELETE Userdictprice where id=:removeID";
			Query query = session.createQuery(hql);
			query.setString("removeID", removeID);
			query.executeUpdate();
			transaction.commit();
			return Utility.RESULT_VALUE_OK;
		} catch (Exception e) {
			transaction.rollback();
			LogPrinter.error(e.getMessage());
			return e.getMessage();
		} finally {
			DataAccessObject.closeSession();
		}
	}

	// 添加&修改工艺价格
	public void saveDictPrice(Userdictprice userdictprice) {
		dao.saveOrUpdate(userdictprice);
	}

	// 获取款式工艺
	public static List<CurableStyle> getStyleNumByID(String strID) {
		List<CurableStyle> curableStyles = new ArrayList<CurableStyle>();
		String hql = "From CurableStyle d WHERE d.Ecode=:Ecode AND d.Status =7 AND d.CloseStatus = 0 AND d.LockStatus =0";
		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString("Ecode", strID);
			curableStyles = query.list();
		} catch (HibernateException e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return curableStyles;
	}

	/**
	 * 获取款式工艺,处理代码拆分的
	 * 
	 * @param strID
	 * @return
	 */
	public static List<CurableStyle> getStyleNumByID2(String strID) {
		List<CurableStyle> curableStyles = new ArrayList<CurableStyle>();
		List<CurableStyle> targetList = new ArrayList<CurableStyle>();
		String hql = "From CurableStyle d WHERE d.Ecode=:Ecode AND d.Status = 7 AND d.CloseStatus = 0 AND d.LockStatus = 0";
		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString("Ecode", strID);
			curableStyles = query.list();
		} catch (HibernateException e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		// 处理代码拆分 删除原来的一条 添加一个list
		List<CurableStyle> tempCurableStyleList;
		try {
			if (!curableStyles.isEmpty()) {
				for (CurableStyle tempCurableStyle : curableStyles) {
					tempCurableStyleList = findCurableStyleBySplitEcode(tempCurableStyle
							.getCode());
					if (!tempCurableStyleList.isEmpty()) {
						// curableStyles.remove(tempCurableStyle);
						targetList.addAll(tempCurableStyleList);
					} else {
						targetList.add(tempCurableStyle);
					}
				}
			}
		} catch (Exception e) {
			LogPrinter.info("款式表中数据不正确");
		}
		return targetList;
	}

	/**
	 * 处理代码拆分的，返回拆分后的款式工艺list
	 * 
	 * @param ecode
	 * @return
	 */
	private static List<CurableStyle> findCurableStyleBySplitEcode(String ecode) {
		List<CurableStyle> curableStyles = new ArrayList<CurableStyle>();
		String splitCodes = new EcodeRedirectManager()
				.findCodesBySplitEcode(ecode);
		CurableStyle temp;
		if (null != splitCodes && !"".equals(splitCodes)) {
			// ecode,ecode如果dict里没再此ecode的数据，再查是否是代码拆分的
			if (!dicthasecode(ecode) && splitCodes.indexOf(",") > 0) {
				String[] ecodeArr = splitCodes.split(",");
				for (String tempEcode : ecodeArr) {
					temp = new CurableStyle();
					temp.setCode(tempEcode);
					curableStyles.add(temp);
				}
			}
		}
		return curableStyles;
	}

	/**
	 * 判断dict中是否有 此代码 的工艺，如果有则不拆分
	 * 
	 * @param ecode
	 * @return
	 */
	private static boolean dicthasecode(String ecode) {
		long count = 0;
		StringBuffer hql = new StringBuffer();
		hql.append("SELECT COUNT(*)  FROM Dict d where d.Ecode = '" + ecode
				+ "'");
		try {
			Query query = DataAccessObject.openSession().createQuery(
					hql.toString());
			count = Utility.toSafeLong(query.uniqueResult());
			if (count > 0) {
				return true;
			}
			return false;
		} catch (HibernateException e) {
			return false;
		} finally {
			DataAccessObject.closeSession();
		}
	}

	// 拼接款式号内容
	public static String getStyleNumHtml(List<CurableStyle> curableStyles,
			int nLastIndex, int clothingID) {
		String tempString;
		StringBuffer strHtml = new StringBuffer();
		Dict clothingDict = DictManager.getDictByID(clothingID);
		List<Dict> dicts = DictManager.getAllDicts();
		String[] embroidColor ="422,2213,3631,4150,6404,5088,95040,98031".split(",");
		for (CurableStyle style : curableStyles) {
			nLastIndex++;
			for (Dict dict : dicts) {
				Dict parent = DictManager.getDictByID(dict.getParentID());
				StringBuffer stringBuffer = new StringBuffer(dict.getName());
				if (parent != null) {
					stringBuffer.insert(0, "<label>" + parent.getName()
							+ "</label> : ");
				}
				if (Utility.toSafeString(dict.getEcode()).equals(
						Utility.toSafeString(style.getCode()))
						&& clothingDict.getCode().equals(
								dict.getCode().substring(0, 4))) {
					// 去掉商标行
					if (null != style.getRemark() && 
							!"".equals(style.getRemark()) &&
							!"10008".equals(dict.getStatusID().toString())) {
						continue;
					}
					if (ArrayUtils.contains(embroidColor, dict.getParentID().toString())) {
						continue;
					}
					strHtml.append("<tr index='");
					strHtml.append(nLastIndex);
					strHtml.append("' id= 'category_ " + clothingID);
					// strHtml.append("_" + nLastIndex);
					strHtml.append("'><td id='stylesProc_");
					strHtml.append(nLastIndex);
					strHtml.append("'><input type='text'  disabled='disabled' id='component_");
					strHtml.append(clothingID + "_");
					strHtml.append(dict.getID());
					strHtml.append("'  value='");
					strHtml.append(style.getCode());
					strHtml.append("' style='width:130px;' class='textbox'/> <span style='color:#333;'>");
					strHtml.append(stringBuffer.toString());

					tempString = dict.getEcode();
					// 有备注指定工艺
					if ((!"".equals(style.getRemark())
							&& style.getRemark() != null) || (null!= dict.getStatusID() && "10008".equals(dict.getStatusID().toString()))) {

						// 指定工艺，去掉商标面料面
						if ("10008".equals(dict.getStatusID().toString())) {
							strHtml.append("<input id='category_textbox_");
							strHtml.append(dict.getID());
							strHtml.append("'  value='");
							strHtml.append(style.getRemark()==null?"":style.getRemark());
							strHtml.append("' class='textbox' type='text' style='width:150px'/>");
							strHtml.append(" </span></td><td onclick='$(this).parent().remove()' style='width:30px'><a class='remove'></a></td></tr>");
							break;
						}
					} else {
						strHtml.append(" </span></td><td onclick='$(this).parent().remove()' style='width:30px'><a class='remove'></a></td></tr>");
						break;
					}
				}
			}
		}
		return strHtml.toString();
	}
	public boolean checkEcode(String ecode) {
		long count = 0;
		StringBuffer hql = new StringBuffer();
		hql.append("SELECT COUNT(*)  FROM Dict d where d.Ecode = '" + ecode+ "'");
		try {
			Query query = DataAccessObject.openSession().createQuery(hql.toString());
			count = Utility.toSafeLong(query.uniqueResult());
			if (count > 0) {
				return true;
			}
			return false;
		} catch (HibernateException e) {
			return false;
		} finally {
			DataAccessObject.closeSession();
		}
	}
	
	public static List<CurableStyle> getStyleByCode(String StyleID){
		
		List<CurableStyle> curableStyles = new ArrayList<CurableStyle>();
		String hql = "From CurableStyle d WHERE d.Ecode=:Ecode";
		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString("Ecode", StyleID);
			curableStyles = query.list();
		} catch (HibernateException e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return curableStyles;
		
	}
	public static void delStyleByCode(String id){
		Transaction transaction = null;
		Session session = null;
		try {
			session = DataAccessObject.openSession();
			transaction = session.beginTransaction();
			String hql = "DELETE CurableStyle d WHERE d.Ecode=:Ecode";
			Query query = session.createQuery(hql);
			query.setString("Ecode", id);
			query.executeUpdate();
			transaction.commit();
		} catch (Exception e) {
			transaction.rollback();
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
	}
	
	public static int getStyleMaxID(){
		int num=0;
		
		try {
			String hql = "Select max(id) From CurableStyle";
			Query query = DataAccessObject.openSession().createQuery(hql);
			num = Utility.toSafeInt(query.uniqueResult());
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		
		return num;
		
	}
	public static void addStyleByCode(CurableStyle cs){
		dao.saveOrUpdate(cs);
	}
}
