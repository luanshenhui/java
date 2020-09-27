package cn.com.cgbchina.restful.provider.service.user;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.user.AddressDel;
import cn.com.cgbchina.rest.provider.model.user.AddressDelReturn;
import cn.com.cgbchina.rest.provider.service.user.AddressDelService;
import cn.com.cgbchina.rest.provider.vo.user.AddressDelReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.AddressDelVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL334 删除地址接口 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL334")
@Slf4j
public class AddressDelProvideServiceImpl implements  SoapProvideService <AddressDelVO,AddressDelReturnVO>{
	@Resource
	AddressDelService addressDelService;

	@Override
	public AddressDelReturnVO process(SoapModel<AddressDelVO> model, AddressDelVO content) {
		AddressDel addressDel = BeanUtils.copy(content, AddressDel.class);
		AddressDelReturn addressDelReturn = addressDelService.del(addressDel);
		AddressDelReturnVO addressDelReturnVO = BeanUtils.copy(addressDelReturn,
				AddressDelReturnVO.class);
		return addressDelReturnVO;
	}

}
