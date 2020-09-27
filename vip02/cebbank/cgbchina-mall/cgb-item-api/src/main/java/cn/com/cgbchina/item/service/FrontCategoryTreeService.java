package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.FrontCategoryTree;
import cn.com.cgbchina.item.model.CategoryNode;
import cn.com.cgbchina.item.model.FrontCategory;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;

import java.util.List;

/**
 * Created by 郝文佳 on 2016/5/12.
 */
public interface FrontCategoryTreeService {

	Response<CategoryNode<FrontCategory>> buildCategoryTree();

	Response<CategoryNode<FrontCategory>> find();

	public Response<List<CategoryNode<FrontCategory>>> buildTreeByIds(@Param("ids")String ids);

	/**
	 * @param ids
	 * @return
	 */
	public Response<List<FrontCategoryTree>> findFrontCategoryByIds(@Param("ids") String ids);
}
