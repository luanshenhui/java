package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.dao.MemberBrowseHistoryDao;
import cn.com.cgbchina.user.manager.UserBrowseHistoryManager;
import cn.com.cgbchina.user.model.MemberBrowseHistoryModel;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.Collections;
import java.util.Map;

/**
 * Created by Cong on 2016/5/18.
 */
@Service
@Slf4j
public class UserBrowseHistoryServiceImpl implements UserBrowseHistoryService {

	@Resource
	private MemberBrowseHistoryDao memberBrowseHistoryDao;
	@Resource
	private UserBrowseHistoryManager userBrowseHistoryManager;

	/**
	 * 分页取得浏览信息列表
	 * 
	 * @param pageInfo
	 * @return
	 */
	public Response<Pager<MemberBrowseHistoryModel>> browseHistoryByPager(PageInfo pageInfo) {
		Response<Pager<MemberBrowseHistoryModel>> result = new Response<Pager<MemberBrowseHistoryModel>>();
		Map<String, Object> param = Maps.newHashMap();
		try {
			Pager<MemberBrowseHistoryModel> pager = memberBrowseHistoryDao.findByPage(param, pageInfo.getOffset(),
					pageInfo.getLimit());

			if (pager.getTotal() == 0) {
				result.setResult(
						new Pager<MemberBrowseHistoryModel>(0L, Collections.<MemberBrowseHistoryModel> emptyList()));
				return result;
			} else {

				result.setResult(pager);
				return result;
			}
		} catch (Exception e) {
			log.error("UserBrowseHistoryServiceImpl.browseHistoryByPager.fail,cause:{}",
					Throwables.getStackTraceAsString(e));
			result.setError("UserBrowseHistoryServiceImpl.browseHistoryByPager.fail");
			return result;
		}
	}


	/*
	 *有旧浏览历史就更新，没有就插入
	 */
	public void loinBrowseHistory(String goodsCode, String code, BigDecimal price, String custId, int insta){
		userBrowseHistoryManager.loinBrowseHistory(goodsCode,code,price,custId,insta);
	}
}
