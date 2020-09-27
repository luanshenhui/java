package cn.rkylin.apollo.notice.dao.impl;

import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import cn.rkylin.apollo.notice.dao.INoticeConfigureDao;
import cn.rkylin.core.ApolloMap;
import cn.rkylin.core.IDataBaseFactory;

@Repository(value = "noticeConfigureDao")
public class NoticeConfigureDaoImpl implements INoticeConfigureDao {
	private static final Log log = LogFactory.getLog(NoticeConfigureDaoImpl.class);

	@Autowired
	private IDataBaseFactory dao;

	@Override
	public List<Map<String, Object>> findByWhere(ApolloMap<String, Object> params) throws Exception {
		return dao.findForList("findNoticeConfigureByWhere", params);
	}

	@Override
	public List<Map<String, Object>> findWaitManageByWhere(ApolloMap<String, Object> params) throws Exception {
		return dao.findForList("findWaitManageByWhere", params);
	}

	@Override
	public int update(ApolloMap<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int insert(ApolloMap<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int delete(ApolloMap<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}

}
