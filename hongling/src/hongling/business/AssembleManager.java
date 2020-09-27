package hongling.business;

import hongling.entity.Assemble;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import chinsoft.business.CDict;
import chinsoft.business.CDictCategory;
import chinsoft.business.CurrentInfo;
import chinsoft.business.DictManager;
import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;

public class AssembleManager {
	DataAccessObject dao = new DataAccessObject();

	/**
	 * 获取 服装 分类
	 * 
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Dict> findClothCategorys() {
		List<Dict> tempList = new ArrayList<Dict>();
		try {
			Query query = DataAccessObject
					.openSession()
					.createQuery(
							"from Dict t where t.CategoryID = 1 and length(t.Code) between 1 and 5 and t.ID not in(1,2,5000) order by t.ID ");

			tempList = query.list();
		} catch (HibernateException e) {
			tempList = null;
			e.printStackTrace();
		} finally {
			DataAccessObject.closeSession();
		}

		return tempList;
	}

	/**
	 * 根据 服装 id 获取 以下所有分类 查询树
	 * 
	 * @param id
	 *            服装分类ID
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Dict> findAssembleStyles(String id) {
		List<Dict> tempList = new ArrayList<Dict>();
		// System.out.println(id);

		try {
			Session session = DataAccessObject.openSession();
			tempList = session.createQuery(
					"from Dict t where t.ParentID= '" + id
							+ "' and t.Name like '%设计款式%'").list();

			Integer styleID = (tempList == null || tempList.isEmpty()) ? null
					: tempList.get(0).getID();

			tempList = session.createQuery(
					"from Dict t where t.ParentID= '" + id
							+ "' and t.Name like '%深度设计%'").list();

			Integer deepID = (tempList == null || tempList.isEmpty()) ? null
					: tempList.get(0).getID();

			String sql = "select * from dict t where (t.statusid is null or t.statusid != 10003) start with t.id = "
					+ styleID
					+ " or t.id = "
					+ deepID
					+ " connect by prior t.id = t.parentid and t.name not like '%版型%' order by t.id ";
			// System.out.println(sql);
			tempList = (List<Dict>) DataAccessObject.openSession()
					.createSQLQuery(sql)
					.setResultTransformer(Criteria.ALIAS_TO_ENTITY_MAP).list();
			// Integer size = tempList.size();
			// System.out.println(size);
		} catch (HibernateException e) {

			e.printStackTrace();
		} finally {
			DataAccessObject.closeSession();
		}
		return tempList;
	}

	/**
	 * 根据 服装ID 获取 其款式风格
	 * 
	 * @param id
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Dict> getStyleByClothingId(String id) {
		List<Dict> dictList = new ArrayList<Dict>();
		String sql = "select * from dict t where t.parentid = (select t.id from dict t where t.parentid = "
				+ id + " and t.name like '%款式分类%')";
		try {
			dictList = (List<Dict>) DataAccessObject.openSession()
					.createSQLQuery(sql)
					.setResultTransformer(Criteria.ALIAS_TO_ENTITY_MAP).list();
		} catch (HibernateException e) {
			dictList = null;
			e.printStackTrace();
		} finally {
			DataAccessObject.closeSession();
		}
		return dictList;
	}

	/**
	 * 根据ID 查询对应组合 返回的实体 已以 特殊工艺进行处理
	 * 
	 * @param id
	 * @return
	 */
	public Assemble findAssembleById(Integer id) {
		Assemble assemble = (Assemble) DataAccessObject.openSession().load(
				Assemble.class, id);
		String str = assemble.getSpecialProcess();
		str = this.parseSpecialProcess(str);
		assemble.setSpecialProcess(str);
		return assemble;
	}

	@SuppressWarnings("unchecked")
	public Dict getDictByID(Integer nDictID) {
		List<Dict> tempList = null;
		Dict dict = null;
		try {
			if (null != nDictID && !"".equals(nDictID)) {
				Query query = DataAccessObject.openSession().createQuery(
						"from Dict t where t.ID = " + nDictID);
				tempList = query.list();
				if (null != tempList && !tempList.isEmpty()) {
					dict = tempList.get(0);
				}
			}

		} catch (HibernateException e) {
			e.printStackTrace();
		} finally {
			DataAccessObject.closeSession();
		}
		return dict;
	}

	/**
	 * 保存添加
	 * 
	 * @param assemble
	 */
	public void saveAssemble(Assemble assemble) {
		Transaction transaction = null;
		Session session = null;
		try {
			session =DataAccessObject.openSessionFactory().openSession();
			transaction = session.beginTransaction();
			dao.save(session, assemble);
			transaction.commit();
		} catch (HibernateException e) {
			e.printStackTrace();
			transaction.rollback();
			// LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
	}

	/**
	 * 批量保存
	 * 
	 * @param assembles
	 */
	public void saveAssembleList(List<Assemble> assembles) {

		Session session = DataAccessObject.openSession();
		Transaction tx = session.beginTransaction();
		try {
			for (int i = 0; i < assembles.size(); i++) {
				session.saveOrUpdate(assembles.get(i));
				if (i % 20 == 0) {
					// 20，与JDBC批量设置相同
					// 将本批插入的对象立即写入数据库并释放内存
					session.flush();
					session.clear();
				}
			}

		} catch (HibernateException e) {
			tx.rollback();
			e.printStackTrace();
		}
		tx.commit();
		session.close();
	}

	/**
	 * 修改更新款式组合
	 * 
	 * @param assemble
	 */
	public void updateAssemble(Assemble assemble) {
		Transaction transaction = null;
		Session session = null;
		try {
			session =DataAccessObject.openSessionFactory().openSession();
			transaction = session.beginTransaction();
			dao.update(session, assemble);
			transaction.commit();
		} catch (HibernateException e) {
			e.printStackTrace();
			transaction.rollback();
			// LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
	}

	/**
	 * 查询所有 有 款式设计
	 * 
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Assemble> findAllAssembles() {
		List<Assemble> tempList = new ArrayList<Assemble>();
		String hql = "from Assemble ab where ab.status='1' ORDER BY ab.createTime desc,id desc";
		try {
			Query query = (Query) DataAccessObject.openSession().createQuery(
					hql);

			tempList = query.list();
		} catch (HibernateException e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return tempList;
	}

	/**
	 * 分页查询
	 * 
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Assemble> getAssemble(int nPageIndex, int nPageSize,
			String keyWord, Assemble assemble, String fromDate, String toDate) {
		List<Assemble> assembles = new ArrayList<Assemble>();
		try {
			Query query = this.getAssembleQuery("ab", keyWord, assemble,
					fromDate, toDate);
			query.setFirstResult(nPageIndex * nPageSize);
			query.setMaxResults(nPageSize);
			assembles = (List<Assemble>) query.list();
			int i = 0;
			for (Assemble temp : assembles) {
				temp.setNumber(++i);
				// temp.setSortName(DictManager.getDictNameByID(assemble.getSort()));
			}
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return assembles;
	}

	/**
	 * 获取 总条数
	 * 
	 * @param assemble
	 * @param fromDate
	 * @param toDate
	 * @return
	 */
	public long getAssembleCount(String keyWord, Assemble assemble,
			String fromDate, String toDate) {
		long count = 0;
		try {
			Query query = this.getAssembleQuery("COUNT(*)", keyWord, assemble,
					fromDate, toDate);
			count = Utility.toSafeLong(query.uniqueResult());
		} catch (Exception e) {
			// e.printStackTrace();
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return count;
	}

	/**
	 * Query 查询对象
	 * 
	 * @param strChange
	 * @param keyWord
	 * @param assemble
	 * @param fromDate
	 * @param toDate
	 * @return
	 */
	private Query getAssembleQuery(String strChange, String keyWord,
			Assemble assemble, String fromDate, String toDate) {

		String hql = "SELECT " + strChange
				+ " FROM Assemble ab  WHERE ab.status =1 ";

		if (null != keyWord && !"".equals(keyWord)) {
			hql += " and (ab.code like '%" + keyWord
					+ "%' OR ab.titleCn LIKE '%" + keyWord
					+ "%' or ab.titleEn like '%" + keyWord
					+ "%' or ab.brands like '%" + keyWord
					+ "%' or ab.defaultFabric like '%" + keyWord
					+ "%' or ab.fabrics like '%" + keyWord + "%')  ";
		}
		// 款式代码
		if (null != assemble.getCode() && !"".equals(assemble.getCode())) {
			hql += (" and ab.code like '%" + assemble.getCode() + "%'");
		}

		// 服装分类
		if (null != assemble.getClothingID()
				&& !"".equals(assemble.getClothingID())
				&& -1 != assemble.getClothingID()) {
			hql += (" and ab.clothingID = '" + assemble.getClothingID() + "'");
		}

		// 款式风格
		if (null != assemble.getStyleID() && !"".equals(assemble.getStyleID())) {
			hql += (" and ab.styleID = '" + assemble.getStyleID() + "'");
		}

		if (fromDate != null && !"".equals(fromDate)) {
			hql += " AND ab.createTime>= to_date('" + fromDate
					+ "','yyyy-mm-dd')";
		}
		if (toDate != null && !"".equals(toDate)) {
			hql += " AND ab.createTime<= to_date('" + toDate
					+ "','yyyy-mm-dd')";
		}
		hql += " ORDER BY ab.createTime desc,id desc ";
		Query query = DataAccessObject.openSession().createQuery(hql);
		return query;
	}

	/**
	 * 验证code唯一性
	 * 
	 * @param code
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public int validateCode(String code) {
		int temp = 0;
		List<Assemble> tempList = new ArrayList<Assemble>();
		try {
			Query query = DataAccessObject.openSession().createQuery(
					"from Assemble av where av.status= 1 and av.code = '"
							+ code + "'");
			tempList = query.list();
			if (!tempList.isEmpty()) {
				temp = tempList.size();
			}
		} catch (HibernateException e) {
			// e.printStackTrace();
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}

		return temp;
	}

	/**
	 * 自动实例补全
	 * 
	 * @param strKeyword
	 * @param nSingleClothingID
	 * @return
	 */
	public List<Dict> GetComponentByKeyword(String strKeyword,
			int nSingleClothingID) {
		List<Dict> list = DictManager.getDicts(CDictCategory.ClothingCategory
				.getID());
		Dict d = DictManager.getDictByID(nSingleClothingID);
		List<Dict> newList = new ArrayList<Dict>();
		int i = 0;
		for (Dict dict : list) {
			if (i == 10) {
				break;
			}
			if (!"".equals(dict.getEcode()) && dict.getEcode() != null) {
				if (dict.getEcode().startsWith(strKeyword)
						&& dict.getCode().startsWith(d.getCode())) {
					Dict dictParent = DictManager.getDictByID(dict
							.getParentID());
					Dict dictParentParent = DictManager.getDictByID(dictParent
							.getParentID());
					if (!Utility.contains(CDict.EMBROID,
							Utility.toSafeString(dictParentParent.getID()))
							&& !Utility.contains(CDict.EMBROID,
									Utility.toSafeString(dict.getParentID()))) {

						// 只查特殊工艺
						if ((null != dict && null != dict.getStatusID() && !""
								.equals(dict.getStatusID()))
								&& 10008 == dict.getStatusID()
								|| "10008".equals(dict.getStatusID())) {
							newList.add(dict);
							i++;
						}
					}
				}
			}
		}
		return CurrentInfo.getAuthorityFunction(newList);
	}

	/**
	 * 根据ID 删除一条組合
	 * 
	 * @param session
	 * @param nId
	 */
	public void removeAssembleByID(Session session, String username, String nId) {
		String strDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
		Query query = session
				.createQuery("update Assemble av set av.status = 0,av.closeBy='"
						+ username
						+ "',av.closeTime=to_date('"
						+ strDate
						+ "','yyyy-mm-dd')  where av.id = '" + nId + "'");
		query.executeUpdate();
	}

	/**
	 * 批量删除
	 * 
	 * @param removeIDs
	 */
	public String removeAssembles(String username, String removeIDs) {
		if (removeIDs.equals("")) {
			return "请选择待删除项";
		}

		Transaction transaction = null;
		Session session = null;
		try {
			session = DataAccessObject.openSession();
			transaction = session.beginTransaction();

			String[] arrMemberIDs = Utility.getStrArray(removeIDs);
			for (Object memberID : arrMemberIDs) {
				if (memberID != null && memberID != "") {
					String strMemberId = Utility.toSafeString(memberID);
					this.removeAssembleByID(session, username, strMemberId);
				}
			}

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

	/**
	 * 获得某一款式的所有特殊工艺
	 * 
	 * @param assemble
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Dict> getOrderProcess(Assemble assemble) {
		List<Dict> process = new ArrayList<Dict>();
		String speProcessStr = assemble.getSpecialProcess();
		if (null != speProcessStr && !"".equals(speProcessStr)
				&& speProcessStr.startsWith(",")) {
			speProcessStr = speProcessStr.substring(1, speProcessStr.length());
		}
		if (null != speProcessStr && !"".equals(speProcessStr)) {
			String[] speProcess = speProcessStr.split(",");
			String[] speProcessConnect = null;
			List<Dict> tempList = null;
			Dict temp = null;
			try {

				if (null != speProcess && speProcess.length != 0) {
					for (int i = 0; i < speProcess.length; i++) {
						if (null != speProcess[i]) {
							speProcessConnect = speProcess[i].split(":");
							if (null != speProcessConnect
									&& speProcessConnect.length >= 2) {
								tempList = DataAccessObject
										.openSession()
										.createQuery(
												"from Dict t where t.Ecode = '"
														+ speProcessConnect[0]
														+ "' and t.StatusID  =10008")
										.list();
								if (null != tempList && !tempList.isEmpty()) {
									temp = tempList.get(0);
									temp.setMemo(speProcessConnect[1] == null
											&& "".equals(speProcessConnect[1]) ? ""
											: speProcessConnect[1]);
								}
								process.add(temp);
							}
						}
					}

				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DataAccessObject.closeSession();
			}
		}
		return process;
	}

	/**
	 * 获取款式设计特殊工艺的HTML
	 * 
	 * @param id
	 * @return
	 */
	public String getProcessHtml(Integer id) {
		Assemble assemble = this.findAssembleById(id);
		List<Dict> Process = this.getOrderProcess(assemble);
		int i = 1;
		StringBuffer sbfRow = new StringBuffer();
		for (Dict dict : Process) {
			if (null != dict) {
				Dict parentDict = DictManager.getDictByID(dict.getParentID());
				List<Dict> lowerLevelDatas = DictManager.getDicts(
						dict.getCategoryID(), parentDict.getID());

				sbfRow.append("<tr index='")
						.append(i)
						.append("'><td><input type='text'  disabled='disabled' id='component_")
						.append(dict.getID()).append("'  value='");
				if (lowerLevelDatas.size() > 0 && parentDict.getEcode() != null) {
					sbfRow.append(parentDict.getEcode()).append(
							"' style='width:130px' class='textbox'/> ");
					int temp = i + 1;
					sbfRow.append(parentDict.getName())
							.append("<input type='text' id='component_textbox_")
							.append(dict.getID())
							.append("' style='width:150px' value='")
							.append(dict.getEcode())
							.append("' class='textbox'/>")
							.append(dict.getName())
							.append("<input type='hidden' id='temp_")
							.append(temp).append("' value='").append(temp)
							.append("'/>");

				} else {
					sbfRow.append(dict.getEcode()).append(
							"' style='width:130px' class='textbox'/> ");
					if ((lowerLevelDatas.size() > 0
							&& dict.getStatusID() != null && dict.getStatusID() == 10008)
							|| (lowerLevelDatas.size() > 0 && dict
									.getStatusID() == null)) {
						String strMemo = "";
						if (dict.getMemo() != null) {// 去掉文本框中的null
							strMemo = dict.getMemo();
						}
						sbfRow.append(dict.getName())
								.append("<input type='text' id='category_textbox_")
								.append(dict.getID())
								.append("' value='")
								.append(strMemo)
								.append("' style='width:150px' class='textbox'/>");
					} else {
						String parentName = "";
						if (parentDict.getEcode() != null) {
							parentName = parentDict.getName() + ":";
						}
						sbfRow.append(parentName + dict.getName());
					}
				}
				// sbfRow.append("</td> <td onclick='$(this).parent().remove()' style='width:30px'><a class='remove'></a></td></tr>");
				// 获取款式号内容
				// if
				// (CDict.STYLES.contains(Utility.toSafeString(dict.getParentID())))
				// {
				// List<CurableStyle> curableStyles = DictManager
				// .getStyleNumByID(Utility.toSafeString(dict.getEcode()));
				// if (curableStyles.size() > 0) {
				// String strDictHtml =
				// DictManager.getStyleNumHtml(curableStyles,
				// i,
				// assemble.getClothingID());
				// int nIndex = curableStyles.size() + 1;
				sbfRow.append("</td> <td onclick='$(this).parent().remove();' style='width:30px'><a class='remove'></a></td></tr>");
				// sbfRow.append(strDictHtml);
			}
			//
			// else {
			// sbfRow.append("</td> <td onclick='$(this).parent().remove()' style='width:30px'><a class='remove'></a></td></tr>");
			// }
			// }
		}
		return sbfRow.toString();

	}

	/**
	 * 根据工艺的id字符串 获得文字说明字符串 编辑和查看时显示
	 * 
	 * @return
	 */
	public String getProcessStr(String processIds) {
		String processStr = "";
		if (null == processIds || "".equals(processIds)) {
			return "";
		}
		processIds = this.getLowestLevel(processIds);
		String[] procIDs = processIds.split(",");
		Dict dict;
		Dict parentDict;
		for (int i = 0; i < procIDs.length; i++) {
			dict = this.getDictByID(Utility.toSafeInt(procIDs[i]));
			parentDict = this.getDictByID(dict.getParentID());
			processStr += parentDict.getName() + ":" + dict.getEcode() + "-"
					+ dict.getName() + ",";
		}
		if (!"".equals(processStr) && processStr.length() != 0) {
			processStr = processStr.substring(0, processStr.lastIndexOf(","));
		}
		return processStr;
	}

	/**
	 * 获取某一 款式组合 保存 的工艺中，最末级的工艺id
	 * 
	 * @param ids
	 * @return
	 */
	private String getLowestLevel(String ids) {
		String lowestID = "";
		String sqlhql = "select t.ID from DICT t where t.ID in ("
				+ ids
				+ ") and t.ID not in (select t.ParentID from DICT t where t.ID in ("
				+ ids + "))";
		String lowest = null;
		String[] lowIDS = null;
		try {
			lowest = DataAccessObject.openSession().createSQLQuery(sqlhql)
					.list().toString().replace("[", "").replace("]", "");
			lowIDS = lowest.split(",");
			if (null != lowIDS && lowIDS.length != 0) {
				for (int i = 0; i < lowIDS.length; i++) {
					lowestID += lowIDS[i] + ",";
				}

			}
		} catch (HibernateException e) {
			e.printStackTrace();
		} finally {
			DataAccessObject.closeSession();
		}

		return lowestID;
	}

	/**
	 * 根据指定 特殊工艺拼接的字符串 获得格式的 特殊工艺
	 * 
	 * @param speProces
	 * @return
	 */
	public String getSpecialProc(Assemble assemble) {

		List<Dict> speProcess = this.getOrderProcess(assemble);
		String spe = "";
		// System.out.println("特殊工艺有————条：" + speProcess.size());
		for (Dict dict : speProcess) {
			if (null != dict && !"".equals(dict) && null != dict.getName()
					&& !"".equals(dict.getName()) && null != dict.getMemo()
					&& !"".equals(dict.getMemo())) {
				spe += dict.getEcode() + "-" + dict.getName() + ":"
						+ dict.getMemo() + ",";
			}
		}
		if (!"".equals(spe) && spe.length() != 0) {
			spe = spe.substring(0, spe.lastIndexOf(","));
		}

		return spe;
	}

	/**
	 * 根据 ecode 获取 特殊工艺
	 * 
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Dict getSpecialProcByEcode(String ecode) {
		Dict dict = null;
		List<Dict> tempList = new ArrayList<Dict>();

		String hql = "from Dict t where t.Ecode = '" + ecode
				+ "' and t.StatusID = 10008";
		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			tempList = query.list();
			if (null != tempList && !tempList.isEmpty()) {
				dict = tempList.get(0);
			}
		} catch (HibernateException e) {
			e.printStackTrace();
			dict = null;
		}
		return dict;
	}

	/**
	 * 根据 ecode 获取 特殊工艺
	 * 
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Dict getProcByEcode(String ecode) {
		Dict dict = null;
		List<Dict> tempList = new ArrayList<Dict>();

		String hql = "from Dict t where t.Ecode = '" + ecode
				+ "' and t.StatusID != 10008";
		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			tempList = query.list();
			if (null != tempList && !tempList.isEmpty()) {
				//去掉刺绣信息和款式号信息
				String strProcess = "1374,2618,4639,3713,6602,422,518,1218,2213,2523,2507,4150,4155,4550,3631,3248,3201,3259,6404,6413,6976";
				for(Dict temp : tempList){
					if(!Utility.contains(strProcess,Utility.toSafeString(temp.getParentID()))){
						dict = temp;
					}
				}
			}
		} catch (HibernateException e) {
			e.printStackTrace();
			dict = null;
		}
		return dict;
	}

	@SuppressWarnings("unchecked")
	public List<Assemble> getListAssembleByType(int pageNo, int pageSize,
			String code, String style, int type) {
		List<Assemble> assembles = new ArrayList<Assemble>();
		Query query = this.getAssembleQueryByType("a", code, style, type);
		query.setFirstResult(pageNo * pageSize);
		query.setMaxResults(pageSize);
		assembles = (List<Assemble>) query.list();
		for (Assemble assemble : assembles) {
			assemble.setDict(this.getDictByStyleId(assemble.getStyleID()));
		}
		return assembles;
	}

	public Dict getDictByStyleId(int styleId) {
		Dict dict = null;
		String hql = "FROM Dict where ID=:styleId";
		Query query = DataAccessObject.openSession().createQuery(hql);
		query.setInteger("styleId", styleId);
		dict = (Dict) query.list().get(0);
		return dict;
	}

	public int getCount(String code, String style, int type) {
		int count = 0;
		Query query = this
				.getAssembleQueryByType("COUNT(*)", code, style, type);
		count = Utility.toSafeInt(query.uniqueResult());
		return count;
	}

	public Query getAssembleQueryByType(String exchange, String code,
			String style, int type) {
		Query query = null;
		String hql = "select "
				+ exchange
				+ " from Assemble a where a.clothingID=:type and a.status=1 and a.code like :code and a.styleID like :style";
		query = DataAccessObject.openSession().createQuery(hql);
		query.setInteger("type", type);
		query.setString("code", "%" + code + "%");
		query.setString("style", "%" + style + "%");
		return query;
	}

	@SuppressWarnings("unchecked")
	public List<Dict> getStyleListByType(int styleId) {
		List<Dict> styles = new ArrayList<Dict>();
		String hql = "from Dict t where t.ParentID=:styleID";
		Query query = DataAccessObject.openSession().createQuery(hql);
		query.setInteger("styleID", styleId);
		styles = query.list();
		return styles;
	}

	/**
	 * 将　,ecode:memo..的特殊工艺格式处理成 ,id:memo...的格式
	 * 
	 * @param ecodeMomeStr
	 * @return
	 */
	public String formatSpecialProcess(String ecodeMomeStr) {
		if (null != ecodeMomeStr && !"".equals(ecodeMomeStr)) {
			if (ecodeMomeStr.startsWith(",")) {
				ecodeMomeStr = ecodeMomeStr.substring(1, ecodeMomeStr.length());
			}
			if (ecodeMomeStr.endsWith(",")) {
				ecodeMomeStr = ecodeMomeStr.substring(0,
						ecodeMomeStr.lastIndexOf(","));
			}
			String[] onepis = null;
			Dict dict;
			// 多条特殊工艺
			if (ecodeMomeStr.indexOf(",") > 0) {
				String[] allSpepro = ecodeMomeStr.split(",");
				if (null != allSpepro && allSpepro.length > 0) {

					for (int i = 0; i < allSpepro.length; i++) {
						onepis = allSpepro[i].split(":");
						if (null != onepis && onepis.length > 0) {
							dict = this.getSpecialProcByEcode(onepis[0]);
							ecodeMomeStr = ecodeMomeStr.replace(onepis[0], dict
									.getID().toString());
						}
					}
				}
			} else if (ecodeMomeStr.indexOf(":") > 0) {
				// 只有一条特殊工艺
				onepis = ecodeMomeStr.split(":");
				if (null != onepis && onepis.length > 0) {
					dict = this.getSpecialProcByEcode(onepis[0]);
					ecodeMomeStr = ecodeMomeStr.replace(onepis[0], dict.getID()
							.toString());
				}
			}
			return "," + ecodeMomeStr;
		}
		return "";

	}

	/**
	 * 将　,id:memo...的特殊工艺格式处理成 ,ecode:memo..的格式
	 * 
	 * @param idMemoStr
	 * @return
	 */
	public String parseSpecialProcess(String idMemoStr) {
		if (null != idMemoStr && !"".equals(idMemoStr)) {
			if (idMemoStr.startsWith(",")) {
				idMemoStr = idMemoStr.substring(1, idMemoStr.length());
			}
			if (idMemoStr.endsWith(",")) {
				idMemoStr = idMemoStr.substring(0, idMemoStr.lastIndexOf(","));
			}
			String[] onepis = null;
			Dict dict;
			if (idMemoStr.indexOf(",") > 0) {
				String[] allSpepro = idMemoStr.split(",");
				if (null != allSpepro && allSpepro.length > 0) {

					for (int i = 0; i < allSpepro.length; i++) {
						onepis = allSpepro[i].split(":");
						if (null != onepis && onepis.length > 0) {
							dict = this
									.getDictByID(Integer.parseInt(onepis[0]));
							idMemoStr = idMemoStr.replace(dict.getID()
									.toString(), dict.getEcode());
						}
					}
				}
			} else if (idMemoStr.indexOf(":") > 0) {
				onepis = idMemoStr.split(":");
				if (null != onepis && onepis.length > 0) {
					dict = this.getDictByID(Integer.parseInt(onepis[0]));
					idMemoStr = idMemoStr.replace(dict.getID().toString(),
							dict.getEcode());
				}
			}
			return "," + idMemoStr;
		}
		return "";

	}

}
