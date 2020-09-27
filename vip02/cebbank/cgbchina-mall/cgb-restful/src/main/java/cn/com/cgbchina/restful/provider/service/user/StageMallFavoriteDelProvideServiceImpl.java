package cn.com.cgbchina.restful.provider.service.user;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.user.StageMallFavoriteDel;
import cn.com.cgbchina.rest.provider.model.user.StageMallFavoriteDelReturn;
import cn.com.cgbchina.rest.provider.service.user.StageMallFavoriteDelService;
import cn.com.cgbchina.rest.provider.vo.user.StageMallFavoriteDelReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.StageMallFavoriteDelVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL303 删除收藏商品(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL303")
@Slf4j
public class StageMallFavoriteDelProvideServiceImpl implements  SoapProvideService <StageMallFavoriteDelVO,StageMallFavoriteDelReturnVO>{
	@Resource
	StageMallFavoriteDelService stageMallFavoriteDelService;

	@Override
	public StageMallFavoriteDelReturnVO process(SoapModel<StageMallFavoriteDelVO> model, StageMallFavoriteDelVO content) {
		StageMallFavoriteDel stageMallFavoriteDel = BeanUtils.copy(content, StageMallFavoriteDel.class);
		StageMallFavoriteDelReturn stageMallFavoriteDelReturn = stageMallFavoriteDelService.del(stageMallFavoriteDel);
		StageMallFavoriteDelReturnVO stageMallFavoriteDelReturnVO = BeanUtils.copy(stageMallFavoriteDelReturn,
				StageMallFavoriteDelReturnVO.class);
		return stageMallFavoriteDelReturnVO;
	}

}
