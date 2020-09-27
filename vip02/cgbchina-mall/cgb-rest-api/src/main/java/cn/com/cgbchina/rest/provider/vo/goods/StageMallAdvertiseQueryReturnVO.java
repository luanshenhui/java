package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL321 广告查询(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class StageMallAdvertiseQueryReturnVO extends BaseEntityVO implements Serializable {

	private static final long serialVersionUID = -240361672959383935L;

	private List<StageMallAdvertiseInfoVO> ads = new ArrayList<StageMallAdvertiseInfoVO>();

	public List<StageMallAdvertiseInfoVO> getAds() {
		return ads;
	}

	public void setAds(List<StageMallAdvertiseInfoVO> ads) {
		this.ads = ads;
	}

}
