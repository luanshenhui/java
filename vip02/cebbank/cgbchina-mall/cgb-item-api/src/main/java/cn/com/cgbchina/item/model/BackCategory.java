package cn.com.cgbchina.item.model;

import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * 后台类目 Created by shixing on 16-4-26.
 */
public class BackCategory extends BaseCategory implements Serializable {

	private static final long serialVersionUID = 3711606462537975994L;
	@Getter
	@Setter
	// 类目属性，JSON格式，例：{attribute:[key1,key2,...],sku:[key1,key2,...]}
	private String attribute;
	@Getter
	@Setter
	private Boolean isParent;// 是否是父节点 数据库中无对应
	@Getter
	@Setter
	private Integer count;// 前台类目计数器 如果有前台类目挂载当前后台类目 那么不允许删除
	@Setter
	@Getter
	private Integer goodCount;// 商品和产品的计数器 如果有商品或产品挂载当前后台类目 不允许删除

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		BackCategory that = (BackCategory) o;

		return Objects.equal(this.attribute, that.attribute) && Objects.equal(this.id, that.id)
				&& Objects.equal(this.name, that.name) && Objects.equal(this.parentId, that.parentId);
	}

	@Override
	public int hashCode() {
		return Objects.hashCode(attribute, id, name, parentId);
	}

	@Override
	public String toString() {
		return "BackCategory{" + "attribute='" + attribute + '\'' + ", isParent=" + isParent + ", count=" + count
				+ ", goodCount=" + goodCount + '}';
	}

}
