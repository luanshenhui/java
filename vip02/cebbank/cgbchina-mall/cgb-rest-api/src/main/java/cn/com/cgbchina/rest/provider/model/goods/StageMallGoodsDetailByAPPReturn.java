package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL313 商品详细信息(分期商城)
 * 
 * @author lizy 2016/4/28.
 */

public class StageMallGoodsDetailByAPPReturn extends BaseEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4661038651591217406L;
	List<StageMallGoodsDetailByAPP> infos = new ArrayList<StageMallGoodsDetailByAPP>();

	public List<StageMallGoodsDetailByAPP> getInfos() {
		return infos;
	}

	public void setInfos(List<StageMallGoodsDetailByAPP> infos) {
		this.infos = infos;
	}

}
