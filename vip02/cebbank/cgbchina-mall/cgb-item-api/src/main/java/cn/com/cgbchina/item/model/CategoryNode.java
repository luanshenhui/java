package cn.com.cgbchina.item.model;

import com.google.common.base.Objects;
import com.google.common.collect.Lists;

import java.io.Serializable;
import java.util.List;

/**
 * 类目节点 Created by shixing on 16-4-26.
 */
public class CategoryNode<T extends BaseCategory> implements Serializable {

	private static final long serialVersionUID = 8127253713869763950L;
	private T category;
	private List<CategoryNode<T>> children = Lists.newArrayList();
	private final Integer level;

	public CategoryNode(T category, Integer level) {
		this.category = category;
		this.level = level;
	}

	public T getCategory() {
		return category;
	}

	public boolean addChild(CategoryNode<T> categoryNode) {
		// TODO 不明白这种设计方式
		// this.children.remove(categoryNode);
		return this.children.add(categoryNode);
	}

	public void removeChild(CategoryNode<T> categoryNode) {
		this.children.remove(categoryNode);
	}

	public synchronized List<CategoryNode<T>> getChildren() {
		return children;
	}

	public Integer getLevel() {
		return level;
	}

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		CategoryNode that = (CategoryNode) o;

		return Objects.equal(this.category, that.category) && Objects.equal(this.children, that.children)
				&& Objects.equal(this.level, that.level);
	}

	@Override
	public int hashCode() {
		return Objects.hashCode(category, children, level);
	}

	@Override
	public String toString() {
		return Objects.toStringHelper(this).add("category", category).add("children", children).add("level", level)
				.toString();
	}
}
