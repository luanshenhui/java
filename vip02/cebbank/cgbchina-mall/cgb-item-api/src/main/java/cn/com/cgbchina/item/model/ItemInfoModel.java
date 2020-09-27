package cn.com.cgbchina.item.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class ItemInfoModel implements Serializable {


	private static final long serialVersionUID = -7916109347616818782L;
	@Getter
	@Setter
	private String name;// 名称
	@Getter
	@Setter
	private ItemModel itemModel;
}