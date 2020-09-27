package cn.com.cgbchina.restful.provider.service.goods;

import java.util.ArrayList;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.util.MallReturnCode;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallUserCommentQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallUserCommentQueryVO;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallUserCommentVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

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

	/**
	 * 用户点评：新系统没有对应功能，不做实现
	 * @param model
	 * @param content
	 * @return
	 *
	 * geshuo 20160728
	 */
	@Override
	public StageMallUserCommentQueryReturnVO process(SoapModel<StageMallUserCommentQueryVO> model, StageMallUserCommentQueryVO content) {
		StageMallUserCommentQueryReturnVO stageMallUserCommentQueryReturnVO=new StageMallUserCommentQueryReturnVO();
		stageMallUserCommentQueryReturnVO.setTotalCount("0");
		stageMallUserCommentQueryReturnVO.setTotalPages("0");
		stageMallUserCommentQueryReturnVO.setComments(new ArrayList<StageMallUserCommentVO>());
		stageMallUserCommentQueryReturnVO.setReturnCode(MallReturnCode.RETURN_SUCCESS_CODE);
		return stageMallUserCommentQueryReturnVO;
	}

}
