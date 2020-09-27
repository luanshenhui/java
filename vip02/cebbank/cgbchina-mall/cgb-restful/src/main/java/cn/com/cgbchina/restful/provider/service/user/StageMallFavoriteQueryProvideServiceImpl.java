package cn.com.cgbchina.restful.provider.service.user;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.user.StageMallFavoriteQuery;
import cn.com.cgbchina.rest.provider.model.user.StageMallFavoritesReturn;
import cn.com.cgbchina.rest.provider.service.user.StageMallFavoriteQueryService;
import cn.com.cgbchina.rest.provider.vo.user.StageMallFavoritesReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.StageMallFavoriteQueryVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL302 查询收藏商品(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL302")
@Slf4j
public class StageMallFavoriteQueryProvideServiceImpl implements  SoapProvideService <StageMallFavoriteQueryVO,StageMallFavoritesReturnVO>{
	@Resource
	StageMallFavoriteQueryService stageMallFavoriteQueryService;

	@Override
	public StageMallFavoritesReturnVO process(SoapModel<StageMallFavoriteQueryVO> model, StageMallFavoriteQueryVO content) {
		StageMallFavoriteQuery stageMallFavoriteQuery = BeanUtils.copy(content, StageMallFavoriteQuery.class);
		StageMallFavoritesReturn stageMallFavoritesReturn = stageMallFavoriteQueryService.query(stageMallFavoriteQuery);
		StageMallFavoritesReturnVO stageMallFavoritesReturnVO = BeanUtils.copy(stageMallFavoritesReturn,
				StageMallFavoritesReturnVO.class);
		return stageMallFavoritesReturnVO;
	}

}
