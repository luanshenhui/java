package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.itemSearchDto;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;

/**
 * Created by 133625 on 16-3-16.
 */
public interface ItemSearchService {
	/**
	 * @param businessType 业务类型
	 * @param channelType 渠道类型
	 * @param keywords 关键字
	 * @param sortField 排序
	 * @param sortDir 排序方向，0升序，1降序
	 * @param startPage 起始页数，从1开始
	 * @param pageSize 每页记录数<br>
	 * @param filterParams json格式过滤条件字符串,如：{"brandId":["1","2"],"priceRange":"100-500"，"5":["51","52"],"6":["61","62"]}
	 *            <br>
	 *            "5":["51","52"]--"5"代表的是销售属性的一个ID，"51"和"52"是销售属性的值的ID
	 * @return 搜索结果
	 */
	Response<itemSearchDto> searchItem(@Param("businessType") String businessType,
			@Param("channelType") String channelType, @Param("keywords") String keywords,
			@Param("sortField") String sortField, @Param("sortDir") String sortDir,
			@Param("startPage") Integer startPage, @Param("pageSize") Integer pageSize,
			@Param("filterParams") String filterParams);
}