package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL311 商品类别查询(分期商城) 的返回对象
 * 
 * @author lizy 2016/4/29.
 */
public class StageMallGoodsTypeQueryReturnVO extends BaseEntityVO implements Serializable {

	private static final long serialVersionUID = -7468839008928163701L;
	List<StageMallGoodsTypeVO> infos = new ArrayList<StageMallGoodsTypeVO>();

	public List<StageMallGoodsTypeVO> getInfos() {
		return infos;
	}

	public void setInfos(List<StageMallGoodsTypeVO> infos) {
		this.infos = infos;
	}

}
