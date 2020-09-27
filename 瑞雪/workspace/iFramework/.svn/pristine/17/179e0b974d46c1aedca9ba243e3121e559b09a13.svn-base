package com.dhc.authorization.delegate.dao.ibatis;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

import com.dhc.authorization.delegate.dao.IDelegateDAO;
import com.dhc.authorization.delegate.domain.WF_ORG_DELEGATE;
import com.dhc.authorization.delegate.domain.WF_ORG_DELEITEM;
import com.dhc.base.exception.DataAccessException;

/**
 * brief description
 * <p>
 * Date : 2010/07/09
 * </p>
 * <p>
 * Module : 权限委托管理
 * </p>
 * <p>
 * Description: 权限委托数据访问对象实现
 * </p>
 * <p>
 * Remark :
 * </p>
 * 
 * @author 王潇艺
 * @version
 *          <p>
 * 			------------------------------------------------------------
 *          </p>
 *          <p>
 *          修改历史
 *          </p>
 *          <p>
 *          序号 日期 修改人 修改原因
 *          </p>
 *          <p>
 *          1
 *          </p>
 */
public class DelegateDAO_Sybase125Impl extends SqlMapClientDaoSupport implements IDelegateDAO {

	/**
	 * 构造函数
	 */
	public DelegateDAO_Sybase125Impl() {

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 新建权限委托
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param delegateVO
	 *            - 权限委托vo
	 * @return 无
	 * @throws DataAccessException
	 */
	public WF_ORG_DELEGATE createDelegate(WF_ORG_DELEGATE delegateVO) throws DataAccessException {
		try {
			this.getSqlMapClient().insert("WF_ORG_DELEGATE.insert", delegateVO);
			// 插入人员
			List roleList = delegateVO.getRoleItemList();
			if (roleList != null) {
				for (int i = 0; i < roleList.size(); i++) {
					WF_ORG_DELEITEM deleitemVO = (WF_ORG_DELEITEM) roleList.get(i);
					this.getSqlMapClient().insert("WF_ORG_DELEITEM.insert", deleitemVO);
				}
			}
			// 插入岗位
			List staList = delegateVO.getStationItemList();
			if (staList != null) {
				for (int i = 0; i < staList.size(); i++) {
					WF_ORG_DELEITEM deleitemVO = (WF_ORG_DELEITEM) staList.get(i);
					this.getSqlMapClient().insert("WF_ORG_DELEITEM.insert", deleitemVO);
				}
			}
			// 插入组织
			List unitList = delegateVO.getUnitItemList();
			if (unitList != null) {
				for (int i = 0; i < unitList.size(); i++) {
					WF_ORG_DELEITEM deleitemVO = (WF_ORG_DELEITEM) unitList.get(i);
					this.getSqlMapClient().insert("WF_ORG_DELEITEM.insert", deleitemVO);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("数据库操作异常");
		}
		return null;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 修改权限委托
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param delegateVO
	 *            - 权限委托vo
	 * @return 无
	 * @throws DataAccessException
	 */
	public WF_ORG_DELEGATE updateDelegate(WF_ORG_DELEGATE delegateVO) throws DataAccessException {
		try {
			this.getSqlMapClient().insert("WF_ORG_DELEGATE.update", delegateVO);
			String deleId = delegateVO.getDeleId();
			this.getSqlMapClient().delete("WF_ORG_DELEITEM.deleteForUpdate", deleId);
			// 插入人员
			List roleList = delegateVO.getRoleItemList();
			if (roleList != null) {
				for (int i = 0; i < roleList.size(); i++) {
					WF_ORG_DELEITEM deleitemVO = (WF_ORG_DELEITEM) roleList.get(i);
					this.getSqlMapClient().insert("WF_ORG_DELEITEM.insert", deleitemVO);
				}
			}
			// 插入岗位
			List staList = delegateVO.getStationItemList();
			if (staList != null) {
				for (int i = 0; i < staList.size(); i++) {
					WF_ORG_DELEITEM deleitemVO = (WF_ORG_DELEITEM) staList.get(i);
					this.getSqlMapClient().insert("WF_ORG_DELEITEM.insert", deleitemVO);
				}
			}
			// 插入组织
			List unitList = delegateVO.getUnitItemList();
			if (unitList != null) {
				for (int i = 0; i < unitList.size(); i++) {
					WF_ORG_DELEITEM deleitemVO = (WF_ORG_DELEITEM) unitList.get(i);
					this.getSqlMapClient().insert("WF_ORG_DELEITEM.insert", deleitemVO);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("数据库操作异常");
		}
		return null;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据条件获取权限委托,考虑3种情况： 1、我的委托 2、别人给我的委托 3、我能管理的组织中所有人的委托
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param delegateVO
	 *            - 权限委托vo
	 * @return 如果找到，返回ArrayList<WF_ORG_DELEGATE> 如果没有找到，返回new ArrayList
	 * @throws DataAccessException
	 */
	public List getDelegateByCondition(WF_ORG_DELEGATE delegateVO) throws DataAccessException {
		List resultList = new ArrayList();
		try {
			// String querySQL1 = "select DELE_ID, USER_ID, TRUSTOR_ID, \n" +
			// "(select u.user_fullname from wf_org_user u where u.user_id =
			// trustor_id) trustor_name, \n" +
			// "DELE_NAME, DELE_DESCRIPTION, \n" +
			// "to_char(DELE_TIME_BEGIN,'yyyy-mm-dd hh24:mi:ss') as
			// DELE_TIME_BEGIN, \n" +
			// "to_char(DELE_TIME_END,'yyyy-mm-dd hh24:mi:ss') as DELE_TIME_END,
			// \n" +
			// "DELE_ALL_PRIVIL, \n" +
			// " FROM WF_ORG_DELEGATE D \n" +
			// " where user_id in \n" +
			// "(select distinct (uu.user_id) from wf_org_user_unit uu \n" +
			// "where uu.unit_id in \n" +
			// "(select ru.unit_id from wf_org_user_role ur, wf_org_role_unit ru
			// \n" +
			// "where ur.user_id = '"+ delegateVO.getCurrentUserId() +"' \n" +
			// "and ru.role_id = ur.role_id) ) \n" +
			// 1、我的委托
			// 2、别人给我的委托
			// 3、我能管理的组织中所有人的委托(排除我的委托)
			String querySQL1 = "SELECT * FROM (SELECT DELE_ID,\n" + "       D.USER_ID,\n"
					+ "       UU.USER_FULLNAME USER_NAME,\n" + "       TRUSTOR_ID,\n"
					+ "       U.USER_FULLNAME TRUSTOR_NAME,\n" + "       DELE_NAME,\n" + "       DELE_DESCRIPTION,\n"
					+ "       CONVERT(DATETIME, DELE_TIME_BEGIN, 108) AS DELE_TIME_BEGIN,\n"
					+ "       CONVERT(DATETIME, DELE_TIME_END, 108) AS DELE_TIME_END,\n" + "       (CASE\n"
					+ "         WHEN DELE_ALL_PRIVIL = '1' THEN\n" + "          '是'\n" + "         ELSE\n"
					+ "          '否'\n" + "       END) DELE_ALL_PRIVIL\n" + "  FROM WF_ORG_DELEGATE D\n"
					+ "  LEFT JOIN WF_ORG_USER U ON U.USER_ID = D.TRUSTOR_ID\n"
					+ "  LEFT JOIN WF_ORG_USER UU ON UU.USER_ID = D.USER_ID\n" + " WHERE D.USER_ID = '"
					+ delegateVO.getCurrentUserId() + "' OR D.TRUSTOR_ID = '" + delegateVO.getCurrentUserId()
					+ "' UNION ALL\n" + "select DELE_ID, D.USER_ID, UU.USER_FULLNAME USER_NAME, TRUSTOR_ID, \n"
					+ "U.USER_FULLNAME TRUSTOR_NAME, DELE_NAME, DELE_DESCRIPTION, \n"
					+ "CONVERT(DATETIME,DELE_TIME_BEGIN, 108) AS DELE_TIME_BEGIN, \n"
					+ "CONVERT(DATETIME,DELE_TIME_END, 108) AS DELE_TIME_END, \n"
					+ "(CASE WHEN DELE_ALL_PRIVIL='1' THEN '是' ELSE '否' END) DELE_ALL_PRIVIL \n"
					+ " FROM WF_ORG_DELEGATE D LEFT JOIN WF_ORG_USER U ON  U.USER_ID = D.TRUSTOR_ID \n"
					+ " LEFT JOIN WF_ORG_USER UU ON UU.USER_ID = D.USER_ID \n" + " WHERE D.USER_ID <> '"
					+ delegateVO.getCurrentUserId() + "'" + "AND D.USER_ID IN \n"
					+ "(SELECT DISTINCT (UU.USER_ID) FROM WF_ORG_USER_UNIT UU \n"
					+ " WHERE UU.UNIT_ID IN (SELECT RU.UNIT_ID  FROM WF_ORG_USER_ROLE UR, \n"
					+ " WF_ORG_ROLE_UNIT RU WHERE UR.USER_ID = '" + delegateVO.getCurrentUserId() + "' \n"
					+ " AND RU.ROLE_ID = UR.ROLE_ID) )) T WHERE 1=1 \n" + (delegateVO.getDeleName() == null ? ""
							: " AND T.DELE_NAME = '" + delegateVO.getDeleName() + "' \n");
			String querySQL2 = "";
			String querySQL3 = "";
			querySQL2 = (delegateVO.getUserId() == null ? "" : " AND T.USER_ID = '" + delegateVO.getUserId() + "' \n");

			if (delegateVO.getDeleName() == null && delegateVO.getUserId() == null) {
				querySQL3 = (delegateVO.getTrustorId() == null ? ""
						: " T.TRUSTOR_ID = '" + delegateVO.getTrustorId() + "' \n");
			} else {
				querySQL3 = (delegateVO.getTrustorId() == null ? ""
						: " AND T.TRUSTOR_ID = '" + delegateVO.getTrustorId() + "' \n");
			}
			String querySQL = querySQL1 + querySQL2 + querySQL3;
			Map paramMap = new HashMap();
			paramMap.put("sqlStr", querySQL);
			paramMap.put("startRec", delegateVO.getStartRow());
			paramMap.put("lastRec", delegateVO.getEndRow());
			resultList = this.getSqlMapClient().queryForList("WF_ORG_DELEGATE.GetPagingData", paramMap);
			for (int i = 0; i < resultList.size(); i++) {
				WF_ORG_DELEGATE delegate = (WF_ORG_DELEGATE) resultList.get(i);
				if (delegate.getDeleTimeBegin() != null && !delegate.getDeleTimeBegin().equals("")) {
					String begin = delegate.getDeleTimeBegin().toString();
					String subBegin = begin.substring(0, begin.lastIndexOf("."));
					delegate.setDeleTimeBegin(subBegin);
				}
				if (delegate.getDeleTimeEnd() != null && !delegate.getDeleTimeEnd().equals("")) {
					String end = delegate.getDeleTimeEnd().toString();
					String subEnd = end.substring(0, end.lastIndexOf("."));
					delegate.setDeleTimeEnd(subEnd);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("数据访问错误");
		}
		return resultList;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 删除权限委托
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param delegateIDs
	 *            - 组织单元id数组
	 * @throws DataAccessException
	 */
	public void deleteDelegate(List delegateIDs) throws DataAccessException {
		try {
			for (int i = 0; i < delegateIDs.size(); i++) {
				String deleId = delegateIDs.get(i).toString();
				if (!deleId.equals("")) {
					this.getSqlMapClient().delete("WF_ORG_DELEITEM.delete", deleId);
					this.getSqlMapClient().delete("WF_ORG_DELEGATE.delete", deleId);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("数据访问错误");
		}
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取权限委托
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param delegateID
	 *            - 权限委托主键
	 * @return 如果找到，返回WF_ORG_DELEGATE 如果没有找到，返回null
	 * @throws DataAccessException
	 */
	public List getDelegateDetail(String delegateID) throws DataAccessException {
		List resultList = new ArrayList();
		try {
			resultList = this.getSqlMapClient().queryForList("WF_ORG_DELEGATE.selectDelegateDetail", delegateID);
			for (int i = 0; i < resultList.size(); i++) {
				WF_ORG_DELEGATE delegate = (WF_ORG_DELEGATE) resultList.get(i);
				if (delegate.getDeleTimeBegin() != null)
					if (!delegate.getDeleTimeBegin().equals("") || delegate.getDeleTimeBegin() != null) {
						String begin = delegate.getDeleTimeBegin().toString();
						String subBegin = begin.substring(0, begin.lastIndexOf("."));
						delegate.setDeleTimeBegin(subBegin);
					}
				if (delegate.getDeleTimeEnd() != null)
					if (!delegate.getDeleTimeEnd().equals("") || delegate.getDeleTimeEnd() != null) {
						String end = delegate.getDeleTimeEnd().toString();
						String subEnd = end.substring(0, end.lastIndexOf("."));
						delegate.setDeleTimeEnd(subEnd);
					}
			}

		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("RoleDAO数据访问错误");
		}
		return resultList;

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取权限委托
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param delegateID
	 *            - 权限委托主键
	 * @return 如果找到，返回WF_ORG_DELEGATE 如果没有找到，返回null
	 * @throws DataAccessException
	 */
	public List getDeleitemDetail(String delegateID) throws DataAccessException {
		List resultList = new ArrayList();
		try {
			resultList = this.getSqlMapClient().queryForList("WF_ORG_DELEITEM.selectDeleitemDetail", delegateID);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("RoleDAO数据访问错误");
		}
		return resultList;

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取权限委托总行数，用于分页
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param delegateParam
	 *            - 权限委托查询条件
	 * @return 权限委托总行数
	 * @throws DataAccessException
	 */
	public int getDelegateCount(WF_ORG_DELEGATE delegateParam) {
		int returnValue = 0;
		try {
			returnValue = (Integer) this.getSqlMapClient().queryForObject("WF_ORG_DELEGATE.count", delegateParam);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return returnValue;
	}
}
