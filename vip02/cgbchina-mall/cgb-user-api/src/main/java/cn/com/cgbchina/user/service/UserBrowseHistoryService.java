package cn.com.cgbchina.user.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import cn.com.cgbchina.user.dto.MemberBatchDto;
import cn.com.cgbchina.user.model.MemberBrowseHistoryModel;

import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

/**
 * Created by 张成 on 16-4-25.
 */
public interface UserBrowseHistoryService {
	/**
	 * 分页查询，浏览列表
	 * 
	 * @param pageInfo
	 * @return 结果对象
	 */
	public Response<Pager<MemberBrowseHistoryModel>> browseHistoryByPager(@Param("User") User user, PageInfo pageInfo);

	/**
	 * 
	 * Description : 按日期段分页查询浏览统计列表
	 * 
	 * @param params
	 * @return
	 */
	public Response<List<MemberBatchDto>> findBrowseHistoryByPager(int pageNo, int pageSize, Map<String, Object> params);

	/*
	 * 有旧浏览历史就更新，没有就插入
	 */
	public void loinBrowseHistory(String goodsCode, String code, BigDecimal price, String custId, int insta,Long goodsPoint);
}
