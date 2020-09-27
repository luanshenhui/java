package cn.com.cgbchina.user.dto;

import cn.com.cgbchina.user.model.MenuMagModel;
import com.google.common.collect.Lists;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by 郝文佳 on 2016/5/19.
 */
public class MenuNodeDto implements Serializable {
	private static final long serialVersionUID = -5088640690104986574L;
	@Setter
	@Getter
	private MenuMagModel menu;
	@Setter
	@Getter
	private List<MenuNodeDto> children = Lists.newArrayList();

	public MenuNodeDto(MenuMagModel menuManagerModel) {
		this.menu = menuManagerModel;
	}

	public void addChild(MenuNodeDto child) {
		this.children.add(child);
	}
}
