package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.item.model.ProductModel;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

/**
 * Created by Tanliang on 16-4-22.
 */
public class ProductDto extends ProductModel {

	private static final long serialVersionUID = -2093645220906964524L;
	private GoodsBrandModel goodsBrandModel;// 品牌model

	private String brandName;// 品牌名称

	private String backCategory1Name; // 后台类目1名称

	private String backCategory2Name; // 后台类目2名称

	private String backCategory3Name; // 后台类目3名称

	private ItemsAttributeDto itemsAttributeDto;

	@Getter
	@Setter
	private String categoryList; // 后台类目List

	@Getter
	@Setter
	private Long backCategory1Id; // 后台类目1ID
	@Getter
	@Setter
	private Long backCategory2Id; // 后台类目2ID
	@Getter
	@Setter
	private Long backCategory3Id; // 后台类目3ID

	public String getBackCategory3Name() {
		return backCategory3Name;
	}

	public void setBackCategory3Name(String backCategory3Name) {
		this.backCategory3Name = backCategory3Name;
	}

	public String getBackCategory2Name() {

		return backCategory2Name;
	}

	public void setBackCategory2Name(String backCategory2Name) {
		this.backCategory2Name = backCategory2Name;
	}

	public String getBackCategory1Name() {

		return backCategory1Name;
	}

	public void setBackCategory1Name(String backCategory1Name) {
		this.backCategory1Name = backCategory1Name;
	}

	public String getBrandName() {
		return brandName;
	}

	public void setBrandName(String brandName) {
		this.brandName = brandName;
	}

	public GoodsBrandModel getGoodsBrandModel() {
		return goodsBrandModel;
	}

	public void setGoodsBrandModel(GoodsBrandModel goodsBrandModel) {
		this.goodsBrandModel = goodsBrandModel;
	}

	public ItemsAttributeDto getItemsAttributeDto() {
		return itemsAttributeDto;
	}

	public void setItemsAttributeDto(ItemsAttributeDto itemsAttributeDto) {
		this.itemsAttributeDto = itemsAttributeDto;
	}
}
