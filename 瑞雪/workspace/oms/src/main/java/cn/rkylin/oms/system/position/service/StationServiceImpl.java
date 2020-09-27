package cn.rkylin.oms.system.position.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.rkylin.core.service.ApolloService;
import cn.rkylin.oms.system.position.dao.IPositionDAO;
import cn.rkylin.oms.system.position.domain.WF_ORG_STATION;

@Service("stationService")
public class StationServiceImpl extends ApolloService implements IStationService {
	@Autowired
	private IPositionDAO positionDAO;
	@SuppressWarnings("rawtypes")
	@Override
	public List getPositionInUnit(String unitID) {
		WF_ORG_STATION positionVO = new WF_ORG_STATION();
		List list = null;
		positionVO.setUnitId(unitID);
		try {
			list = positionDAO.getStationByCondition(positionVO);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return list;
	
	}

}
