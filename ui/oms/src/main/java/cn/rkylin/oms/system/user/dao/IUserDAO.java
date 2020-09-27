package cn.rkylin.oms.system.user.dao;

import java.util.List;
import java.util.Map;

import cn.rkylin.oms.system.user.domain.WF_ORG_USER;
import cn.rkylin.oms.system.user.vo.UserVO;

public interface IUserDAO {

	List<UserVO> getUserByCondition(UserVO userVo) throws Exception;

	Map getExtInfo(String string, String userId) throws Exception;

	void createUser(WF_ORG_USER userVO, String extTableName, String idColumnName) throws Exception;

	void updateUser(WF_ORG_USER userVO, String extTableName, String idColumnName) throws Exception;

	void lockUser(String userID, String isLocked) throws Exception;

	void deleteUser(String string, String extTableName, String idColumnName) throws Exception;

	List getUserByCondition(WF_ORG_USER userVO) throws Exception;

	List getUserByUnitID(String unitID) throws Exception;

}
