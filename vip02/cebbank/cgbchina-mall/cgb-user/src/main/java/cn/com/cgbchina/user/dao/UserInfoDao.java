package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.model.UserInfoModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class UserInfoDao extends SqlSessionDaoSupport {

	public Boolean update(UserInfoModel userInfo) {
		return getSqlSession().update("UserInfo.update", userInfo) == 1;
	}

	public Integer insert(UserInfoModel userInfo) {
		return getSqlSession().insert("UserInfo.insert", userInfo);
	}

	public List<UserInfoModel> findAll() {
		return getSqlSession().selectList("UserInfo.findAll");
	}

	public UserInfoModel findById(String id) {
		return getSqlSession().selectOne("UserInfo.findById", id);
	}

	public UserInfoModel findByName(String userName) {
		return getSqlSession().selectOne("UserInfo.findByName", userName);
	}

    public UserInfoModel  findByNameFlag(String userName) {
        return getSqlSession().selectOne("UserInfo.findByNameFlag", userName);
    }
    public UserInfoModel  findByNameId(String id) {
        return getSqlSession().selectOne("UserInfo.findByNameId", id);
    }
//	add by liuhan
	public List<UserInfoModel>  findUserInfoByOrgCode(String orgCode) {
		return getSqlSession().selectList("UserInfo.findUserInfoByOrgCode", orgCode);
	}


	/**
	 * 登录帐号
	 * 
	 * @param loginAccount
	 * @return
	 */
	public UserInfoModel findByUserId(String loginAccount) {
		return getSqlSession().selectOne("UserInfo.findByUserId", loginAccount);
	}

	public Pager<UserInfoModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("UserInfo.count", params);
		if (total == 0) {
			return Pager.empty(UserInfoModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<UserInfoModel> data = getSqlSession().selectList("UserInfo.pager", paramMap);
		return new Pager<UserInfoModel>(total, data);
	}

	public Integer delete(UserInfoModel userInfo) {
		return getSqlSession().delete("UserInfo.delete", userInfo);
	}

	/**
	 * 登录成功后 跟新密码
	 * 
	 * @param userInfo
	 * @return
	 */
	public Integer updatePwdByCode(UserInfoModel userInfo) {
		return getSqlSession().update("UserInfo.updatePwdByCode", userInfo);
	}

}