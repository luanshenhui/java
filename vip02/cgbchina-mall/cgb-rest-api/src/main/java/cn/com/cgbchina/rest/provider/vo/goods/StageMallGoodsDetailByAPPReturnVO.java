package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsDetailByAPP;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL313 商品详细信息(分期商城)
 * 
 * @author lizy 2016/4/28.
 */

public class StageMallGoodsDetailByAPPReturnVO extends BaseEntityVO implements Serializable {
	private String successCode;

	public String getSuccessCode() {
		return successCode;
	}

	public void setSuccessCode(String successCode) {
		this.successCode = successCode;
	}

	/**
	 * 
	 */
	private static final long serialVersionUID = 1963205003105295400L;
	List<StageMallGoodsDetailByAPPVO> infos = new ArrayList<StageMallGoodsDetailByAPPVO>();

	public List<StageMallGoodsDetailByAPPVO> getInfos() {
		return infos;
	}

	public void setInfos(List<StageMallGoodsDetailByAPPVO> infos) {
		this.infos = infos;
	}

}
