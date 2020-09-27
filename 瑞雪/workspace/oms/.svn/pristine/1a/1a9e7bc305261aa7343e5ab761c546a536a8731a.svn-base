package cn.rkylin.oms.system.unit.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import cn.rkylin.oms.system.unit.domain.WF_ORG_UNIT;
import cn.rkylin.oms.system.unit.vo.UnitVO;

public interface IUnitDAO {

	List getUnitByCondition(WF_ORG_UNIT unitParam) throws Exception;

//	Map getExtInfo(String string, String unitId);

	List getRootUnit(String userId) throws Exception;

	List getSubUnit(String userId, String parentUnitID) throws Exception;

	void createUnit(WF_ORG_UNIT unitVO, String extTableName, String idColName) throws Exception;

	void updateUnit(WF_ORG_UNIT unitVO, String extTableName, String idColName) throws Exception;

	void deleteUnit(String unitID, String extTableName, String idColumnName, boolean advanceDelete) throws Exception;

	ArrayList getUnitType(String type) throws Exception;

    List getEntName() throws Exception;




}
