package cn.rkylin.oms.system.unit.service;

import java.util.List;
import java.util.Map;

import cn.rkylin.oms.system.unit.domain.WF_ORG_UNIT;

public interface IUnitService {

	List getRootUnit(String userId) throws Exception;

	List getSubUnit(String userId, String itemId, boolean needStation, boolean b) throws Exception;

	void saveUnit(WF_ORG_UNIT unitVO, String saveType,String extTableName, String idColName) throws Exception;

	WF_ORG_UNIT getUnitDetail(String unitID);

	void deleteUnit(String unitID, String extTableName, String idColumnName, boolean b) throws Exception;

	List getUnitType(String type) throws Exception;

	List getUserDetail(String unitID) throws Exception;

    List getEntName();

}
