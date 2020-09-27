package cn.rkylin.oms.system.privilege.service;

import java.util.Map;

import org.springframework.dao.DataAccessException;

import cn.rkylin.core.exception.BusinessException;

public interface IPrivilegeService {

	Map getElementPrivByMenuIDRoleID(String id, String type, String menuID, String string) throws Exception;

	void savePrivileges(String id, String type, String resIDs4Add, String resIDs4Del, String isAssignableSave) throws Exception;

}
