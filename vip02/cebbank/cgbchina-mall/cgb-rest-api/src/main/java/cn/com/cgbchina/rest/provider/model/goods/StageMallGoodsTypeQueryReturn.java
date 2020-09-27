package cn.com.cgbchina.rest.provider.model.goods;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL311 商品类别查询(分期商城) 的返回对象
 * 
 * @author lizy 2016/4/29.
 */
public class StageMallGoodsTypeQueryReturn extends BaseEntity implements Serializable {

	private static final long serialVersionUID = -7468839008928163701L;
	List<StageMallGoodsType> infos = new ArrayList<StageMallGoodsType>();

	public List<StageMallGoodsType> getInfos() {
		return infos;
	}

	public void setInfos(List<StageMallGoodsType> infos) {
		this.infos = infos;
	}

}
