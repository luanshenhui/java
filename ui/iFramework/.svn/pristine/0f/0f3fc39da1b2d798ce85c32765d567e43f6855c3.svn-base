package com.dhc.organization.unit.dao.ibatis;

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
import com.dhc.organization.config.BizTypeDefine;
import com.dhc.organization.config.ElementDefine;
import com.dhc.organization.config.OrgnizationConfig;
import com.dhc.organization.unit.dao.IUnitDAO;
import com.dhc.organization.unit.domain.WF_ORG_TREE_V;
import com.dhc.organization.unit.domain.WF_ORG_UNIT;
import com.dhc.organization.unit.domain.WF_ORG_USER_UNIT;

/**
 * brief description
 * <p>
 * Date : 2010/05/05
 * </p>
 * <p>
 * Module : 组织机构管理
 * </p>
 * <p>
 * Description: 组织单元数据访问对象实现
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
public class UnitDAOImpl extends SqlMapClientDaoSupport implements IUnitDAO {

	/**
	 * 构造函数
	 */
	public UnitDAOImpl() {

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据UserID获取组织机构树，并标记出哪些结点是用户可以编辑的 1、获取所有组织机构 2、计算该用户是否能管理此组织机构
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param userID
	 *            - 用户id
	 * @return 如果找到，返回JT_UNIT_TREE_V 如果没有找到，返回null
	 * @throws DataAccessException
	 */
	public WF_ORG_TREE_V getUnitTree(String userID) throws DataAccessException {
		return null;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取根组织，需要考虑当前组织，该用户是否能管理
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param userID
	 *            - 用户id
	 * @return 如果找到，返回JT_UNIT_TREE_V 如果没有找到，返回null
	 * @throws SQLException
	 * @throws Exception
	 * @throws SQLException
	 * @throws SQLException
	 * @throws DataAccessException
	 */
	public List getRootUnit(String userID) throws DataAccessException {
		List treeRoot = new ArrayList();
		try {
			treeRoot = getSqlMapClient().queryForList("WF_ORG_UNIT.selectRootUnit", userID);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("数据库操作异常");
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new DataAccessException("未知异常");
		}
		return treeRoot;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取某组织下的所有子组织，需要考虑当前组织，该用户是否能管理
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param userID
	 *            - 用户id
	 * @param parentUnitID
	 *            - 父组织id
	 * @return 如果找到，返回List<JT_UNIT_TREE_V> 如果没有找到，返回null
	 * @throws DataAccessException
	 */
	public List getSubUnit(String userID, String parentUnitID) throws DataAccessException {
		List subTree = new ArrayList();
		HashMap paramMap = new HashMap();
		paramMap.put("userID", userID);
		paramMap.put("parentUnitID", parentUnitID);
		try {
			subTree = getSqlMapClient().queryForList("WF_ORG_UNIT.selectSubUnit", paramMap);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("数据库操作异常");
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new DataAccessException("未知异常");
		}
		return subTree;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 组织机构类型 查询时：DICT_TYPE='unittype'
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @return 如果找到，返回ArrayList<WF_ORG_DICTIONARY> 如果没有找到，返回new ArrayList
	 * @throws DataAccessException
	 */
	public ArrayList getUnitType(String type) throws DataAccessException {
		List unitType = new ArrayList();
		// String dictType = "unittype";
		try {
			unitType = getSqlMapClient().queryForList("WF_ORG_DICTIONARY.selectUnitType", type);
			if (unitType == null) {
				unitType = new ArrayList();
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("数据库操作异常");
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new DataAccessException("未知异常");
		}
		return (ArrayList) unitType;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 新建组织单元，包括（组织机构基本信息、上级岗位信息、人员信息）
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param unitVO
	 *            - 含有人员列表的组织单元vo
	 * @param extTableName
	 *            - 扩展表名称
	 * @param idColName
	 *            - 扩展表id列名称
	 * @throws DataAccessException
	 */
	public void createUnit(WF_ORG_UNIT unitVO, String extTableName, String idColName) throws DataAccessException {
		Connection conn = null;
		Statement statement = null;
		try {
			this.getSqlMapClient().insert("WF_ORG_UNIT.insert", unitVO);
			if (unitVO.getUnitUsersArray() != null) {
				for (int i = 0; i < unitVO.getUnitUsersArray().length; i++) {
					WF_ORG_USER_UNIT userUnitVO = new WF_ORG_USER_UNIT();
					userUnitVO.setUnitId(unitVO.getUnitId());
					userUnitVO.setUserId(unitVO.getUnitUsersArray()[i].toString());
					// userUnitVO.setUnitUsersArray(unitVO.getUnitUsersArray());
					this.getSqlMapClient().insert("WF_ORG_UNIT.insertUserUnit", userUnitVO);
				}
			}
			if (unitVO.getExtInfoMap() != null) {
				Iterator columnIter = unitVO.getExtInfoMap().keySet().iterator();
				int columnTotal = unitVO.getExtInfoMap().size();
				String insertExtInfoString1 = "INSERT INTO " + extTableName + " (" + idColName + ',';
				String insertExtInfoString2 = " VALUES ('" + unitVO.getUnitId();
				if (!columnIter.hasNext()) {
					insertExtInfoString2 += "')";
				} else {
					insertExtInfoString2 += "','";
				}
				int j = 0;
				while (columnIter.hasNext()) {
					String columnName = columnIter.next().toString();
					j++;
					String columnValue = unitVO.getExtInfoMap().get(columnName) == null ? ""
							: unitVO.getExtInfoMap().get(columnName).toString();
					// if(!columnValue.equals(""))
					insertExtInfoString1 += columnName;
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
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new DataAccessException("未知异常");
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
	 * 描述: 修改组织单元，包括（组织机构基本信息、上级岗位信息、人员信息）
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param unitVO
	 *            - 含有人员列表的组织单元vo
	 * @param extTableName
	 *            - 扩展表名称
	 * @param idColName
	 *            - 扩展表id列名称
	 * @throws DataAccessException
	 */
	public void updateUnit(WF_ORG_UNIT unitVO, String extTableName, String idColName) throws DataAccessException {
		Connection conn = null;
		Statement statement = null;
		try {
			getSqlMapClient().update("WF_ORG_UNIT.updateUnit", unitVO);
			getSqlMapClient().delete("WF_ORG_UNIT.deleteUserUnit", unitVO.getUnitId());
			if (unitVO.getUnitUsersArray() != null) {
				for (int i = 0; i < unitVO.getUnitUsersArray().length; i++) {
					WF_ORG_USER_UNIT userUnitVO = new WF_ORG_USER_UNIT();
					userUnitVO.setUnitId(unitVO.getUnitId());
					userUnitVO.setUserId(unitVO.getUnitUsersArray()[i].toString());
					this.getSqlMapClient().insert("WF_ORG_UNIT.insertUserUnit", userUnitVO);
				}
			}
			if (unitVO.getExtInfoMap() != null) {
				Iterator columnIter = unitVO.getExtInfoMap().keySet().iterator();
				if (columnIter.hasNext()) {
					int columnTotal = unitVO.getExtInfoMap().size();
					String updateExtInfoString = "UPDATE " + extTableName + " SET ";
					String whereClause = " WHERE " + idColName + " = '" + unitVO.getUnitId() + "'";
					int j = 0;
					while (columnIter.hasNext()) {
						String columnName = columnIter.next().toString();
						j++;
						String columnValue = unitVO.getExtInfoMap().get(columnName) == null ? ""
								: unitVO.getExtInfoMap().get(columnName).toString();
						if (columnName.equalsIgnoreCase("id"))
							continue;
						updateExtInfoString += columnName + " = '" + columnValue + "'";
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
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new DataAccessException("未知异常");
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
		// 扩展表的表名
		String extTableName = "";
		// 扩展表的主键字段名
		String idColumnName = "";
		Connection conn = null;
		Statement stmt = null;

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

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据条件获取组织单元
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param unitVO
	 *            - 组织单元条件值对象
	 * @return 如果找到，返回ArrayList<WF_ORG_UNIT> 如果没有找到，返回new ArrayList
	 * @throws DataAccessException
	 */
	public List getUnitByCondition(WF_ORG_UNIT unitVO) throws DataAccessException {
		List returnValue = new ArrayList();
		try {
			returnValue = getSqlMapClient().queryForList("WF_ORG_UNIT.select", unitVO);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("数据库操作异常");
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new DataAccessException("未知异常");
		}
		return returnValue;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 删除组织单元。如果组织单元下面有角色、人员、岗位，则该组织单元不能删除
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param unitID
	 *            - 组织单元id
	 * @param extTableName
	 *            - 扩展表名称
	 * @param idColumnName
	 *            - 扩展表id列名称
	 * @throws DataAccessException
	 */
	public void deleteUnit(String unitID, String extTableName, String idColumnName, boolean advanceDelete)
			throws DataAccessException {
		Connection conn = null;
		Statement stmt = null;
		WF_ORG_UNIT unitVO = new WF_ORG_UNIT();
		unitVO.setUnitId(unitID);
		try {
			// 如果是高级删除，则先删除组织管理角色和组织下的用户
			if (advanceDelete) {
				getSqlMapClient().delete("WF_ORG_UNIT.deleteUnitRoles", unitVO);
				getSqlMapClient().delete("WF_ORG_UNIT.deleteUnitUsers", unitVO);
			}
			// 再删除组织单元
			getSqlMapClient().delete("WF_ORG_UNIT.delete", unitVO);
			String deleteSQL = "delete FROM " + extTableName + " WHERE " + idColumnName + " = '" + unitID + "'";
			conn = this.getSqlMapClient().getDataSource().getConnection();
			stmt = conn.createStatement();
			stmt.execute(deleteSQL);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("组织单元非空或者被使用，无法删除");
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new DataAccessException("未知异常");
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
}
