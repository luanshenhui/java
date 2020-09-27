package cn.rkylin.apollo.notice.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.rkylin.apollo.notice.dao.INoticeStrategyDao;
import cn.rkylin.apollo.notice.service.INoticeStrategyService;
import cn.rkylin.core.ApolloMap;


@Service("noticeStrategyService")
public class NoticeStrategyServiceImpl implements INoticeStrategyService {
	@Autowired
	private INoticeStrategyDao noticeStrategyDao;

	@Override
	public List<Map<String, Object>> findByWhere(ApolloMap<String, Object> params) throws Exception {
		return noticeStrategyDao.findByWhere(params);
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
