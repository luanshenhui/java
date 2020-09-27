package cn.com.cgbchina.item.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by 133625 on 16-5-5.
 */
public class itemSearchDto implements Serializable {

	private static final long serialVersionUID = 3909919894964713315L;
	/**
	 * 每页显示数量
	 */
	@Setter
	@Getter
	private int pageSize = 20;

	/**
	 * 当前页
	 */
	@Setter
	@Getter
	private int currentPageNo = 1;

	/**
	 * 总记录数
	 */
	@Setter
	@Getter
	private int totalRecord;

	/**
	 * 总页数
	 */
	@Setter
	@Getter
	private int pageCount;

	/**
	 * 商品信息
	 */
	@Setter
	@Getter
	private List<ItemSearchResultDto> itemSearchResultList;
	@Setter
	@Getter
	private List<ItemFilterDto> categoryList;
	@Setter
	@Getter
	private List<ItemFilterDto> saleAttrList;
	@Setter
	@Getter
	private List<ItemFilterDto> brandList;

}
