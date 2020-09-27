package cn.rkylin.oms.system.user.dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import cn.rkylin.core.IDataBaseFactory;
import cn.rkylin.oms.system.position.dao.IPositionDAO;
import cn.rkylin.oms.system.position.domain.WF_ORG_USER_STATION;
import cn.rkylin.oms.system.role.dao.IRoleDAO;
import cn.rkylin.oms.system.role.domain.WF_ORG_USER_ROLE;
import cn.rkylin.oms.system.unit.domain.WF_ORG_USER_UNIT;
import cn.rkylin.oms.system.unit.vo.UnitVO;
import cn.rkylin.oms.system.user.domain.WF_ORG_USER;
import cn.rkylin.oms.system.user.vo.UserVO;


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
 * @author 王潇艺
 */
@Repository(value = "userDAO")
public class UserDAOImpl implements IUserDAO {
    /**
     * SqlSession连接
     */
    @Autowired
    private SqlSession sqlSession;
    @Autowired
    protected IDataBaseFactory dao;
    /**
     * 岗位数据访问对象
     */
    @Autowired
    protected IPositionDAO positionDAO;
    /**
     * 角色数据访问对象
     */
    @Autowired
    protected IRoleDAO roleDAO;

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
    @Override
    public List<UserVO> getUserByCondition(UserVO userVo) throws Exception {
        return dao.findAllList("getUserByCondition_paging", userVo);
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
    @SuppressWarnings({"rawtypes" })
    @Override
    public Map getExtInfo(String bizType, String idColumnValue) throws Exception {
        return new HashMap();
        // 扩展表的表名
        // String extTableName = "";
        // // 扩展表的主键字段名
        // String idColumnName = "";
        // Connection conn = null;
        // Statement stmt = null;
        //
        // Map returnMap = new HashMap();
        // Map temp = new HashMap();
        // try {
        // // 确定tableName和idColumnName
        // BizTypeDefine bizTypeDefine =
        // OrgnizationConfig.getBizTypeDefine(bizType);
        // extTableName = bizTypeDefine.getTable();
        // if (bizTypeDefine.getElementList() != null ||
        // bizTypeDefine.getElementList().size() > 0) {
        // for (int j = 0; j < bizTypeDefine.getElementList().size(); j++) {
        // ElementDefine ed = (ElementDefine)
        // bizTypeDefine.getElementList().get(j);
        // if (ed.getName().equalsIgnoreCase("id")) {
        // idColumnName = ed.getColumn();
        // break;
        // }
        // }
        // } else {
        // return new HashMap();
        // }
        //
        // String selectSQL = "SELECT * FROM " + extTableName + " WHERE " +
        // idColumnName + " = '" + idColumnValue
        // + "'";
        // conn =
        // sqlSession.getConfiguration().getEnvironment().getDataSource().getConnection();
        // stmt = conn.createStatement();
        // // System.out.println(selectSQL);
        // ResultSet rs = stmt.executeQuery(selectSQL);
        // if (rs.next()) {
        // for (int i = 1; i <= rs.getMetaData().getColumnCount(); i++) {
        // temp.put(rs.getMetaData().getColumnName(i), rs.getString(i));
        // }
        // if (bizTypeDefine.getElementList() != null ||
        // bizTypeDefine.getElementList().size() > 0) {
        // for (int j = 0; j < bizTypeDefine.getElementList().size(); j++) {
        // ElementDefine ed = (ElementDefine)
        // bizTypeDefine.getElementList().get(j);
        // if (ed.getName().equalsIgnoreCase("id")) {
        // idColumnName = ed.getColumn();
        // continue;
        // }
        // returnMap.put(ed.getName(), temp.get(ed.getColumn()) == null ? "" :
        // temp.get(ed.getColumn()));
        // }
        // }
        // }
        // } catch (SQLException e) {
        // e.printStackTrace();
        // } finally {
        // try {
        // if (stmt != null)
        // stmt.close();
        // if (conn != null)
        // conn.close();
        // } catch (Exception ex) {
        // }
        // }
        // return returnMap;
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
    @Override
    public void createUser(WF_ORG_USER userVO, String extTableName, String idColName) throws Exception {
        Connection conn = null;
            dao.insert("WF_ORG_USER_insert", userVO);
            // 插用户的组织单元
            if (userVO.getUserUnitList() != null && userVO.getUserUnitList().size() > 0) {
                for (int i = 0; i < userVO.getUserUnitList().size(); i++) {
                    String userUnit = (String) userVO.getUserUnitList().get(i);
                    WF_ORG_USER_UNIT uu = new WF_ORG_USER_UNIT();
                    uu.setUserId(userVO.getUserId());
                    uu.setUnitId(userUnit);
                    dao.insert("insertUserUnit", uu);
                }
            }
            // 插用户的岗位
            if (userVO.getUserStationList() != null && userVO.getUserStationList().size() > 0) {
                for (int i = 0; i < userVO.getUserStationList().size(); i++) {
                    String userStation = (String) userVO.getUserStationList().get(i);
                    // 处理岗位下的人数限制，如果超上限，则抛异常，事务回滚
                    if (getStationUserRemain(userStation) <= 0)
                        throw new Exception("岗位的用户数超过上限");

                    WF_ORG_USER_STATION uu = new WF_ORG_USER_STATION();
                    uu.setUserId(userVO.getUserId());
                    uu.setStationId(userStation);
                    positionDAO.insert("insertUserStation", uu); 
                }
            }
            // 插用户的角色
            if (userVO.getUserRoleList() != null && userVO.getUserRoleList().size() > 0) {
                for (int i = 0; i < userVO.getUserRoleList().size(); i++) {
                    String userRole = (String) userVO.getUserRoleList().get(i);
                    // 处理岗位下的人数限制，如果超上限，则抛异常，事务回滚
                    if (getRoleUserRemain(userRole) <= 0) {
                        throw new Exception("角色的用户数超过上限");
                    }

                    WF_ORG_USER_ROLE ur = new WF_ORG_USER_ROLE();
                    ur.setUserId(userVO.getUserId());
                    ur.setRoleId(userRole);
                    roleDAO.insertUserRole("insertRoleUser", ur);
                }
            }
            // 插入扩展表信息
            // if (userVO.getExtInfoMap() != null) {
            // Iterator columnIter = userVO.getExtInfoMap().keySet().iterator();
            // int columnTotal = userVO.getExtInfoMap().size();
            // String insertExtInfoString1 = "INSERT INTO " + extTableName + "
            // (" + idColName + ',';
            // String insertExtInfoString2 = " VALUES ('" + userVO.getUserId();
            // if (!columnIter.hasNext()) {
            // insertExtInfoString2 += "')";
            // } else {
            // insertExtInfoString2 += "','";
            // }
            // int j = 0;
            // while (columnIter.hasNext()) {
            // String columnName = columnIter.next().toString();
            // j++;
            // String columnValue = userVO.getExtInfoMap().get(columnName) ==
            // null ? ""
            // : userVO.getExtInfoMap().get(columnName).toString();
            // insertExtInfoString1 += columnName;
            // insertExtInfoString2 += columnValue;
            // if (columnTotal == j) {
            // insertExtInfoString1 += ")";
            // insertExtInfoString2 += "')";
            // } else {
            // insertExtInfoString1 += ",";
            // insertExtInfoString2 += "','";
            // }
            // }
            // System.out.println(insertExtInfoString1 + insertExtInfoString2);
            // conn =
            // sqlSession.getConfiguration().getEnvironment().getDataSource().getConnection();
            // statement = conn.createStatement();
            // statement.execute(insertExtInfoString1 + insertExtInfoString2);
            // }
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
    private int getStationUserRemain(String stationID) throws Exception {
        int returnValue = -1;
        Object obj = dao.findList("stationUserRemain", stationID);
        if (obj != null) {
            returnValue = (Integer) obj;
        }
        return returnValue;
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
    private int getRoleUserRemain(String roleID) throws Exception {
        int returnValue = -1;
        Object obj = dao.findList("roleUserRemain", roleID).size();
        if (obj != null) {
            returnValue = (Integer) obj;
        }
        return returnValue;
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
    @Override
    public void updateUser(WF_ORG_USER userVO, String extTableName, String idColName) throws Exception {
        dao.update("updateUser", userVO);
        // 删除用户的组织单元
        // userVO.getUserId());
        dao.delete("deleteUserUnit", userVO);
        // 删除用户的岗位
        // userVO.getUserId());
        dao.delete("deleteUserStation", userVO);
        // 删除用户的所有角色
        dao.delete("deleteUserRole", userVO);
        // 插用户的组织单元
        if (userVO.getUserUnitList() != null && userVO.getUserUnitList().size() > 0) {
            for (int i = 0; i < userVO.getUserUnitList().size(); i++) {
                String userUnit = (String) userVO.getUserUnitList().get(i);
                WF_ORG_USER_UNIT uu = new WF_ORG_USER_UNIT();
                uu.setUserId(userVO.getUserId());
                uu.setUnitId(userUnit);
                dao.insert("insertUserUnit", uu);
            }
        }
        // 插用户的岗位
        if (userVO.getUserStationList() != null && userVO.getUserStationList().size() > 0) {
            for (int i = 0; i < userVO.getUserStationList().size(); i++) {
                String userStation = (String) userVO.getUserStationList().get(i);
                // 处理岗位下的人数限制，如果超上限，则抛异常，事务回滚
                WF_ORG_USER_STATION uu = new WF_ORG_USER_STATION();
                uu.setUserId(userVO.getUserId());
                uu.setStationId(userStation);
                positionDAO.insert("insertUserStation", uu);
            }
        }
        // 插用户的角色
        if (userVO.getUserRoleList() != null && userVO.getUserRoleList().size() > 0) {
            for (int i = 0; i < userVO.getUserRoleList().size(); i++) {
                String userRole = (String) userVO.getUserRoleList().get(i);
                // 处理岗位下的人数限制，如果超上限，则抛异常，事务回滚
                WF_ORG_USER_ROLE ur = new WF_ORG_USER_ROLE();
                ur.setUserId(userVO.getUserId());
                ur.setRoleId(userRole);
                roleDAO.insertUserRole("insertRoleUser", ur);
            }
        }
        // 更新扩展信息
        // if (userVO.getExtInfoMap() != null) {
        // Iterator columnIter = userVO.getExtInfoMap().keySet().iterator();
        // if (columnIter.hasNext()) {
        // int columnTotal = userVO.getExtInfoMap().size();
        // String updateExtInfoString = "UPDATE " + extTableName + " SET ";
        // String whereClause = " WHERE " + idColName + " = '" +
        // userVO.getUserId() + "'";
        // int j = 0;
        // while (columnIter.hasNext()) {
        // String columnName = columnIter.next().toString();
        // j++;
        // String columnValue = userVO.getExtInfoMap().get(columnName) ==
        // null ? ""
        // : userVO.getExtInfoMap().get(columnName).toString();
        // if (columnName.equalsIgnoreCase("id"))
        // continue;
        // updateExtInfoString += columnName + " = '" + columnValue + "'";
        // if (columnTotal > j) {
        // updateExtInfoString += ",";
        // }
        // }
        // System.out.println(updateExtInfoString + whereClause);
        // conn =
        // sqlSession.getConfiguration().getEnvironment().getDataSource().getConnection();
        // statement = conn.createStatement();
        // statement.execute(updateExtInfoString + whereClause);
        // }
        // }
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
    @Override
    public void lockUser(String userID, String isLocked) throws Exception {
        if (isLocked.equals("否")){
            dao.update("lockUser", userID);
        }else{
            dao.update("unlockUser", userID);
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
    @Override
    public void deleteUser(String userID, String extTableName, String idColumnName) throws Exception {
        // Connection conn = null;
        // Statement stmt = null;
        WF_ORG_USER user = new WF_ORG_USER();
        user.setUserId(userID);
        // 删除用户的组织单元
        dao.delete("deleteUserUnit", user);
        // 删除用户的角色
        dao.delete("deleteUserRole", user);
        // 删除用户的岗位
        dao.delete("deleteUserStation", user);
        // 删除用户的权限微调
        dao.delete("deleteUserPermission", userID);
        // 删除用户
        dao.delete("delete", userID);
        // String deleteSQL = "delete FROM " + extTableName + " WHERE " +
        // idColumnName + " = '" + userID + "'";
        // conn =
        // sqlSession.getConfiguration().getEnvironment().getDataSource().getConnection();
        // stmt = conn.createStatement();
        // stmt.execute(deleteSQL);
        // finally {
        // try {
        // if (stmt != null)
        // stmt.close();
        // if (conn != null)
        // conn.close();
        // } catch (Exception ex) {
        // }
        // }

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
    @SuppressWarnings("rawtypes")
    @Override
    public List getUserByCondition(WF_ORG_USER userVO) throws Exception {
        return dao.findAllList("select_user", userVO);
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
    public List getUserByIDs(WF_ORG_USER userVO) throws Exception {
        List userList = new ArrayList();
        userList = dao.findList("WF_ORG_USER.selectByIDs", userVO.getUserIds().toString()); // TODO
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
    @SuppressWarnings("rawtypes")
    @Override
    public List getUserByUnitID(UnitVO unitVO) throws Exception {
		return dao.findAllList("WF_ORG_USER_selectUser", unitVO);
    }

    @Override
    public List findmaxPerson(WF_ORG_USER orgUser) throws Exception {
          return dao.findAllList("WF_ORG_USER_findmaxPerson", orgUser);
    }

}
