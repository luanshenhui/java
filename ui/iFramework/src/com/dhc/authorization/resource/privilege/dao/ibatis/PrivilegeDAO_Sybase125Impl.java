
package com.dhc.authorization.resource.privilege.dao.ibatis;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

import com.dhc.authorization.resource.privilege.dao.IMenuGrantDAO;
import com.dhc.authorization.resource.privilege.domain.WF_ORG_RESOURCE_AUTHORITY;
import com.dhc.base.exception.DataAccessException;
import com.dhc.base.exception.ServiceException;

/**
 * brief description
 * <p>
 * Date : 2010/05/12
 * </p>
 * <p>
 * Module : 权限管理
 * </p>
 * <p>
 * Description: 权限管理数据访问对象实现
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
public class PrivilegeDAO_Sybase125Impl extends SqlMapClientDaoSupport implements IMenuGrantDAO {

	/**
	 * 构造函数
	 */
	public PrivilegeDAO_Sybase125Impl() {

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 插入用户权限排除信息
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param userID
	 *            - 用户的id
	 * @param resourceID
	 *            - 资源id
	 * @return 无
	 * @throws DataAccessException
	 */
	public void insertUserExclude(String userID, String resourceID) throws DataAccessException {
		try {
			Map insertMap = new HashMap();
			insertMap.put("userId", userID);
			insertMap.put("resourceId", resourceID);
			this.getSqlMapClient().insert("WF_ORG_RESOURCE_AUTHORITY.insertUserExclude", insertMap);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("PrivilegeDAO数据访问错误");
		}
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 删除用户权限排除信息
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param userID
	 *            - 用户的id
	 * @param resourceID
	 *            - 资源id
	 * @return 无
	 * @throws DataAccessException
	 */
	public void deleteUserExclude(String userID, String resourceID) throws DataAccessException {
		try {
			Map deleteMap = new HashMap();
			deleteMap.put("userId", userID);
			deleteMap.put("resourceId", resourceID);
			this.getSqlMapClient().insert("WF_ORG_RESOURCE_AUTHORITY.deleteUserExclude", deleteMap);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("PrivilegeDAO数据访问错误");
		}
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 查询用户对于某资源是否在unit,station,role上可用
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param userID
	 *            - 用户的id
	 * @param resourceID
	 *            - 资源id
	 * @return 可用返回true，不可用返回false
	 * @throws DataAccessException
	 */
	public boolean ifUserResourceAvailable(String userID, String resourceID) throws DataAccessException {
		boolean returnValue = false;
		try {
			List resultList1 = this.getSqlMapClient()
					.queryForList("WF_ORG_RESOURCE_AUTHORITY.getUnitStationRoleAvailableResourceCount1", userID);
			// String strVal = "" ;
			// for(int i=0;i<resultList1.size();i++){
			// String str = resultList1.get(i).toString();
			// String comma1 = "'";
			// String comma2 = ",";
			// if(i<resultList1.size()-1){
			// strVal += comma1 + str + comma1 + comma2;
			// }else{
			// strVal += comma1 + str + comma1 ;
			// }
			// }
			Map paramMap = new HashMap();
			paramMap.put("userIdTemp", resultList1);// strVal);
			paramMap.put("resourceId", resourceID);
			paramMap.put("userID", userID);
			Object resultObj = this.getSqlMapClient()
					.queryForObject("WF_ORG_RESOURCE_AUTHORITY.getUnitStationRoleAvailableResourceCount2", paramMap);
			// returnValue = Integer.parseInt(resultObj1.toString()) > 0 ? true
			// : false;
			returnValue = Integer.parseInt(resultObj.toString()) > 0 ? true : false;
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("PrivilegeDAO数据访问错误");
		}
		return returnValue;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据条件获取资源授权信息
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param authVO
	 *            - 授权查询条件VO
	 * @return 如果找到，返回List 如果没有找到，返回new ArrayList
	 * @throws DataAccessException
	 */
	public List getResourceAuthority(WF_ORG_RESOURCE_AUTHORITY authVO) throws DataAccessException {
		List resultList = null;
		try {
			resultList = this.getSqlMapClient().queryForList("WF_ORG_RESOURCE_AUTHORITY.select", authVO);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("PrivilegeDAO数据访问错误");
		}
		return resultList;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据角色id，获取该角色可以使用的菜单树。返回的结果Map：key=菜单id，值=是否有可用
	 * </p>
	 * <p>
	 * 备注: 详见顺序图 <statement id="getTest" resultClass="java.util.HashMap"> SELECT
	 * ID, NAME FROM TEST </statement>
	 * 
	 * 
	 * public Map getMapTest(){ List testList =
	 * (Student)sqlMap.queryForList("getTest",null); Map result = new HashMap();
	 * for(int i=0; i<testList.size(); i++){ Map tmp = (Map)testList.get(i);
	 * result.put(tmp.get("id"),tmp.get("name")); } }
	 * 
	 * </p>
	 * 
	 * @param roleID
	 *            - 角色id
	 * @param privilegeType
	 *            - 授权类型：assignable，available（可分配，可使用）
	 * @return 如果找到，返回HashMap<JT_MENU> 如果没有找到，返回null
	 * @throws DataAccessException
	 */
	public Map getRoleMenuTreePrivileges(String roleID, String privilegeType) throws DataAccessException {
		return null;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据岗位id，获取该岗位可以使用的菜单树。返回的结果Map：key=菜单id，值=是否有可用
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param stationID
	 *            - 岗位id
	 * @param privilegeType
	 *            - 授权类型：assignable，available（可分配，可使用）
	 * @return 如果找到，返回HashMap<JT_MENU> 如果没有找到，返回null
	 * @throws DataAccessException
	 */
	public Map getStationMenuTreePrivileges(String stationID, String privilegeType) throws DataAccessException {
		return null;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据角色id，菜单项id，获取该菜单项下所有元素 的可用性。返回的结果Map：key=元素id，值=是否可用
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param authVO
	 *            - 授权查询条件VO
	 * @param type
	 *            - 查询类型（user、role、unit、station）
	 * @return 如果找到，返回HashMap 如果没有找到，返回null
	 * @throws DataAccessException
	 */
	public Map getElementPrivByMenuIDRoleID(WF_ORG_RESOURCE_AUTHORITY authVO, String type) throws DataAccessException {
		Map resultList = null;
		String strVal = "";
		try {
			if (type.equals("user")) {
				// resultList = this.getSqlMapClient().queryForMap(
				// "WF_ORG_RESOURCE_AUTHORITY.getUserAvailableResource",
				// authVO, "RESOURCE_ID");
				List resultList1 = this.getSqlMapClient()
						.queryForList("WF_ORG_RESOURCE_AUTHORITY.getUserAvailableResourcePart1", authVO);
				// if(resultList1 != null && resultList1.size() == 1){
				// strVal = resultList1.get(0).toString();
				// } else {
				// for(int i=0;i<resultList1.size();i++){
				// String str = resultList1.get(i).toString();
				// String comma1 = "'";
				// String comma2 = ",";
				// if(i<resultList1.size()-1){
				// if (i == 0)
				// strVal += str + comma1 + comma2;
				// else
				// strVal += comma1 + str + comma1 + comma2;
				// }else{
				// strVal += comma1 + str ;
				// }
				// }
				// }
				authVO.setRoleIdTem(resultList1);// strVal);
				resultList = this.getSqlMapClient()
						.queryForMap("WF_ORG_RESOURCE_AUTHORITY.getUserAvailableResourcePart2", authVO, "RESOURCE_ID");

			} else {
				resultList = this.getSqlMapClient().queryForMap("WF_ORG_RESOURCE_AUTHORITY.getAvailableResource",
						authVO, "RESOURCE_ID");
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
	 * 描述: 根据岗位id，菜单项id，获取该菜单项下所有元素 的可用性。返回的结果Map：key=元素id，值=是否可用
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param authVO
	 *            - 授权查询条件VO
	 * @return 如果找到，返回HashMap 如果没有找到，返回null
	 * @throws DataAccessException
	 */
	public Map getElementPrivByMenuIDStationID(WF_ORG_RESOURCE_AUTHORITY authVO) throws DataAccessException {
		return null;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 删除特定类型的权限（见参数）
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param resourceVO
	 *            - 资源授权对象VO
	 * @throws DataAccessException
	 */
	public void deletePrivileges(WF_ORG_RESOURCE_AUTHORITY resAuth) throws DataAccessException {
		try {
			this.getSqlMapClient().delete("WF_ORG_RESOURCE_AUTHORITY.delete", resAuth);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("PrivilegeDAO数据访问错误");
		}
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 新建特定类型的权限（见参数）
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param resourceVO
	 *            - 资源授权对象VO
	 * @throws DataAccessException
	 */
	public void insertPrivilege(WF_ORG_RESOURCE_AUTHORITY resAuth) throws DataAccessException {
		try {
			this.getSqlMapClient().insert("WF_ORG_RESOURCE_AUTHORITY.insert", resAuth);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("PrivilegeDAO数据访问错误");
		}
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据帐户，判断url或者menuItem是否可用
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param paramMap
	 *            - 查询参数map
	 * @throws ServiceException
	 */
	public boolean isResourceAvailable(Map paramMap) throws DataAccessException {
		boolean returnValue = false;
		try {
			// Object resultObj = this
			// .getSqlMapClient()
			// .queryForObject(
			// "WF_ORG_RESOURCE_AUTHORITY.getUserResourcePrivilege",
			// paramMap);
			List resultList1 = this.getSqlMapClient()
					.queryForList("WF_ORG_RESOURCE_AUTHORITY.getUserResourcePrivilegePart1", paramMap);
			String strVal = "";
			for (int i = 0; i < resultList1.size(); i++) {
				String str = resultList1.get(i).toString();
				String comma1 = "'";
				String comma2 = ",";
				if (i < resultList1.size() - 1) {
					strVal += comma1 + str + comma1 + comma2;
				} else {
					strVal += comma1 + str + comma1;
				}
			}
			paramMap.put("roleIdTemp", strVal);
			List resultList2 = this.getSqlMapClient()
					.queryForList("WF_ORG_RESOURCE_AUTHORITY.getUserResourcePrivilegePart1", paramMap);
			// returnValue = Integer.parseInt(resultObj1.toString()) > 0 ? true
			// : false;
			returnValue = resultList2.size() > 0 ? true : false;
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException("PrivilegeDAO数据访问错误");
		}
		return returnValue;
	}
}
