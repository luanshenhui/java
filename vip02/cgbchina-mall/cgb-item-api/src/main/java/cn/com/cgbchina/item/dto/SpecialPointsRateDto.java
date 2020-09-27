package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.SpecialPointScaleModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.model.VendorModel;
import com.spirit.category.dto.RichCategory;
import com.spirit.category.model.BackCategory;

import java.io.Serializable;
import java.util.List;

/**
 * Created by yuxinxin on 16-6-1.
 */
public class SpecialPointsRateDto implements Serializable{

	private static final long serialVersionUID = -48140644089238298L;
	private List<GoodsBrandModel> goodsBrandModelList;// 品牌model

	public List<GoodsBrandModel> getGoodsBrandModelList() {
		return goodsBrandModelList;
	}

	public void setGoodsBrandModelList(List<GoodsBrandModel> goodsBrandModelList) {
		this.goodsBrandModelList = goodsBrandModelList;
	}

	private List<VendorInfoModel> vendorInfoModelList;// 供应商model

	public List<VendorInfoModel> getVendorInfoModelList() {
		return vendorInfoModelList;
	}

	public void setVendorInfoModelList(List<VendorInfoModel> vendorInfoModelList) {
		this.vendorInfoModelList = vendorInfoModelList;
	}

	private List<GoodsModel> goodsModelList;// 商品model

	public List<GoodsModel> getGoodsModelList() {
		return goodsModelList;
	}

	public void setGoodsModelList(List<GoodsModel> goodsModelList) {
		this.goodsModelList = goodsModelList;
	}

	private List<RichCategory> backCategoryList;

	public List<RichCategory> getBackCategoryList() {
		return backCategoryList;
	}

	public void setBackCategoryList(List<RichCategory> backCategoryList) {
		this.backCategoryList = backCategoryList;
	}

	private List<SpecialPointScaleModel> specialPointScaleModelList;

	public List<SpecialPointScaleModel> getSpecialPointScaleModelList() {
		return specialPointScaleModelList;
	}

	public void setSpecialPointScaleModelList(List<SpecialPointScaleModel> specialPointScaleModelList) {
		this.specialPointScaleModelList = specialPointScaleModelList;
	}
}
