package cn.com.cgbchina.restful.provider.service.activity;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.activity.NoticCancel;
import cn.com.cgbchina.rest.provider.model.activity.NoticCancelReturn;
import cn.com.cgbchina.rest.provider.service.activity.NoticCancelService;
import cn.com.cgbchina.rest.provider.vo.activity.NoticCancelReturnVO;
import cn.com.cgbchina.rest.provider.vo.activity.NoticCancelVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL332 取消提醒 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL332")
@Slf4j
public class NoticCancelProvideServiceImpl implements  SoapProvideService <NoticCancelVO,NoticCancelReturnVO>{
	@Resource
	NoticCancelService noticCancelService;

	@Override
	public NoticCancelReturnVO process(SoapModel<NoticCancelVO> model, NoticCancelVO content) {
		NoticCancel noticCancel = BeanUtils.copy(content, NoticCancel.class);
		NoticCancelReturn noticCancelReturn = noticCancelService.cancel(noticCancel);
		NoticCancelReturnVO noticCancelReturnVO = BeanUtils.copy(noticCancelReturn,
				NoticCancelReturnVO.class);
		return noticCancelReturnVO;
	}

}
