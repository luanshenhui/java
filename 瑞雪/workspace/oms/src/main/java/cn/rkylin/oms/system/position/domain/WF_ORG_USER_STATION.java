
package cn.rkylin.oms.system.position.domain;

import cn.rkylin.oms.common.base.BaseEntity;

@SuppressWarnings("serial")
public class WF_ORG_USER_STATION extends BaseEntity {
	private String userId;
	private String stationId;

	public WF_ORG_USER_STATION() {

	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserId() {
		return userId;
	}

	public void setStationId(String stationId) {
		this.stationId = stationId;
	}

	public String getStationId() {
		return stationId;
	}
}
