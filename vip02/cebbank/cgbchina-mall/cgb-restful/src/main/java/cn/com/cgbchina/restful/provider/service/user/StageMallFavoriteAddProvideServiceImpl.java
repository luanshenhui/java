package cn.com.cgbchina.restful.provider.service.user;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.user.StageMallFavoriteAdd;
import cn.com.cgbchina.rest.provider.model.user.StageMallFavoriteAddReturn;
import cn.com.cgbchina.rest.provider.service.user.StageMallFavoriteAddService;
import cn.com.cgbchina.rest.provider.vo.user.StageMallFavoriteAddReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.StageMallFavoriteAddVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL301 添加收藏商品(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL301")
@Slf4j
public class StageMallFavoriteAddProvideServiceImpl implements  SoapProvideService <StageMallFavoriteAddVO,StageMallFavoriteAddReturnVO>{
	@Resource
	StageMallFavoriteAddService stageMallFavoriteAddService;

	@Override
	public StageMallFavoriteAddReturnVO process(SoapModel<StageMallFavoriteAddVO> model, StageMallFavoriteAddVO content) {
		StageMallFavoriteAdd stageMallFavoriteAdd = BeanUtils.copy(content, StageMallFavoriteAdd.class);
		StageMallFavoriteAddReturn stageMallFavoriteAddReturn = stageMallFavoriteAddService.add(stageMallFavoriteAdd);
		StageMallFavoriteAddReturnVO stageMallFavoriteAddReturnVO = BeanUtils.copy(stageMallFavoriteAddReturn,
				StageMallFavoriteAddReturnVO.class);
		return stageMallFavoriteAddReturnVO;
	}

}
