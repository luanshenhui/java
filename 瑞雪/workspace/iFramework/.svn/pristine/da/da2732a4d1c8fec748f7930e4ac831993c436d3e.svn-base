package com.dhc.authorization.delegate.service;

import java.util.ArrayList;
import java.util.List;

import com.dhc.authorization.delegate.dao.IDelegateDAO;
import com.dhc.authorization.delegate.domain.WF_ORG_DELEGATE;
import com.dhc.authorization.delegate.domain.WF_ORG_DELEITEM;
import com.dhc.base.core.Service;
import com.dhc.base.exception.DataAccessException;
import com.dhc.base.exception.ServiceException;
import com.dhc.organization.config.OrgI18nConsts;

/**
 * brief description
 * <p>
 * Date : 2010/07/09
 * </p>
 * <p>
 * Module : 权限委托管理
 * </p>
 * <p>
 * Description: 权限委托业务对象
 * </p>
 * <p>
 * Remark :
 * </p>
 * 
 * @author 王潇艺
 * @version
 *          <p>
 *          ------------------------------------------------------------
 *          </p>
 *          <p>
 * 			修改历史
 *          </p>
 *          <p>
 * 			序号 日期 修改人 修改原因
 *          </p>
 *          <p>
 * 			1
 *          </p>
 */
public class DelegateService implements Service {
	private IDelegateDAO idelegateDAO;

	public IDelegateDAO getIdelegateDAO() {
		return idelegateDAO;
	}

	public void setIdelegateDAO(IDelegateDAO idelegateDAO) {
		this.idelegateDAO = idelegateDAO;
	}

	/**
	 * 构造函数
	 */
	public DelegateService() {

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据条件获取权限委托
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param delegateVO
	 *            - 查询条件vo
	 * @return 如果找到，返回List<WF_ORG_DELEGATE> 如果没有找到，返回null
	 * @throws ServiceException
	 */
	public List getDelegateByCondition(WF_ORG_DELEGATE delegateVO) throws ServiceException {
		List resultList = new ArrayList();
		try {
			resultList = idelegateDAO.getDelegateByCondition(delegateVO);
		} catch (DataAccessException e) {
			throw new ServiceException(e.getMessage());
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}

		return resultList;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 保存权限委托
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param delegateVO
	 *            - 权限委托vo
	 * @param saveType
	 *            - 保存类型，0：新增保存，1：修改保存
	 * @return 保存后的WF_ORG_DELEGATE
	 * @throws ServiceException
	 */
	public WF_ORG_DELEGATE saveDelegate(WF_ORG_DELEGATE delegateVO, String saveType) throws ServiceException {
		try {
			// 如果是新增保存
			if (saveType.equals("0")) {
				idelegateDAO.createDelegate(delegateVO);
			} else {
				idelegateDAO.updateDelegate(delegateVO);
			}
		} catch (DataAccessException e) {
			throw new ServiceException("委托名称不能重复");
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}
		return null;
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
	 * @param delegateID
	 *            - 委托id
	 * @throws ServiceException
	 */
	public void deleteDelegate(List delegateID) throws ServiceException {
		try {
			idelegateDAO.deleteDelegate(delegateID);
		} catch (DataAccessException e) {
			throw new ServiceException(e.getMessage());
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据条件获取权限委托明细
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param delegateID
	 *            - 委托ID
	 * @return 如果找到，返回WF_ORG_DELEGATE 如果没有找到，返回null
	 * @throws ServiceException
	 */
	public WF_ORG_DELEGATE getDelegateDetail(String delegateID) throws ServiceException {
		WF_ORG_DELEGATE delegate = new WF_ORG_DELEGATE();
		WF_ORG_DELEGATE param = new WF_ORG_DELEGATE();
		WF_ORG_DELEITEM deleitem = new WF_ORG_DELEITEM();
		try {
			List delegateList = idelegateDAO.getDelegateDetail(delegateID);
			List deleitemList = idelegateDAO.getDeleitemDetail(delegateID);
			if (delegateList != null || delegateList.size() > 0) {
				param = (WF_ORG_DELEGATE) delegateList.get(0);
				delegate.setDeleId(param.getDeleId());
				delegate.setUserId(param.getUserId());
				delegate.setTrustorId(param.getTrustorId());
				delegate.setTrustor_name(param.getTrustor_name());
				delegate.setDeleName(param.getDeleName());
				delegate.setDeleDescription(param.getDeleDescription());
				delegate.setDeleTimeBegin(param.getDeleTimeBegin());
				delegate.setDeleTimeEnd(param.getDeleTimeEnd());
				delegate.setDeleAllPrivil(param.getDeleAllPrivil());

				for (int i = 0; i < deleitemList.size(); i++) {
					deleitem = (WF_ORG_DELEITEM) deleitemList.get(i);
					if (deleitem.getDiPrivType().equals("ROLE")) {
						if (delegate.getRoleItemList() == null)
							delegate.setRoleItemList(new ArrayList());
						delegate.getRoleItemList().add(deleitem.getDiPrivId());
					} else if (deleitem.getDiPrivType().equals("STATION")) {
						if (delegate.getStationItemList() == null)
							delegate.setStationItemList(new ArrayList());
						delegate.getStationItemList().add(deleitem.getDiPrivId());
					} else if (deleitem.getDiPrivType().equals("ORG")) {
						if (delegate.getUnitItemList() == null)
							delegate.setUnitItemList(new ArrayList());
						delegate.getUnitItemList().add(deleitem.getDiPrivId());
					}
				}
			}

		} catch (DataAccessException e) {
			throw new ServiceException(e.getMessage());
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}

		return delegate;
	}

	public int getDelegateCount(WF_ORG_DELEGATE delegateVO) throws ServiceException {
		int delegateCount = 0;
		try {
			delegateCount = idelegateDAO.getDelegateCount(delegateVO);
		} catch (DataAccessException e) {
			throw new ServiceException(e.getMessage());
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}
		return delegateCount;
	}

	public int checkDelegate(WF_ORG_DELEGATE delegateVO) throws ServiceException {
		int rowCount = 0;
		try {
			rowCount = idelegateDAO.getDelegateCount(delegateVO);
		} catch (DataAccessException e) {
			throw new ServiceException(e.getMessage());
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ServiceException(OrgI18nConsts.EXCEPTION_UNKNOWN);
		}
		return rowCount;
	}
}
