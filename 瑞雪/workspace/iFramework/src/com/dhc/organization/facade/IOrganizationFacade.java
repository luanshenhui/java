package com.dhc.organization.facade;

import com.dhc.organization.facade.exception.OrgFacadeException;
import com.dhc.organization.unit.domain.WF_ORG_UNIT;

/**
 * brief description
 * <p>
 * Date : 2010/05/13
 * </p>
 * <p>
 * Module : 组织机构权限管理接口
 * </p>
 * <p>
 * Description: 组织机构外观
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
public interface IOrganizationFacade {

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据帐户和密码获取UserBean，密码可以是已经加密的，也可以是未加密的。加密使用MD5 算法
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param account
	 *            - 帐户
	 * @param password
	 *            - 密码
	 * @param pwdEncrypted
	 *            - 密码是否已经加密
	 * @param needUserUnits
	 *            - 是否需要用户的组织信息
	 * @param needUserStations
	 *            - 是否需要用户的岗位信息
	 * @param needUserRoles
	 *            - 是否需要用户的角色信息
	 * @return 用户Bean
	 * @throws OrgFacadeException
	 */
	public UserBean getUserBean(String account, String password, boolean pwdEncrypted, boolean needUserUnits,
			boolean needUserStations, boolean needUserRoles, boolean needUserExtInfo) throws OrgFacadeException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据帐户和密码获取UserBean，密码可以是已经加密的，也可以是未加密的。加密使用MD5 算法
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param id
	 *            - 帐户
	 * @param password
	 *            - 密码
	 * @param pwdEncrypted
	 *            - 密码是否已经加密
	 * @param needUserUnits
	 *            - 是否需要用户的组织信息
	 * @param needUserStations
	 *            - 是否需要用户的岗位信息
	 * @param needUserRoles
	 *            - 是否需要用户的角色信息
	 * @return 用户Bean
	 * @throws OrgFacadeException
	 */
	public UserBean getUserBeanById(String Id, String password, boolean pwdEncrypted, boolean needUserUnits,
			boolean needUserStations, boolean needUserRoles, boolean needUserExtInfo) throws OrgFacadeException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据帐户获取UserBean
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param account
	 *            - 帐户
	 * @return 用户Bean
	 * @throws OrgFacadeException
	 */
	public UserBean getUserBean(String account) throws OrgFacadeException;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据帐户获取UserBean
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param account
	 *            - 帐户
	 * @return 用户Bean
	 * @throws OrgFacadeException
	 */
	public UserBean getUserBeanById(String id) throws OrgFacadeException;

	/**
	 * 创建组织单元
	 * 
	 * @param orgUnit
	 * @throws OrgFacadeException
	 */
	public void createOrgUnit(WF_ORG_UNIT orgUnit) throws OrgFacadeException;

	/**
	 * 更新组织单元
	 * 
	 * @param orgUnit
	 * @throws OrgFacadeException
	 */
	public void updateOrgUnit(WF_ORG_UNIT orgUnit) throws OrgFacadeException;

	/**
	 * 删除组织单元
	 * 
	 * @param orgUnit
	 * @throws OrgFacadeException
	 */
	public void deleteOrgUnit(WF_ORG_UNIT orgUnit) throws OrgFacadeException;
}
