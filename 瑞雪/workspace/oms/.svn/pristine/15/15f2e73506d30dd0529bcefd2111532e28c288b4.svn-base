package cn.rkylin.oms.system.position.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import cn.rkylin.core.IDataBaseFactory;
import cn.rkylin.oms.system.position.domain.WF_ORG_STATION;
import cn.rkylin.oms.system.position.domain.WF_ORG_USER_STATION;
@Repository(value = "positionDAO")
public class PositionDAOImpl implements IPositionDAO {
	@Autowired
	protected IDataBaseFactory dao;

	@SuppressWarnings("rawtypes")
	@Override
	public List getStationByCondition(WF_ORG_STATION stationParam) throws Exception {
		return dao.getStationByCondition(stationParam);
	}

	@Override
	public void insert(String stationParam, WF_ORG_USER_STATION uu) throws Exception {
		dao.insert("insertUserStation", uu);
	}

}
