package cn.rkylin.apollo.notice.dao.impl;

import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import cn.rkylin.apollo.notice.dao.INoticeStrategyDao;
import cn.rkylin.core.ApolloMap;
import cn.rkylin.core.IDataBaseFactory;

@Repository(value = "noticeStrategyDao")
public class NoticeStrategyDaoImpl implements INoticeStrategyDao {
	private static final Log log = LogFactory.getLog(NoticeConfigureDaoImpl.class);

	@Autowired
	private IDataBaseFactory dao;
	
	@Override
	public List<Map<String, Object>> findByWhere(ApolloMap<String, Object> params) throws Exception {
		return dao.findForList("findNoticeStrategyByWhere", params);
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
