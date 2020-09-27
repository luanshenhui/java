package cn.com.cgbchina.rest.visit.service.point;

import cn.com.cgbchina.rest.visit.model.point.PointTypeQuery;
import cn.com.cgbchina.rest.visit.model.point.PointTypeQueryResult;
import cn.com.cgbchina.rest.visit.model.point.QueryPointResult;
import cn.com.cgbchina.rest.visit.model.point.QueryPointsInfo;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public interface PointService {
	PointTypeQueryResult queryPointType(PointTypeQuery query);

	QueryPointResult queryPoint(QueryPointsInfo info);
}
