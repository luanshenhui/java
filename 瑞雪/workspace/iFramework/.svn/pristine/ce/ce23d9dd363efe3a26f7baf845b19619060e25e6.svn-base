package com.dhc.organization.unit.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.dhc.base.core.Service;
import com.dhc.base.exception.DataAccessException;
import com.dhc.base.exception.ServiceException;
import com.dhc.organization.config.OrgI18nConsts;
import com.dhc.organization.position.dao.IPositionDAO;
import com.dhc.organization.position.domain.WF_ORG_STATION;
import com.dhc.organization.unit.dao.IUnitDAO;
import com.dhc.organization.unit.domain.WF_ORG_UNIT;
import com.dhc.organization.user.dao.IUserDAO;

/**
 * brief description
 * <p>
 * Date : 2010/05/05
 * </p>
 * <p>
 * Module : 组织单元管理
 * </p>
 * <p>
 * Description: 组织单元业务对象
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
public class UnitService implements Service {
	/**
	 * 组织单元数据访问接口
	 */
	private IUnitDAO iunitDAO;

	public IUnitDAO getIunitDAO() {
		return iunitDAO;
	}

	public void setIunitDAO(IUnitDAO iunitDAO) {
		this.iunitDAO = iunitDAO;
	}

	/**
	 * 用户数据访问接口
	 */
	private IUserDAO iuserDAO;

	public void setIuserDAO(IUserDAO iuserDAO) {
		this.iuserDAO = iuserDAO;
	}

	public IUserDAO getIuserDAO() {
		return iuserDAO;
	}

	/**
	 * 岗位数据访问接口
	 */
	private IPositionDAO ipositionDAO;

	public IPositionDAO getIpositionDAO() {
		return ipositionDAO;
	}

	public void setIpositionDAO(IPositionDAO ipositionDAO) {
		this.ipositionDAO = ipositionDAO;
	}

	/**
	 * 构造函数
	 */
	public UnitService() {
		super();
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据UserID获取组织机构树，并标记出哪些结点是用户可以编辑的
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param userID
	 *            - 用户id
	 * @return 如果找到，返回JT_UNIT_TREE_V 如果没有找到，返回null
	 * @throws ServiceException
	 */
	public List getUnitTree(String userID) throws ServiceException {
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
	 * @throws ServiceException
	 */
	public List getRootUnit(String userID) throws ServiceException {
		List unitTree = null;
		try {
			unitTree = iunitDAO.getRootUnit(userID);
		} catch (DataAccessException ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_DBACCESS);
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}
		return unitTree;
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
	 * @throws ServiceException
	 */
	public List getSubUnit(String userID, String parentUnitID, boolean needStation, boolean needManagable)
			throws ServiceException {
		List subTree = null;
		if (iunitDAO == null)
			throw new ServiceException("数据访问对象为空，请检查dataAccessContext文件");
		try {
			subTree = iunitDAO.getSubUnit(userID, parentUnitID);
			// 如果需要获取岗位，则取出该组织下的岗位
			if (needStation) {
				WF_ORG_STATION stationParam = new WF_ORG_STATION();

				if (needManagable) {
					stationParam.setUserId(userID);
					stationParam.setManagable("true");
				} else
					stationParam.setManagable("false");
				stationParam.setUnitId(parentUnitID);
				List positionList = ipositionDAO.getStationByCondition(stationParam);
				if (subTree == null)
					subTree = new ArrayList();
				if (positionList != null && positionList.size() > 0) {
					for (int i = 0; i < positionList.size(); i++) {
						WF_ORG_STATION temp = (WF_ORG_STATION) positionList.get(i);
						Map stationMap = new HashMap();
						stationMap.put("PARENT_UNIT_ID", parentUnitID + "@UNIT");
						stationMap.put("STATION_ID", temp.getStationId() + "@STATION");
						// 叫UNIT_ID是因为前台写死了。这样改改比较简单
						stationMap.put("UNIT_ID", temp.getStationId() + "@STATION");
						stationMap.put("STATION_NAME", temp.getStationName());
						stationMap.put("MANAGEABLE", temp.getManagable());
						subTree.add(stationMap);
					}
				}
			}
		} catch (DataAccessException e) {
			e.printStackTrace();
			throw new ServiceException(e.getMessage());
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException("数据访问未知异常");
		}
		return subTree;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 组织机构类型
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @return 如果找到，返回ArrayList<WF_ORG_DICTIONARY> 如果没有找到，返回new ArrayList
	 * @throws ServiceException
	 */
	public ArrayList getUnitType(String type) throws ServiceException {
		ArrayList unitType = new ArrayList();
		try {
			unitType = iunitDAO.getUnitType(type);
		} catch (DataAccessException e) {
			e.printStackTrace();
			throw new ServiceException(e.getMessage());
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException("数据访问未知异常");
		}
		return unitType;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 保存组织单元，包括（组织机构基本信息、上级岗位信息、人员信息）
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param unitVO
	 *            - 含有人员列表的组织单元vo
	 * @param saveType
	 *            - 保存类型，0：新增保存，1：修改保存
	 * @return 保存后的WF_ORG_UNIT
	 * @throws ServiceException
	 */
	public List saveUnit(WF_ORG_UNIT unitVO, String saveType, String extTableName, String idColName)
			throws ServiceException {
		try {
			if (saveType.equals("0")) {
				iunitDAO.createUnit(unitVO, extTableName, idColName);
			} else {
				iunitDAO.updateUnit(unitVO, extTableName, idColName);
			}
		} catch (DataAccessException e) {
			e.printStackTrace();
			throw new ServiceException(e.getMessage());
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException("数据访问未知异常");
		}
		return null;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据UnitID获取组织单元的明细信息 注意：WF_ORG_UNIT包含基本信息和人员信息
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param unitID
	 *            - 组织单元id
	 * @return 如果找到，返回WF_ORG_UNIT 如果没有找到，返回null
	 * @throws ServiceException
	 */
	public WF_ORG_UNIT getUnitDetail(String unitID) throws ServiceException {
		WF_ORG_UNIT unitVO = new WF_ORG_UNIT();
		unitVO.setUnitId(unitID);
		List listUnit = null;
		try {
			listUnit = iunitDAO.getUnitByCondition(unitVO);
			unitVO = (WF_ORG_UNIT) listUnit.get(0);
			unitVO.setExtInfoMap(iunitDAO.getExtInfo("unit", unitID));
			// WF_ORG_UNIT unit = (WF_ORG_UNIT)listUnit.get(0);
			// listUser = iuserDAO.getUserByUnitID(unitID);
			// unit.setUserList(listUser);
		} catch (DataAccessException e) {
			e.printStackTrace();
			throw new ServiceException(e.getMessage());
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException("数据访问未知异常");
		}
		return unitVO;
	}

	/**
	 * 获取用户信息
	 */
	public List getUserDetail(String unitID) throws ServiceException {
		List listUser = null;
		try {
			listUser = iuserDAO.getUserByUnitID(unitID);
		} catch (DataAccessException e) {
			e.printStackTrace();
			throw new ServiceException(e.getMessage());
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException("数据访问未知异常");
		}
		return listUser;
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
	 * @param advanceDelete
	 *            - 是否删除组织单元的管理角色和组织单元下的用户
	 * @throws ServiceException
	 */
	public void deleteUnit(String unitID, String extTableName, String idColumnName, boolean advanceDelete)
			throws ServiceException {
		try {
			iunitDAO.deleteUnit(unitID, extTableName, idColumnName, advanceDelete);
		} catch (DataAccessException e) {
			e.printStackTrace();
			throw new ServiceException(e.getMessage());
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException("数据访问未知异常");
		}
	}
}
