package cn.rkylin.apollo.notice.service.impl;

import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.rkylin.apollo.notice.dao.INoticeConfigureDao;
import cn.rkylin.apollo.notice.service.INoticeConfigureService;
import cn.rkylin.core.ApolloMap;

@Service("noticeConfigureService")
public class NoticeConfigureServiceImpl implements INoticeConfigureService {
	private static final Log log = LogFactory.getLog(NoticeConfigureServiceImpl.class);

	@Autowired
	private INoticeConfigureDao noticeConfigureDao;

	@Override
	public List<Map<String, Object>> findByWhere(ApolloMap<String, Object> params) throws Exception {
		return noticeConfigureDao.findByWhere(params);
	}

	@Override
	public List<Map<String, Object>> findWaitManageByWhere(ApolloMap<String, Object> params) throws Exception {
		return noticeConfigureDao.findWaitManageByWhere(params);
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
