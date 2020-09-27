package cn.com.cgbchina.rest.provider.vo.goods;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.common.annotation.XMLNodeName;
import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL102 CC积分商城单个礼品详细信息
 * @author  Lizy
 *
 */
public class CCIntergalPresentDetailVO implements Serializable  {
    private static final long serialVersionUID = 6078199982681852483L;
    @NotNull
	private String returnCode;
    @XMLNodeName("ReturnDes")
    private String returnDes;
	public String getReturnCode() {
		return returnCode;
	}
	public void setReturnCode(String returnCode) {
		this.returnCode = returnCode;
	}
	public String getReturnDes() {
		return returnDes;
	}
	public void setReturnDes(String returnDes) {
		this.returnDes = returnDes;
	}
    @NotNull
    private String channelSN ;
    @NotNull
    private String successCode;
    @NotNull
    private String goodsName ;
    @NotNull
    private String vendorName;
    private String goodsColor;
    private String goodsModel;
    private String goodsMsg;
    private String goodsGuarantee;
    private String goodsPresent;
    private String goodsPresentDesc;
    private String goodsDesc;
    @NotNull
    private String goodsDetailDesc;

    public String getChannelSN() {
        return channelSN;
    }

    public void setChannelSN(String channelSN) {
        this.channelSN = channelSN;
    }

    public String getSuccessCode() {
        return successCode;
    }

    public void setSuccessCode(String successCode) {
        this.successCode = successCode;
    }

    public String getGoodsName() {
        return goodsName;
    }

    public void setGoodsName(String goodsName) {
        this.goodsName = goodsName;
    }

    public String getVendorName() {
        return vendorName;
    }

    public void setVendorName(String vendorName) {
        this.vendorName = vendorName;
    }

    public String getGoodsColor() {
        return goodsColor;
    }

    public void setGoodsColor(String goodsColor) {
        this.goodsColor = goodsColor;
    }

    public String getGoodsModel() {
        return goodsModel;
    }

    public void setGoodsModel(String goodsModel) {
        this.goodsModel = goodsModel;
    }

    public String getGoodsMsg() {
        return goodsMsg;
    }

    public void setGoodsMsg(String goodsMsg) {
        this.goodsMsg = goodsMsg;
    }

    public String getGoodsGuarantee() {
        return goodsGuarantee;
    }

    public void setGoodsGuarantee(String goodsGuarantee) {
        this.goodsGuarantee = goodsGuarantee;
    }

    public String getGoodsPresent() {
        return goodsPresent;
    }

    public void setGoodsPresent(String goodsPresent) {
        this.goodsPresent = goodsPresent;
    }

    public String getGoodsPresentDesc() {
        return goodsPresentDesc;
    }

    public void setGoodsPresentDesc(String goodsPresentDesc) {
        this.goodsPresentDesc = goodsPresentDesc;
    }

    public String getGoodsDesc() {
        return goodsDesc;
    }

    public void setGoodsDesc(String goodsDesc) {
        this.goodsDesc = goodsDesc;
    }

    public String getGoodsDetailDesc() {
        return goodsDetailDesc;
    }

    public void setGoodsDetailDesc(String goodsDetailDesc) {
        this.goodsDetailDesc = goodsDetailDesc;
    }
}
