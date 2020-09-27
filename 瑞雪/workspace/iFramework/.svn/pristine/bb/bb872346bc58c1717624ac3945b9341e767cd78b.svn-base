package com.dhc.organization.unit.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.dhc.base.exception.DataAccessException;
import com.dhc.organization.unit.domain.WF_ORG_TREE_V;
import com.dhc.organization.unit.domain.WF_ORG_UNIT;

/**
 * brief description
 * <p>
 * Date : 2010/05/05
 * </p>
 * <p>
 * Module : 组织单元管理
 * </p>
 * <p>
 * Description: 组织单元数据访问对象接口
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
public interface IUnitDAO {

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
	public WF_ORG_TREE_V getUnitTree(String userID) throws DataAccessException;

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
	 * @throws DataAccessException
	 */
	public List getRootUnit(String userID) throws DataAccessException;

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
	public List getSubUnit(String userID, String parentUnitID) throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 组织机构类型 查询时：DICT_TYPE='unittype'
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param userID
	 *            - 用户id
	 * @param parentUnitID
	 *            - 父组织id
	 * @return 如果找到，返回ArrayList<WF_ORG_DICTIONARY> 如果没有找到，返回new ArrayList
	 * @throws DataAccessException
	 */
	public ArrayList getUnitType(String type) throws DataAccessException;

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
	public void createUnit(WF_ORG_UNIT unitVO, String extTableName, String idColName) throws DataAccessException;

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
	public void updateUnit(WF_ORG_UNIT unitVO, String extTableName, String idColName) throws DataAccessException;

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
	public List getUnitByCondition(WF_ORG_UNIT unitVO) throws DataAccessException;

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
	 * @throws DataAccessException
	 */
	public void deleteUnit(String unitID, String extTableName, String idColumnName, boolean advanceDelete)
			throws DataAccessException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取扩展信息
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param extTableName
	 *            - 扩展表名称
	 * @throws DataAccessException
	 */
	public Map getExtInfo(String bizType, String idColumnValue) throws DataAccessException;
}
