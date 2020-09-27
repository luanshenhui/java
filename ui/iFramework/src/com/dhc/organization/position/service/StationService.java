package com.dhc.organization.position.service;

import java.util.List;

import com.dhc.base.core.Service;
import com.dhc.base.exception.DataAccessException;
import com.dhc.base.exception.ServiceException;
import com.dhc.organization.position.dao.IPositionDAO;
import com.dhc.organization.position.domain.WF_ORG_STATION;
import com.dhc.organization.user.dao.IUserDAO;
import com.dhc.organization.user.domain.WF_ORG_USER;

/**
 * brief description
 * <p>
 * Date : 2010/05/06
 * </p>
 * <p>
 * Module : 岗位管理
 * </p>
 * <p>
 * Description: 岗位管理业务对象
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
public class StationService implements Service {
	private IPositionDAO ipositionDAO;

	private IUserDAO iuserDAO;

	public IUserDAO getIuserDAO() {
		return iuserDAO;
	}

	public void setIuserDAO(IUserDAO iuserDAO) {
		this.iuserDAO = iuserDAO;
	}

	public StationService() {

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
	 * @param unitID
	 *            - 组织单元id
	 * @return 如果找到，返回WF_ORG_STATION 如果没有找到，返回null
	 * @throws ServiceException
	 */
	public List getPositionInUnit(String unitID) {
		WF_ORG_STATION positionVO = new WF_ORG_STATION();
		List list = null;
		positionVO.setUnitId(unitID);
		try {
			list = ipositionDAO.getStationByCondition(positionVO);
		} catch (DataAccessException ex) {
			ex.printStackTrace();
			// throw new ServiceException(OrgI18nConsts.EXCEPTION_DBACCESS);
		} catch (Exception ex) {
			ex.printStackTrace();
			// throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}
		return list;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 保存岗位，包括（岗位基本信息、人员信息）
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param stationVO
	 *            - 含有人员列表的岗位vo
	 * @param saveType
	 *            - 保存类型，0：新增保存，1：修改保存
	 * @return 保存后的WF_ORG_STATION
	 * @throws ServiceException
	 */
	public WF_ORG_STATION saveStation(WF_ORG_STATION stationVO, String saveType) throws ServiceException {

		try {
			// 检测角色的用户数限制
			if (stationVO.getUserNumbers() >= 0 && stationVO.getStationUser() != null) {
				if (stationVO.getStationUser().size() > stationVO.getUserNumbers()) {
					throw new DataAccessException("岗位的用户数超过上限");
				}
			}
			if (saveType.equals("0")) {
				ipositionDAO.createStation(stationVO);
			} else if (saveType.equals("1")) {
				// 如果有人数限制，则先检查角色的人数限制
				// WF_ORG_USER userVO = new WF_ORG_USER();
				// userVO.setStationId(stationVO.getStationId());
				// if (!stationVO.getUserNumbers().toString().equals("-1")){
				// int roleCount = iuserDAO.getUserCount(userVO);
				// if (roleCount > stationVO.getUserNumbers())
				// throw new DataAccessException("岗位的用户数超过上限");
				// }
				ipositionDAO.updateStation(stationVO);
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
	 * 描述: 删除岗位。如果组织单元下面有人员或被组织单元使用，则该岗位不能删除
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param stationID
	 *            - 岗位id
	 * @throws ServiceException
	 */
	public void deleteStation(WF_ORG_STATION stationVO) throws ServiceException {
		try {
			ipositionDAO.deleteStation(stationVO);
		} catch (DataAccessException e) {
			e.printStackTrace();
			throw new ServiceException(e.getMessage());
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException("数据访问未知异常");
		}

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据StationID获取岗位的明细信息 注意：WF_ORG_STATION包含基本信息和人员信息
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param stationID
	 *            - 岗位id
	 * @return 如果找到，返回WF_ORG_STATION 如果没有找到，返回null
	 * @throws ServiceException
	 */
	public List getStationDetail(String stationID) throws ServiceException {
		List stationList = null;
		WF_ORG_STATION staVO = new WF_ORG_STATION();
		staVO.setStationId(stationID);
		try {
			stationList = ipositionDAO.getStationWithUsers(staVO);
			WF_ORG_STATION staDetail = (WF_ORG_STATION) stationList.get(0);
			WF_ORG_USER user = new WF_ORG_USER();
			user.setStationId(staDetail.getStationId());
			List userStationList = iuserDAO.getUserByCondition(user);
			staDetail.setStationUser(userStationList);
		} catch (DataAccessException e) {
			e.printStackTrace();
			throw new ServiceException(e.getMessage());
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException("数据访问未知异常");
		}
		return stationList;
	}

	public void setIpositionDAO(IPositionDAO ipositionDAO) throws ServiceException {
		this.ipositionDAO = ipositionDAO;
	}

	public IPositionDAO getIpositionDAO() throws ServiceException {
		return ipositionDAO;
	}
}
