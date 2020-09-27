package cn.com.cgbchina.restful.provider.service.user;

import javax.annotation.Resource;

import cn.com.cgbchina.rest.common.utils.StringUtil;
import cn.com.cgbchina.user.dto.MemberAddressDto;
import cn.com.cgbchina.user.model.MemberAddressModel;
import cn.com.cgbchina.user.service.MemberAddressService;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.user.AddressUpdate;
import cn.com.cgbchina.rest.provider.model.user.AddressUpdateReturn;
import cn.com.cgbchina.rest.provider.vo.user.AddressUpdateReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.AddressUpdateVO;
import lombok.extern.slf4j.Slf4j;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.charset.Charset;

/**
 * MAL333 修改地址接口 从soap对象生成的vo转为 接口调用的bean
 *
 * @author Lizy
 *
 */
@Service
@TradeCode(value = "MAL333")
@Slf4j
public class AddressUpdateProvideServiceImpl implements  SoapProvideService <AddressUpdateVO,AddressUpdateReturnVO>{

	@Resource
	MemberAddressService memberAddressService;

	/**
	 * 地址更新接口
	 * @param model
	 * @param content 更新参数
	 * @return 更新结果
	 *
	 * geshuo 20160727
	 */
	@Override
	public AddressUpdateReturnVO process(SoapModel<AddressUpdateVO> model, AddressUpdateVO content) {
		AddressUpdateReturnVO addressUpdateReturnVO = new AddressUpdateReturnVO();

		String origin = content.getOrigin();// 发起方
		String addressId = StringUtil.dealNull(content.getAddressId());// 地址id
		String custId = StringUtil.dealNull(content.getCustId());// 客户号

		String csgProvinceCode = StringUtil.dealNull(content.getCsgProvinceCode());// 省份编号
		String csgProvince = StringUtil.dealNull(content.getCsgProvince());// 省份名称
		String csgCityCode = StringUtil.dealNull(content.getCsgCityCode());// 市编号
		String csgCity = StringUtil.dealNull(content.getCsgCity());// 市名称
		String csgBoroughCode = StringUtil.dealNull(content.getCsgBoroughCode());// 区编号
		String csgBorough = StringUtil.dealNull(content.getCsgBorough());// 区名称
		String csgAddress = StringUtil.dealNull(content.getCsgAddress());// 收件人通讯地址
		String csgPostcode = StringUtil.dealNull(content.getCsgPostcode());// 收件人邮政编码
		String csgName = StringUtil.dealNull(content.getCsgName());// 收件人姓名
		String csgMobile = StringUtil.dealNull(content.getCsgMobile());// 收件人手机号
		String csgPhone = StringUtil.dealNull(content.getCsgPhone());// 收件人联系电话
		String csgEmail = StringUtil.dealNull(content.getCsgEmail());// 用户邮箱
		String csgSeq = StringUtil.dealNull(content.getCsgSeq());// 顺序
		try {
			// APP渠道 中文需要用UTF-8解码
			if ("09".equals(origin)) {
				try {
					csgProvince = URLDecoder.decode(csgProvince, "UTF-8");// 省份名称
					csgCity = URLDecoder.decode(csgCity, "UTF-8");// 市名称
					csgBorough = URLDecoder.decode(csgBorough, "UTF-8");// 区名称
					csgAddress = URLDecoder.decode(csgAddress, "UTF-8");// 收件人通讯地址
					csgName = URLDecoder.decode(csgName, "UTF-8");// 收件人姓名
				} catch (UnsupportedEncodingException e) {
					addressUpdateReturnVO.setReturnCode("000027");
					addressUpdateReturnVO.setReturnDes("修改地址异常");
					return addressUpdateReturnVO;
				}

			}
			// 需要判断包含中文的字段长度
			if (csgProvince.getBytes(Charset.forName("UTF-8")).length > 50) {
				addressUpdateReturnVO.setReturnCode("000008");
				addressUpdateReturnVO.setReturnDes("报文参数错误:csg_province长度必须小于等于50");
				return addressUpdateReturnVO;
			}
			if (csgCity.getBytes(Charset.forName("UTF-8")).length > 50) {
				addressUpdateReturnVO.setReturnCode("000008");
				addressUpdateReturnVO.setReturnDes("报文参数错误:csg_city长度必须小于等于50");
				return addressUpdateReturnVO;

			}
			if (csgBorough.getBytes(Charset.forName("UTF-8")).length > 50) {
				addressUpdateReturnVO.setReturnCode("000008");
				addressUpdateReturnVO.setReturnDes("报文参数错误:csg_borough长度必须小于等于50");
				return addressUpdateReturnVO;
			}
			if (csgAddress.getBytes(Charset.forName("UTF-8")).length > 200) {
				addressUpdateReturnVO.setReturnCode("000008");
				addressUpdateReturnVO.setReturnDes("报文参数错误:csg_address长度必须小于等于200");
				return addressUpdateReturnVO;
			}
			if (csgName.getBytes(Charset.forName("UTF-8")).length > 30) {
				addressUpdateReturnVO.setReturnCode("000008");
				addressUpdateReturnVO.setReturnDes("报文参数错误:csg_name长度必须小于等于30");
				return addressUpdateReturnVO;
			}

			if(StringUtils.isEmpty(addressId)){
				addressUpdateReturnVO.setReturnCode("000008");
				addressUpdateReturnVO.setReturnDes("报文参数错误:地址编号必须填写");
				return addressUpdateReturnVO;
			}

			if(StringUtils.isEmpty(csgMobile) && StringUtils.isEmpty(csgPhone)){
				addressUpdateReturnVO.setReturnCode("000008");
				addressUpdateReturnVO.setReturnDes("报文参数错误:手机号和联系电话至少填一个");
				return addressUpdateReturnVO;
			}

			MemberAddressModel memberAddressModel = new MemberAddressDto();
			memberAddressModel.setId(Long.parseLong(addressId));
			memberAddressModel.setCustId(custId);//用户id
			memberAddressModel.setProvinceId(csgProvinceCode);
			memberAddressModel.setProvinceName(csgProvince);
			memberAddressModel.setCityId(csgCityCode);
			memberAddressModel.setCityName(csgCity);
			memberAddressModel.setAreaId(csgBoroughCode);
			memberAddressModel.setAreaName(csgBorough);
			memberAddressModel.setAddress(csgAddress);
			memberAddressModel.setPostcode(csgPostcode);
			memberAddressModel.setConsignee(csgName);//收件人
			if(StringUtils.isNotEmpty(csgSeq)){
				memberAddressModel.setCsgSeq(Integer.parseInt(csgSeq));//顺序号
			}
			memberAddressModel.setMobile(csgMobile);
			memberAddressModel.setTelephone(csgPhone);
			memberAddressModel.setCsgEmail(csgEmail);
			memberAddressModel.setModifyOper(custId);
			Response<Boolean> booleanResponse = memberAddressService.updateMemberAddress(memberAddressModel);
			if (!booleanResponse.isSuccess()) {
				addressUpdateReturnVO.setReturnCode("000027");
				addressUpdateReturnVO.setReturnDes("修改地址异常");
				return addressUpdateReturnVO;
			}

			if (!booleanResponse.getResult()) {
				addressUpdateReturnVO.setReturnCode("000010");
				addressUpdateReturnVO.setReturnDes("找不到该地址");
				return addressUpdateReturnVO;
			}
			addressUpdateReturnVO.setReturnCode("000000");
			addressUpdateReturnVO.setReturnDes("修改地址成功");
		} catch (Exception e) {
			log.error("AddressUpdateServiceImpl.update.error Exception{} ", Throwables.getStackTraceAsString(e));
			addressUpdateReturnVO.setReturnCode("000027");
			addressUpdateReturnVO.setReturnDes("修改地址异常");
		}
		return addressUpdateReturnVO;
	}

}
