package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.model.MemberBrowseHistoryModel;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import java.math.BigDecimal;

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
	public Response<Pager<MemberBrowseHistoryModel>> browseHistoryByPager(PageInfo pageInfo);

	/*
     *有旧浏览历史就更新，没有就插入
     */
	public void loinBrowseHistory(String goodsCode, String code, BigDecimal price, String custId,int insta);
}
