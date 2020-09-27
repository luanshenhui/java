package com.dhc.organization.facade.impl;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.dao.DataAccessException;

import sun.misc.BASE64Encoder;

import com.dhc.base.core.Service;
import com.dhc.organization.config.BizTypeDefine;
import com.dhc.organization.config.ElementDefine;
import com.dhc.organization.config.OrgnizationConfig;
import com.dhc.organization.facade.IOrganizationFacade;
import com.dhc.organization.facade.UserBean;
import com.dhc.organization.facade.exception.OrgFacadeException;
import com.dhc.organization.unit.domain.WF_ORG_UNIT;
import com.dhc.organization.unit.service.UnitService;
import com.dhc.organization.user.domain.WF_ORG_USER;
import com.dhc.organization.user.service.UserService;

/**
 * brief description
 * <p>
 * Date : 2010/05/13
 * </p>
 * <p>
 * Module : 组织机构权限管理接口
 * </p>
 * <p>
 * Description: 组织接口外观实现
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
 *          修改历史
 *          </p>
 *          <p>
 *          序号 日期 修改人 修改原因
 *          </p>
 *          <p>
 *          1
 *          </p>
 */
public class OrganizationFacadeImpl implements IOrganizationFacade, Service {

	/**
	 * 用户业务对象
	 */
	private UserService userService;
	/**
	 * 组织单元业务对象
	 */
	private UnitService unitService;

	/**
	 * 构造函数
	 */
	public OrganizationFacadeImpl() {

	}

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
	 *            - 帐户（不可为空）
	 * @param password
	 *            - 密码（不可为空）
	 * @param pwdEncrypted
	 *            - 密码是否已经加密
	 * @param needUserUnits
	 *            - 是否需要用户的组织信息
	 * @param needUserStations
	 *            - 是否需要用户的岗位信息
	 * @param needUserRoles
	 *            - 是否需要用户的角色信息
	 * @return 如果用户存在返回UserBean，如果用户不存在返回null
	 * @throws OrgFacadeException
	 */
	public UserBean getUserBean(String account, String password, boolean pwdEncrypted, boolean needUserUnits,
			boolean needUserStations, boolean needUserRoles, boolean needUserExtInfo) throws OrgFacadeException {
		// 帐户和密码不可为空
		if (account == null || account.equals(""))
			throw new OrgFacadeException("参数account不可为空");
		WF_ORG_USER userParam = new WF_ORG_USER();
		userParam.setUserAccount(account);
		return this.getUserBeanByCondition(password, pwdEncrypted, needUserUnits, needUserStations, needUserRoles,
				needUserExtInfo, userParam);
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据帐户获取UserBean，仅用户信息，没有组织、岗位 、角色信息
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
	public UserBean getUserBean(String account) throws OrgFacadeException {
		UserBean userBean = null;
		userBean = getUserBean(account, null, false, true, true, true, true);
		return userBean;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据帐户获取UserBean，仅用户信息，没有组织、岗位 、角色信息
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
	public UserBean getUserBeanById(String id) throws OrgFacadeException {
		UserBean userBean = null;
		userBean = getUserBeanById(id, null, false, true, true, true, true);
		return userBean;
	}

	/**
	 * 创建组织单元
	 * 
	 * @param orgUnit
	 *            不能为空字段：UNIT_ID，PARENT_UNIT_ID, UNIT_NAME
	 * @throws OrgFacadeException
	 */
	public void createOrgUnit(WF_ORG_UNIT orgUnit) throws OrgFacadeException {
		// unitService不可为空
		if (unitService == null)
			throw new OrgFacadeException("OrganizationFacade没有被正确初始化");
		/*
		 * BizTypeDefine bizTypeDefine = OrgnizationConfig
		 * .getBizTypeDefine("unit"); ArrayList list =
		 * bizTypeDefine.getElementList(); String idColumnName = ""; for (int i
		 * = 0; i < list.size(); i++) { ElementDefine ed = (ElementDefine)
		 * list.get(i); if (ed.getName().equalsIgnoreCase("id")) { idColumnName
		 * = ed.getColumn(); break; } }
		 */

		try {
			unitService.saveUnit(orgUnit, "0", null, null);// bizTypeDefine.getTable(),
															// idColumnName);
		} catch (DataAccessException dae) {
			dae.printStackTrace();
			throw new OrgFacadeException("数据库操作错误");
		} catch (Exception e) {
			e.printStackTrace();
			throw new OrgFacadeException("未知错误");
		}
	}

	/**
	 * 更新组织单元
	 * 
	 * @param orgUnit
	 * @throws OrgFacadeException
	 */
	public void updateOrgUnit(WF_ORG_UNIT orgUnit) throws OrgFacadeException {
		// unitService不可为空
		if (unitService == null)
			throw new OrgFacadeException("OrganizationFacade没有被正确初始化");

		try {
			unitService.saveUnit(orgUnit, "1", null, null);
		} catch (DataAccessException dae) {
			dae.printStackTrace();
			throw new OrgFacadeException("数据库操作错误");
		} catch (Exception e) {
			e.printStackTrace();
			throw new OrgFacadeException("未知错误");
		}
	}

	/**
	 * 删除组织单元
	 * 
	 * @param orgUnit
	 * @throws OrgFacadeException
	 */
	public void deleteOrgUnit(WF_ORG_UNIT orgUnit) throws OrgFacadeException {
		// unitService不可为空
		if (unitService == null)
			throw new OrgFacadeException("OrganizationFacade没有被正确初始化");

		BizTypeDefine bizTypeDefine = OrgnizationConfig.getBizTypeDefine("unit");
		ArrayList list = bizTypeDefine.getElementList();
		String idColumnName = "";
		for (int i = 0; i < list.size(); i++) {
			ElementDefine ed = (ElementDefine) list.get(i);
			if (ed.getName().equalsIgnoreCase("id")) {
				idColumnName = ed.getColumn();
				break;
			}
		}

		try {
			unitService.deleteUnit(orgUnit.getUnitId(), bizTypeDefine.getTable(), idColumnName, true);
		} catch (DataAccessException dae) {
			dae.printStackTrace();
			throw new OrgFacadeException("数据库操作错误");
		} catch (Exception e) {
			e.printStackTrace();
			throw new OrgFacadeException("未知错误");
		}

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 把输入的字符串进行md5加密
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param strPassword
	 *            - 未加密的密码
	 * @param strALGORITHM
	 *            - 加密算法
	 * @return 使用md5加密后的密码
	 * @throws Exception
	 */
	private String md5Encrypt(String strPassword, String strALGORITHM) {
		MessageDigest messagedigest = null;
		try {
			messagedigest = MessageDigest.getInstance(strALGORITHM);
		} catch (NoSuchAlgorithmException nosuchalgorithmexception) {
			nosuchalgorithmexception.printStackTrace();
		}
		messagedigest.reset();
		byte abyte0[] = strPassword.getBytes();
		byte abyte1[] = messagedigest.digest(abyte0);
		BASE64Encoder base64encoder = new BASE64Encoder();
		return base64encoder.encode(abyte1);
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}

	public UserService getUserService() {
		return userService;
	}

	public void setUnitService(UnitService unitService) {
		this.unitService = unitService;
	}

	public UnitService getUnitService() {
		return unitService;
	}

	@Override
	public UserBean getUserBeanById(String Id, String password, boolean pwdEncrypted, boolean needUserUnits,
			boolean needUserStations, boolean needUserRoles, boolean needUserExtInfo) throws OrgFacadeException {

		// 帐户和密码不可为空
		if (Id == null || Id.equals(""))
			throw new OrgFacadeException("参数account不可为空");
		WF_ORG_USER userParam = new WF_ORG_USER();
		userParam.setUserId(Id);
		return this.getUserBeanByCondition(password, pwdEncrypted, needUserUnits, needUserStations, needUserRoles,
				needUserExtInfo, userParam);
	}

	private UserBean getUserBeanByCondition(String password, boolean pwdEncrypted, boolean needUserUnits,
			boolean needUserStations, boolean needUserRoles, boolean needUserExtInfo, WF_ORG_USER userParam)
			throws OrgFacadeException {
		// userService不可为空
		if (userService == null)
			throw new OrgFacadeException("OrganizationFacade没有被正确初始化");

		String strPassword = ((password != null && pwdEncrypted) || password == null) ? password
				: md5Encrypt(password, OrgnizationConfig.CRYPTOGRAM_ALGORITHM);
		UserBean userBean = null;
		try {

			userParam.setUserPassword(strPassword);
			List userList = userService.getUserByCondition(userParam, needUserUnits, true, needUserRoles,
					needUserExtInfo);
			if (userList == null || userList.size() <= 0) {
				userBean = null;
			} else {
				// WF_ORG_USER jtUser = userService
				// .getUserDetail(((WF_ORG_USER) (userList.get(0)))
				// .getUserId());
				WF_ORG_USER jtUser = (WF_ORG_USER) userList.get(0);
				if (jtUser != null) {
					userBean = new UserBean();
					userBean.setId(jtUser.getUserId());
					userBean.setAccount(jtUser.getUserAccount());
					userBean.setCreatedDate(jtUser.getUserAccountCreated());
					userBean.setDescription(jtUser.getUserDescription());
					boolean isEnabled = false;
					if (jtUser.getUserAccountEnabled() != null && jtUser.getUserAccountEnabled() != "")
						isEnabled = jtUser.getUserAccountEnabled() == "0" ? false : true;
					userBean.setEnabled(isEnabled);
					userBean.setExtendedInfo(jtUser.getExtInfoMap());
					userBean.setFullName(jtUser.getUserFullname());
					boolean isLocked = true;
					if (jtUser.getUserAccountLocked() != null && jtUser.getUserAccountLocked() != "")
						isLocked = jtUser.getUserAccountLocked().equals("是") ? true : false;
					userBean.setLocked(isLocked);
					userBean.setPassword(jtUser.getUserPassword());
					userBean.setPwdChangeDate(jtUser.getUserPasswordChanged());
					userBean.setRoleList(jtUser.getUserRoleList());
					userBean.setStationList(jtUser.getStationList());
					userBean.setUnitList(jtUser.getUserUnitList());
				}
			}
		} catch (DataAccessException dae) {
			dae.printStackTrace();
			throw new OrgFacadeException("数据库操作错误");
		} catch (Exception e) {
			e.printStackTrace();
			throw new OrgFacadeException("未知错误");
		}
		return userBean;
	}
}