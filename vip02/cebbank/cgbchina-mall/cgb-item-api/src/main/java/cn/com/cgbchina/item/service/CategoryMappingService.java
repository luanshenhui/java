package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.CategoryMappingDto;
import cn.com.cgbchina.item.dto.FrontCategoryMappingDto;
import com.spirit.common.model.Response;

import java.util.List;

/**
 * Created by 郝文佳 on 2016/5/16.
 */
public interface CategoryMappingService {
	/**
	 * 通过后台类目的id查找已经挂载该后台类目的前台类目
	 * 
	 * @param ids
	 * @return
	 */
	Response<List<FrontCategoryMappingDto>> frontByFrontIds(Iterable<String> ids);

	/**
	 * 通过后台类目与前台类目关系
	 * 
	 * @param ids
	 * @return
	 */
	Response<List<CategoryMappingDto>> findByBackIds(Iterable<Long> ids);

	/**
	 * 根据前台类目查找于后台类目的对应关系
	 * 
	 * @param frontId
	 * @return
	 */
	Response<List<CategoryMappingDto>> getMappingByFrontId(String frontId);

}
