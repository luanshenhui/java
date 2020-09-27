package cn.com.cgbchina.rest.visit.test.point;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.utils.TestClass;
import cn.com.cgbchina.rest.visit.model.point.PointTypeQuery;
import cn.com.cgbchina.rest.visit.model.point.PointTypeQueryResult;
import cn.com.cgbchina.rest.visit.model.point.QueryPointResult;
import cn.com.cgbchina.rest.visit.model.point.QueryPointsInfo;
import cn.com.cgbchina.rest.visit.service.point.PointService;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
@Service
public class PointServiceImpl implements PointService {
	@Override
	public PointTypeQueryResult queryPointType(PointTypeQuery query) {
		return TestClass.debugMethod(PointTypeQueryResult.class);
	}

	@Override
	public QueryPointResult queryPoint(QueryPointsInfo info) {
		return TestClass.debugMethod(QueryPointResult.class);
	}
}
