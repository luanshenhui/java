package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.BrandAuthorizeModel;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import com.google.common.base.MoreObjects;
import com.google.common.base.Objects;
import com.spirit.category.model.BackCategory;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by 陈乐 on 2016/5/20.
 */
public class BackCategoryAndBrandsDto implements Serializable {

	private static final long serialVersionUID = 6931610569779237511L;
	@Getter
	@Setter
	private List<BackCategory> backCategoryList;
	@Getter
	@Setter
	private List<GoodsBrandModel> brandList;
	@Getter
	@Setter
	private List<BrandAuthorizeModel> brandsList;

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		BackCategoryAndBrandsDto that = (BackCategoryAndBrandsDto) o;

		return Objects.equal(this.backCategoryList, that.backCategoryList)
				&& Objects.equal(this.brandList, that.brandList) && Objects.equal(this.brandsList, that.brandsList);
	}

	@Override
	public int hashCode() {
		return Objects.hashCode(backCategoryList, brandList, brandsList);
	}

	@Override
	public String toString() {
		return MoreObjects.toStringHelper(this).add("backCategoryList", backCategoryList).add("brandList", brandList)
				.add("brandsList", brandsList).toString();
	}
}
