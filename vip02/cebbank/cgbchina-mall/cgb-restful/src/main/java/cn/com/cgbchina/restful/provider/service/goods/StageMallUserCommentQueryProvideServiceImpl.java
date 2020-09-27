package cn.com.cgbchina.restful.provider.service.goods;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.goods.StageMallUserCommentQuery;
import cn.com.cgbchina.rest.provider.model.goods.StageMallUserCommentQueryReturn;
import cn.com.cgbchina.rest.provider.service.goods.StageMallUserCommentQueryService;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallUserCommentQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallUserCommentQueryVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL320 用户点评(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL320")
@Slf4j
public class StageMallUserCommentQueryProvideServiceImpl implements  SoapProvideService <StageMallUserCommentQueryVO,StageMallUserCommentQueryReturnVO>{
	@Resource
	StageMallUserCommentQueryService stageMallUserCommentQueryService;

	@Override
	public StageMallUserCommentQueryReturnVO process(SoapModel<StageMallUserCommentQueryVO> model, StageMallUserCommentQueryVO content) {
		StageMallUserCommentQuery stageMallUserCommentQuery = BeanUtils.copy(content, StageMallUserCommentQuery.class);
		StageMallUserCommentQueryReturn stageMallUserCommentQueryReturn = stageMallUserCommentQueryService.query(stageMallUserCommentQuery);
		StageMallUserCommentQueryReturnVO stageMallUserCommentQueryReturnVO = BeanUtils.copy(stageMallUserCommentQueryReturn,
				StageMallUserCommentQueryReturnVO.class);
		return stageMallUserCommentQueryReturnVO;
	}

}
