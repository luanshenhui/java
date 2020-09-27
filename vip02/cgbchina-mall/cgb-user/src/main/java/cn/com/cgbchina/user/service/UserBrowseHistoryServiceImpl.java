package cn.com.cgbchina.user.service;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.user.dao.MemberBrowseHistoryDao;
import cn.com.cgbchina.user.dto.MemberBatchDto;
import cn.com.cgbchina.user.manager.UserBrowseHistoryManager;
import cn.com.cgbchina.user.model.MemberBrowseHistoryModel;

import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

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
	public Response<Pager<MemberBrowseHistoryModel>> browseHistoryByPager(User user, PageInfo pageInfo) {
		String custId = user.getCustId();
		Response<Pager<MemberBrowseHistoryModel>> result = new Response<Pager<MemberBrowseHistoryModel>>();
		Map<String, Object> param = Maps.newHashMap();
		param.put("custId", custId);
		try {
			Pager<MemberBrowseHistoryModel> pager = memberBrowseHistoryDao.findByPage(param, pageInfo.getOffset(),
					pageInfo.getLimit());

			if (pager.getTotal() == 0) {
				result.setResult(new Pager<MemberBrowseHistoryModel>(0L, Collections
						.<MemberBrowseHistoryModel> emptyList()));
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
	 * 有旧浏览历史就更新，没有就插入
	 */
	public void loinBrowseHistory(String goodsCode, String code, BigDecimal price, String custId, int insta,Long goodsPoint) {
		try{
			userBrowseHistoryManager.loinBrowseHistory(goodsCode, code, price, custId, insta,goodsPoint);
		}catch (Exception e){
			log.error("UserBrowseHistoryServiceImpl.loinBrowseHistory.fail,cause:{}",	Throwables.getStackTraceAsString(e));
          return;
		}
	}

	/**
	 * Description : 按日期段分页查询浏览统计列表
	 * 
	 * @author Huangcy
	 * @param
	 * @return
	 */
	@Override
	public Response<List<MemberBatchDto>> findBrowseHistoryByPager(int pageNo, int pageSize, Map<String, Object> params) {
		Response<List<MemberBatchDto>> response = new Response<List<MemberBatchDto>>();
		try {
			PageInfo pageInfo = new PageInfo(pageNo, pageSize);
			List<MemberBrowseHistoryModel> memberBrowseHistoryModels = memberBrowseHistoryDao.findBrowseHistoryByPager(
					pageInfo.getOffset(), pageInfo.getLimit(), params);
			List<MemberBatchDto> memberBatchDtos = Lists.newArrayList();
			MemberBatchDto memberBatchDto = null;
			for (MemberBrowseHistoryModel memberBrowseHistoryModel : memberBrowseHistoryModels) {
				memberBatchDto = new MemberBatchDto();
				memberBatchDto.setGoodsCode(memberBrowseHistoryModel.getGoodsCode());
				memberBatchDto.setItemCode(memberBrowseHistoryModel.getItemCode());
				memberBatchDto.setCount(memberBrowseHistoryModel.getSource());
				memberBatchDtos.add(memberBatchDto);
			}
			response.setResult(memberBatchDtos);
			return response;
		} catch (Exception e) {
			log.error("UserBrowseHistoryServiceImpl.findBrowseHistoryByPager.fail,cause:{}",
					Throwables.getStackTraceAsString(e));
			response.setError("UserBrowseHistoryServiceImpl.findBrowseHistoryByPager.fail");
			return response;
		}
	}
}
