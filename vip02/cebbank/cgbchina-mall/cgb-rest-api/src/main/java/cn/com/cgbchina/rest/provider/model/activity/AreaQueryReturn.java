package cn.com.cgbchina.rest.provider.model.activity;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL326 分区查询接口
 * 
 * @author lizy 2016/4/28.
 */
public class AreaQueryReturn extends BaseEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 7493151002455081784L;
	private List<AreaInfo> areaInfos = new ArrayList<AreaInfo>();

	public List<AreaInfo> getAreaInfos() {
		return areaInfos;
	}

	public void setAreaInfos(List<AreaInfo> areaInfos) {
		this.areaInfos = areaInfos;
	}

}
