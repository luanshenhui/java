package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.user.model.MemberBrowseHistoryModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by 张成 on 16-4-28.
 */
public class BrowseHistoryInfoDateDto implements Serializable {

	private static final long serialVersionUID = 7999227826143662653L;

	@Getter
	@Setter
	private String browseDate;

	@Getter
	@Setter
	private List<BrowseHistoryInfoDto> browseHistoryInfoDto;
}
