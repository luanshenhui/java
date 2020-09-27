package com.dhc.organization.user.dao.ibatis;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

import com.dhc.base.exception.DataAccessException;
import com.dhc.base.exception.ServiceException;
import com.dhc.organization.config.BizTypeDefine;
import com.dhc.organization.config.ElementDefine;
import com.dhc.organization.config.OrgnizationConfig;
import com.dhc.organization.position.domain.WF_ORG_USER_STATION;
import com.dhc.organization.role.domain.WF_ORG_USER_ROLE;
import com.dhc.organization.unit.domain.WF_ORG_USER_UNIT;
import com.dhc.organization.user.dao.IUserDAO;
import com.dhc.organization.user.domain.WF_ORG_USER;

/**
 * brief description
 * <p>
 * Date : 2010/05/06
 * </p>
 * <p>
 * Module : 用户管理
 * </p>
 * <p>
 * Description: 用户数据访问对象实现
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
public class UserDAO_Sybase125Impl extends SqlMapClientDaoSupport implements IUserDAO {

	/**
	 * 构造函数
	 */
	public UserDAO_Sybase125Impl() {

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据条件获用户
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param userVO
	 *            - 用户VO
	 * @return 如果找到，返回ArrayList<WF_ORG_USER> 如果没有找到，返回new ArrayList
	 * @throws DataAccessException
	 */
	public List getUserByCondition(WF_ORG_USER userVO) throws DataAccessException {
		List userList = new ArrayList();
		try {
			if (userVO.getStartRow() == 0 && userVO.getEndRow() == 0) {
				userList = getSqlMapClient().queryForList("WF_ORG_USER.select", userVO);
			} else {
				String querySQL1 = "select DISTINCT U.USER_ID, U.USER_ACCOUNT, U.USER_FULLNAME, \n"
						+ "U.USER_PASSWORD, U.USER_DESCRIPTION,\n"
						+ "U.USER_PASSWORD_CHANGED, U.USER_ACCOUNT_ENABLED, \n" + "(case \n"
						+ "when U.USER_ACCOUNT_LOCKED = '1' then \n" + " '是' \n" + "else \n" + " '否'  \n"
						+ "end) as USER_ACCOUNT_LOCKED, U.USER_ACCOUNT_CREATED \n"
						+ " FROM WF_ORG_USER U LEFT JOIN WF_ORG_USER_UNIT UU ON U.USER_ID = UU.USER_ID \n"
						+ (userVO.getUserId() != null || userVO.getUserAccount() != null
								|| userVO.getUserAccountLocked() != null || userVO.getUserFullname() != null
								|| userVO.getUnitID() != null || userVO.getRoleId() != null
								|| userVO.getStationId() != null || userVO.getUserPassword() != null
								|| userVO.getUserType() != null || userVO.getAdminRoleID() != null ? " WHERE" : "")
						+ (userVO.getUserId() == null ? "" : " USER_ID ='" + userVO.getUserId() + "' \n");
				String querySQL2 = "";
				String querySQL3 = "";
				String querySQL4 = "";
				String querySQL5 = "";
				String querySQL6 = "";
				String querySQL7 = "";
				String querySQL8 = "";
				String querySQL9 = "";
				String querySQL10 = "";
				if (userVO.getUserId() == null) {
					querySQL2 = (userVO.getUserAccount() == null ? ""
							: " U.USER_ACCOUNT ='" + userVO.getUserAccount() + "' \n");
				} else {
					querySQL2 = (userVO.getUserAccount() == null ? ""
							: " and U.USER_ACCOUNT ='" + userVO.getUserAccount() + "' \n");
				}
				if (userVO.getUserAccount() == null && userVO.getUserId() == null) {
					querySQL10 = (userVO.getUserAccountLocked() == null ? ""
							: " U.USER_ACCOUNT_LOCKED ='" + userVO.getUserAccountLocked() + "' \n");
				} else {
					querySQL10 = (userVO.getUserAccountLocked() == null ? ""
							: " and U.USER_ACCOUNT_LOCKED ='" + userVO.getUserAccountLocked() + "' \n");
				}
				if (userVO.getUserAccountLocked() == null && userVO.getUserAccount() == null
						&& userVO.getUserId() == null) {
					querySQL3 = (userVO.getUserFullname() == null ? ""
							: " U.USER_FULLNAME like '" + userVO.getUserFullname() + "'\n");
				} else {
					querySQL3 = (userVO.getUserFullname() == null ? ""
							: " and U.USER_FULLNAME like '" + userVO.getUserFullname() + "'\n");

				}
				if (userVO.getUserFullname() == null && userVO.getUserId() == null
						&& userVO.getUserAccountLocked() == null) {
					querySQL4 = (userVO.getUnitID() == null ? ""
							: " U.USER_ID IN \n"
									+ " (SELECT DISTINCT (B.USER_ID)FROM WF_ORG_UNIT A, WF_ORG_USER_UNIT B \n"
									+ " WHERE A.UNIT_ID = B.UNIT_ID AND A.UNIT_ID = '" + userVO.getUnitID() + "')\n");
				} else {
					querySQL4 = (userVO.getUnitID() == null ? ""
							: " and U.USER_ID IN \n"
									+ " (SELECT DISTINCT (B.USER_ID)FROM WF_ORG_UNIT A, WF_ORG_USER_UNIT B \n"
									+ " WHERE A.UNIT_ID = B.UNIT_ID AND A.UNIT_ID = '" + userVO.getUnitID() + "')\n");
				}
				if (userVO.getUnitID() == null && userVO.getUserFullname() == null && userVO.getUserId() == null
						&& userVO.getUserAccountLocked() == null) {
					querySQL5 = (userVO.getRoleId() == null ? ""
							: " U.USER_ID IN \n" + " (SELECT A.USER_ID FROM WF_ORG_USER_ROLE A WHERE A.ROLE_ID = '"
									+ userVO.getRoleId() + "')\n");
				} else {
					querySQL5 = (userVO.getRoleId() == null ? ""
							: " and U.USER_ID IN \n" + " (SELECT A.USER_ID FROM WF_ORG_USER_ROLE A WHERE A.ROLE_ID = '"
									+ userVO.getRoleId() + "')\n");
				}
				if (userVO.getRoleId() == null && userVO.getUnitID() == null && userVO.getUserFullname() == null
						&& userVO.getUserId() == null && userVO.getUserAccountLocked() == null) {
					querySQL6 = (userVO.getStationId() == null ? ""
							: " U.USER_ID IN \n"
									+ " (SELECT A.USER_ID FROM WF_ORG_USER_STATION A WHERE A.STATION_ID = '"
									+ userVO.getStationId() + "')\n");
				} else {
					querySQL6 = (userVO.getStationId() == null ? ""
							: " and U.USER_ID IN \n"
									+ " (SELECT A.USER_ID FROM WF_ORG_USER_STATION A WHERE A.STATION_ID = '"
									+ userVO.getStationId() + "')\n");
				}
				if (userVO.getStationId() == null && userVO.getRoleId() == null && userVO.getUnitID() == null
						&& userVO.getUserFullname() == null && userVO.getUserId() == null
						&& userVO.getUserAccountLocked() == null) {
					querySQL7 = (userVO.getUserPassword() == null ? ""
							: " U.USER_PASSWORD = '" + userVO.getUserPassword() + "'");
				} else {
					querySQL7 = (userVO.getUserPassword() == null ? ""
							: " and U.USER_PASSWORD = '" + userVO.getUserPassword() + "'");
				}
				if (userVO.getCurrentLoginUserID() != null
						&& userVO.getCurrentLoginUserID().equalsIgnoreCase("adminUser")) {
					querySQL8 = "";
					querySQL9 = "";
				} else {
					if (userVO.getUserPassword() == null && userVO.getStationId() == null && userVO.getRoleId() == null
							&& userVO.getUnitID() == null && userVO.getUserFullname() == null
							&& userVO.getUserId() == null && userVO.getUserAccountLocked() == null) {
						if (userVO.getUserType() != null) {
							if (userVO.getUserType().equals("bizUser")) {
								querySQL8 = "				U.USER_ID NOT IN (SELECT T2.USER_ID\n"
										+ "                                 FROM WF_ORG_USER_ROLE T2, WF_ORG_ROLE T3\n"
										+ "                                WHERE T2.ROLE_ID = T3.ROLE_ID\n"
										+ "                                  AND T3.IS_ADMINROLE = '是')";
							} else if (userVO.getUserType().equals("adminUser")) {
								querySQL8 = "				U.USER_ID IN (SELECT T2.USER_ID\n"
										+ "                                 FROM WF_ORG_USER_ROLE T2, WF_ORG_ROLE T3\n"
										+ "                                WHERE T2.ROLE_ID = T3.ROLE_ID\n"
										+ "                                  AND T3.IS_ADMINROLE = '是')";
							}
						}
					} else {
						if (userVO.getUserType() != null) {
							if (userVO.getUserType().equals("bizUser")) {
								querySQL8 = "			AND U.USER_ID NOT IN (SELECT T2.USER_ID\n"
										+ "                                 FROM WF_ORG_USER_ROLE T2, WF_ORG_ROLE T3\n"
										+ "                                WHERE T2.ROLE_ID = T3.ROLE_ID\n"
										+ "                                  AND T3.IS_ADMINROLE = '是')";
							} else if (userVO.getUserType().equals("adminUser")) {
								querySQL8 = "			AND U.USER_ID IN (SELECT T2.USER_ID\n"
										+ "                                 FROM WF_ORG_USER_ROLE T2, WF_ORG_ROLE T3\n"
										+ "                                WHERE T2.ROLE_ID = T3.ROLE_ID\n"
										+ "                                  AND T3.IS_ADMINROLE = '是')";
							}
						}
					}
					if (userVO.getUserPassword() == null && userVO.getStationId() == null && userVO.getRoleId() == null
							&& userVO.getUnitID() == null && userVO.getUserFullname() == null
							&& userVO.getUserId() == null && userVO.getUserType() == null
							&& userVO.getUserAccount() == null && userVO.getUserAccountLocked() == null) {
						querySQL9 = userVO.getAdminRoleID() == null ? ""
								: "(UU.UNIT_ID = null\n" + "    OR UU.UNIT_ID = ''\n"
										+ "OR U.USER_ID IN (SELECT T1.USER_ID\n"
										+ "           FROM WF_ORG_USER_UNIT T1\n"
										+ "          WHERE T1.UNIT_ID IN (SELECT T2.UNIT_ID\n"
										+ "                                 FROM WF_ORG_ROLE_UNIT T2\n"
										+ "                                WHERE T2.ROLE_ID = '"
										+ userVO.getAdminRoleID() + "')))";
						querySQL9 += " AND U.USER_ID <> 'adminUser' AND U.USER_ID <> '" + userVO.getCurrentLoginUserID()
								+ "'";
					} else {
						querySQL9 = userVO.getAdminRoleID() == null ? ""
								: "AND (UU.UNIT_ID = null\n" + "       OR UU.UNIT_ID = ''\n"
										+ "   OR U.USER_ID IN (SELECT T1.USER_ID\n"
										+ "              FROM WF_ORG_USER_UNIT T1\n"
										+ "             WHERE T1.UNIT_ID IN (SELECT T2.UNIT_ID\n"
										+ "                                    FROM WF_ORG_ROLE_UNIT T2\n"
										+ "                                   WHERE T2.ROLE_ID = '"
										+ userVO.getAdminRoleID() + "')))";
						querySQL9 += " AND U.USER_ID <> 'adminUser' AND U.USER_ID <> '" + userVO.getCurrentLoginUserID()
								+ "'";
					}

				}
				if (querySQL2.equals("") && querySQL3.equals("") && querySQL4.equals("") && querySQL5.equals("")
						&& querySQL6.equals("") && querySQL10.equals("") && querySQL7.equals("") && querySQL8.equals("")
						&& querySQL9.equals("")) {
					String temp = querySQL1.substring(querySQL1.length() - 5, querySQL1.length());
					if (temp.equals("WHERE"))
						querySQL1 = querySQL1.substring(0, querySQL1.length() - 5);
				}
				String querySQL = querySQL1 + querySQL2 + querySQL10 + querySQL3 + querySQL4 + querySQL5 + querySQL6
						+ querySQL7 + querySQL8 + querySQL9;
				Map paramMap = new HashMap();
				paramMap.put("sqlStr", querySQL);
				paramMap.put("startRec", userVO.getStartRow());
				paramMap.put("lastRec", userVO.getEndRow());
				// paramMap.put("startRec", 0);
				// paramMap.put("lastRec", 1);
				userList = this.getSqlMapClient().queryForList("WF_ORG_USER.GetPagingData", paramMap);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("根据条件查询用户时发生错误");
		}

		return userList;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据userid数组获取用户
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param userVO
	 *            - 用户VO
	 * @return 如果找到，返回ArrayList<WF_ORG_USER> 如果没有找到，返回new ArrayList
	 * @throws DataAccessException
	 */
	public List getUserByIDs(WF_ORG_USER userVO) throws DataAccessException {
		List userList = new ArrayList();
		try {
			userList = getSqlMapClient().queryForList("WF_ORG_USER.selectByIDs", userVO);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("根据条件查询用户时发生错误");
		}

		return userList;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据组织单元id获用户
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param unitID
	 *            - 组织单元id
	 * @return 如果找到，返回ArrayList<WF_ORG_USER> 如果没有找到，返回new ArrayList
	 * @throws DataAccessException
	 */
	public List getUserByUnitID(String unitID) throws DataAccessException {
		List list = null;
		try {
			list = getSqlMapClient().queryForList("WF_ORG_USER.selectUser", unitID);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("根据条件查询用户时发生错误");
		}
		return list;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 分页获取用户
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param condMap
	 *            - 分页查询条件
	 * @return 无
	 * @throws DataAccessException
	 */
	public List getPagingUsers(Map condMap) throws DataAccessException {
		return null;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取角色中用户的剩余数量
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param roleID
	 *            - 角色id
	 * @return 角色中用户的剩余数量
	 * @throws DataAccessException
	 */
	private int getRoleUserRemain(String roleID) throws DataAccessException {
		int returnValue = -1;
		try {
			Object obj = this.getSqlMapClient().queryForObject("WF_ORG_USER.roleUserRemain", roleID);
			if (obj != null)
				returnValue = (Integer) obj;
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new DataAccessException("根据条件查询用户时发生错误");
		}
		return returnValue;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取岗位中用户的剩余数量
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param roleID
	 *            - 岗位id
	 * @return 岗位中用户的剩余数量
	 * @throws DataAccessException
	 */
	private int getStationUserRemain(String stationID) throws DataAccessException {
		int returnValue = -1;
		try {
			Object obj = this.getSqlMapClient().queryForObject("WF_ORG_USER.stationUserRemain", stationID);
			if (obj != null)
				returnValue = (Integer) obj;
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new DataAccessException("根据条件查询用户时发生错误");
		}
		return returnValue;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 新建人员，包括（人员基本信息、人员扩展信息、人员的组织单元、人员的岗位、人员的角 色）
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param userVO
	 *            - 人员VO，包括（人员基本信息、人员扩展信息、人员的组织单元、人员的岗位、人员的角色 ）
	 * @return 无
	 * @throws DataAccessException
	 */
	public void createUser(WF_ORG_USER userVO, String extTableName, String idColName) throws DataAccessException {
		Connection conn = null;
		Statement statement = null;

		try {
			this.getSqlMapClient().insert("WF_ORG_USER.insert", userVO);
			// 插用户的组织单元
			if (userVO.getUserUnitList() != null && userVO.getUserUnitList().size() > 0) {
				for (int i = 0; i < userVO.getUserUnitList().size(); i++) {
					String userUnit = (String) userVO.getUserUnitList().get(i);
					WF_ORG_USER_UNIT uu = new WF_ORG_USER_UNIT();
					uu.setUserId(userVO.getUserId());
					uu.setUnitId(userUnit);
					this.getSqlMapClient().insert("WF_ORG_USER.insertUserUnit", uu);
				}
			}
			// 插用户的岗位
			if (userVO.getUserStationList() != null && userVO.getUserStationList().size() > 0) {
				for (int i = 0; i < userVO.getUserStationList().size(); i++) {
					String userStation = (String) userVO.getUserStationList().get(i);
					// 处理岗位下的人数限制，如果超上限，则抛异常，事务回滚
					if (getStationUserRemain(userStation) <= 0)
						throw new DataAccessException("岗位的用户数超过上限");

					WF_ORG_USER_STATION uu = new WF_ORG_USER_STATION();
					uu.setUserId(userVO.getUserId());
					uu.setStationId(userStation);
					this.getSqlMapClient().insert("WF_ORG_STATION.insertUserStation", uu);
				}
			}
			// 插用户的角色
			if (userVO.getUserRoleList() != null && userVO.getUserRoleList().size() > 0) {
				for (int i = 0; i < userVO.getUserRoleList().size(); i++) {
					String userRole = (String) userVO.getUserRoleList().get(i);
					// 处理岗位下的人数限制，如果超上限，则抛异常，事务回滚
					if (getRoleUserRemain(userRole) <= 0)
						throw new DataAccessException("角色的用户数超过上限");

					WF_ORG_USER_ROLE ur = new WF_ORG_USER_ROLE();
					ur.setUserId(userVO.getUserId());
					ur.setRoleId(userRole);
					this.getSqlMapClient().insert("WF_ORG_ROLE.insertRoleUser", ur);
				}
			}
			// 插入扩展表信息
			if (userVO.getExtInfoMap() != null) {
				Iterator columnIter = userVO.getExtInfoMap().keySet().iterator();
				int columnTotal = userVO.getExtInfoMap().size();
				String insertExtInfoString1 = "INSERT INTO " + extTableName.toUpperCase() + " ("
						+ idColName.toUpperCase() + ',';
				String insertExtInfoString2 = " VALUES ('" + userVO.getUserId();
				if (!columnIter.hasNext()) {
					insertExtInfoString2 += "')";
				} else {
					insertExtInfoString2 += "','";
				}
				int j = 0;
				while (columnIter.hasNext()) {
					String columnName = columnIter.next().toString();
					j++;
					String columnValue = userVO.getExtInfoMap().get(columnName) == null ? ""
							: userVO.getExtInfoMap().get(columnName).toString();
					insertExtInfoString1 += columnName.toUpperCase();
					insertExtInfoString2 += columnValue;
					if (columnTotal == j) {
						insertExtInfoString1 += ")";
						insertExtInfoString2 += "')";
					} else {
						insertExtInfoString1 += ",";
						insertExtInfoString2 += "','";
					}
				}
				System.out.println(insertExtInfoString1 + insertExtInfoString2);
				conn = this.getSqlMapClient().getDataSource().getConnection();
				statement = conn.createStatement();
				statement.execute(insertExtInfoString1 + insertExtInfoString2);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("数据库操作异常");
		} finally {
			try {
				if (statement != null)
					statement.close();
				if (conn != null)
					conn.close();
			} catch (Exception ex) {
			}
		}
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 修改人员，包括（人员基本信息、人员扩展信息、人员的组织单元、人员的岗位、人员的角 色）
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param userVO
	 *            - 人员vo，包括（人员基本信息、人员扩展信息、人员的组织单元、人员的岗位、人员的角色 ）
	 * @return 无
	 * @throws DataAccessException
	 */
	public void updateUser(WF_ORG_USER userVO, String extTableName, String idColName) throws DataAccessException {
		Connection conn = null;
		Statement statement = null;

		try {
			this.getSqlMapClient().update("WF_ORG_USER.update", userVO);
			// 删除用户的组织单元
			this.getSqlMapClient().delete("WF_ORG_USER.deleteUserUnit", userVO.getUserId());
			// 删除用户的岗位
			this.getSqlMapClient().delete("WF_ORG_USER.deleteUserStation", userVO.getUserId());
			// 删除用户的所有角色
			this.getSqlMapClient().delete("WF_ORG_USER.deleteUserRole", userVO.getUserId());
			// 插用户的组织单元
			if (userVO.getUserUnitList() != null && userVO.getUserUnitList().size() > 0) {
				for (int i = 0; i < userVO.getUserUnitList().size(); i++) {
					String userUnit = (String) userVO.getUserUnitList().get(i);
					WF_ORG_USER_UNIT uu = new WF_ORG_USER_UNIT();
					uu.setUserId(userVO.getUserId());
					uu.setUnitId(userUnit);
					this.getSqlMapClient().insert("WF_ORG_USER.insertUserUnit", uu);
				}
			}
			// 插用户的岗位
			if (userVO.getUserStationList() != null && userVO.getUserStationList().size() > 0) {
				for (int i = 0; i < userVO.getUserStationList().size(); i++) {
					String userStation = (String) userVO.getUserStationList().get(i);
					WF_ORG_USER_STATION uu = new WF_ORG_USER_STATION();
					uu.setUserId(userVO.getUserId());
					uu.setStationId(userStation);
					this.getSqlMapClient().insert("WF_ORG_STATION.insertUserStation", uu);
				}
			}
			// 插用户的角色
			if (userVO.getUserRoleList() != null && userVO.getUserRoleList().size() > 0) {
				for (int i = 0; i < userVO.getUserRoleList().size(); i++) {
					String userRole = (String) userVO.getUserRoleList().get(i);
					WF_ORG_USER_ROLE ur = new WF_ORG_USER_ROLE();
					ur.setUserId(userVO.getUserId());
					ur.setRoleId(userRole);
					this.getSqlMapClient().insert("WF_ORG_ROLE.insertRoleUser", ur);
				}
			}
			// 更新扩展信息
			if (userVO.getExtInfoMap() != null) {
				Iterator columnIter = userVO.getExtInfoMap().keySet().iterator();
				if (columnIter.hasNext()) {
					int columnTotal = userVO.getExtInfoMap().size();
					String updateExtInfoString = "UPDATE " + extTableName.toUpperCase() + " SET ";
					String whereClause = " WHERE " + idColName.toUpperCase() + " = '" + userVO.getUserId() + "'";
					int j = 0;
					while (columnIter.hasNext()) {
						String columnName = columnIter.next().toString();
						j++;
						String columnValue = userVO.getExtInfoMap().get(columnName) == null ? ""
								: userVO.getExtInfoMap().get(columnName).toString();
						if (columnName.equalsIgnoreCase("id"))
							continue;
						updateExtInfoString += columnName.toUpperCase() + " = '" + columnValue + "'";
						if (columnTotal > j) {
							updateExtInfoString += ",";
						}
					}
					System.out.println(updateExtInfoString + whereClause);
					conn = this.getSqlMapClient().getDataSource().getConnection();
					statement = conn.createStatement();
					statement.execute(updateExtInfoString + whereClause);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("数据库操作异常");
		} finally {
			try {
				if (statement != null)
					statement.close();
				if (conn != null)
					conn.close();
			} catch (Exception ex) {
			}
		}
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 删除人员。如果人员已经被使用则不会被删除且抛出DataAccessException
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param userID
	 *            - 人员id
	 * @throws DataAccessException
	 */
	public void deleteUser(String userID, String extTableName, String idColumnName) throws DataAccessException {
		Connection conn = null;
		Statement stmt = null;
		try {
			// 删除用户的组织单元
			this.getSqlMapClient().delete("WF_ORG_USER.deleteUserUnit", userID);
			// 删除用户的角色
			this.getSqlMapClient().delete("WF_ORG_USER.deleteUserRole", userID);
			// 删除用户的岗位
			this.getSqlMapClient().delete("WF_ORG_USER.deleteUserStation", userID);
			// 删除用户的权限微调
			this.getSqlMapClient().delete("WF_ORG_USER.deleteUserPermission", userID);
			// 删除用户
			this.getSqlMapClient().delete("WF_ORG_USER.delete", userID);
			String deleteSQL = "delete FROM " + extTableName + " WHERE " + idColumnName.toUpperCase() + " = '" + userID
					+ "'";
			conn = this.getSqlMapClient().getDataSource().getConnection();
			stmt = conn.createStatement();
			stmt.execute(deleteSQL);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("用户已被使用，不能删除");
		} finally {
			try {
				if (stmt != null)
					stmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception ex) {
			}
		}
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 锁定用户
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param userID
	 *            - 用户id
	 * @throws DataAccessException
	 */
	public void lockUser(String userID, String isLocked) throws DataAccessException {
		try {
			if (isLocked.equals("否"))
				this.getSqlMapClient().update("WF_ORG_USER.lockUser", userID);
			else
				this.getSqlMapClient().update("WF_ORG_USER.unlockUser", userID);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("数据库操作异常");
		}
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取人员，包括（人员基本信息、人员扩展信息、人员的组织单元、人员的岗位、人员的角 色）
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param userID
	 *            - 用户主键
	 * @return 如果找到，返回WF_ORG_USER,包括（人员基本信息、人员扩展信息、人员的组织单元、人员 的岗位、人员的角色）
	 *         如果没有找到，返回null
	 * @throws DataAccessException
	 */
	public WF_ORG_USER getUserDetail(String userID) throws DataAccessException {
		WF_ORG_USER userDetail = null;
		try {
			WF_ORG_USER conditionVO = new WF_ORG_USER();
			conditionVO.setUserId(userID);
			List queryResult = getSqlMapClient().queryForList("WF_ORG_USER.select", conditionVO);
			if (queryResult != null && queryResult.size() > 0) {
				userDetail = (WF_ORG_USER) queryResult.get(0);
				// 取用户的组织单元

				// 取用户的岗位
				// 取用户的角色
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("根据条件查询用户时发生错误");
		}

		return userDetail;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取用户的总数，用于表格分页
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @return 用户总数
	 * @throws ServiceException
	 */
	public int getUserCount(WF_ORG_USER userVO) throws DataAccessException {
		int returnValue = 0;
		try {
			returnValue = (Integer) this.getSqlMapClient().queryForObject("WF_ORG_USER.count", userVO);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("根据条件查询用户时发生错误");
		}
		return returnValue;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据条件获用户(分页)
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param userVO
	 *            - 用户VO
	 * @return 如果找到，返回ArrayList<WF_ORG_USER> 如果没有找到，返回new ArrayList
	 * @throws DataAccessException
	 */
	public List getPagingUser(WF_ORG_USER userVO) throws DataAccessException {
		List userList = new ArrayList();
		try {
			userList = getSqlMapClient().queryForList("WF_ORG_USER.paging", userVO);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("根据条件查询用户时发生错误");
		}

		return userList;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取扩展信息
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param bizType
	 *            - 业务类型
	 * @param idColumnValue
	 *            - 主键字段值
	 * @throws DataAccessException
	 */
	public Map getExtInfo(String bizType, String idColumnValue) throws DataAccessException {
		Connection conn = null;
		Statement stmt = null;

		// 扩展表的表名
		String extTableName = "";
		// 扩展表的主键字段名
		String idColumnName = "";

		Map returnMap = new HashMap();
		Map temp = new HashMap();
		try {
			// 确定tableName和idColumnName
			BizTypeDefine bizTypeDefine = OrgnizationConfig.getBizTypeDefine(bizType);
			extTableName = bizTypeDefine.getTable();
			if (bizTypeDefine.getElementList() != null || bizTypeDefine.getElementList().size() > 0) {
				for (int j = 0; j < bizTypeDefine.getElementList().size(); j++) {
					ElementDefine ed = (ElementDefine) bizTypeDefine.getElementList().get(j);
					if (ed.getName().equalsIgnoreCase("id")) {
						idColumnName = ed.getColumn();
						break;
					}
				}
			} else {
				return new HashMap();
			}

			String selectSQL = "SELECT * FROM " + extTableName + " WHERE " + idColumnName + " = '" + idColumnValue
					+ "'";
			conn = this.getSqlMapClient().getDataSource().getConnection();
			stmt = conn.createStatement();
			// System.out.println(selectSQL);
			ResultSet rs = stmt.executeQuery(selectSQL);
			if (rs.next()) {
				for (int i = 1; i <= rs.getMetaData().getColumnCount(); i++) {
					temp.put(rs.getMetaData().getColumnName(i), rs.getString(i));
				}
				if (bizTypeDefine.getElementList() != null || bizTypeDefine.getElementList().size() > 0) {
					for (int j = 0; j < bizTypeDefine.getElementList().size(); j++) {
						ElementDefine ed = (ElementDefine) bizTypeDefine.getElementList().get(j);
						if (ed.getName().equalsIgnoreCase("id")) {
							idColumnName = ed.getColumn();
							continue;
						}
						returnMap.put(ed.getName(), temp.get(ed.getColumn()) == null ? "" : temp.get(ed.getColumn()));
					}
				}
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if (stmt != null)
					stmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception ex) {
			}
		}

		return returnMap;
	}
}
