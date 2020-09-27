package cn.com.cgbchina.restful.provider.service.activity;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.activity.NoticAdd;
import cn.com.cgbchina.rest.provider.model.activity.NoticAddReturn;
import cn.com.cgbchina.rest.provider.service.activity.NoticAddService;
import cn.com.cgbchina.rest.provider.vo.activity.NoticAddReturnVO;
import cn.com.cgbchina.rest.provider.vo.activity.NoticAddVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL331 添加提醒 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL331")
@Slf4j
public class NoticAddProvideServiceImpl implements  SoapProvideService <NoticAddVO,NoticAddReturnVO>{
	@Resource
	NoticAddService noticAddService;

	@Override
	public NoticAddReturnVO process(SoapModel<NoticAddVO> model, NoticAddVO content) {
		NoticAdd noticAdd = BeanUtils.copy(content, NoticAdd.class);
		NoticAddReturn noticAddReturn = noticAddService.add(noticAdd);
		NoticAddReturnVO noticAddReturnVO = BeanUtils.copy(noticAddReturn,
				NoticAddReturnVO.class);
		return noticAddReturnVO;
	}

}
