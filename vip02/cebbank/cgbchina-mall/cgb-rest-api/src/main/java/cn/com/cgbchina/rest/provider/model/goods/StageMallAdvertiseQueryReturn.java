package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL321 广告查询(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class StageMallAdvertiseQueryReturn extends BaseEntity implements Serializable {

	private static final long serialVersionUID = -240361672959383935L;

	private List<StageMallAdvertiseInfo> ads = new ArrayList<StageMallAdvertiseInfo>();

	public List<StageMallAdvertiseInfo> getAds() {
		return ads;
	}

	public void setAds(List<StageMallAdvertiseInfo> ads) {
		this.ads = ads;
	}

}
