package cn.com.cgbchina.user.dto;

import cn.com.cgbchina.user.model.VendorMenuModel;
import com.google.common.collect.Lists;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by 郝文佳 on 2016/5/20.
 */
public class VendorMenuNode implements Serializable {

	private static final long serialVersionUID = 1200366375408932136L;
	@Setter
	@Getter
	private VendorMenuModel menu;
	@Setter
	@Getter
	private List<VendorMenuNode> children = Lists.newArrayList();

	public VendorMenuNode(VendorMenuModel vendorMenuModel) {
		this.menu = vendorMenuModel;
	}

	public void addChild(VendorMenuNode child) {
		this.children.add(child);
	}

}
