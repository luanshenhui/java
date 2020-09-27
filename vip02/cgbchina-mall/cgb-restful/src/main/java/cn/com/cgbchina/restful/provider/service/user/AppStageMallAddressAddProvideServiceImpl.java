package cn.com.cgbchina.restful.provider.service.user;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.user.AppStageMallAddressAddReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.AppStageMallAddressAddVO;
import cn.com.cgbchina.rest.visit.model.user.QueryUserInfo;
import cn.com.cgbchina.rest.visit.model.user.UserInfo;
import cn.com.cgbchina.rest.visit.service.user.UserService;
import cn.com.cgbchina.user.dto.MemberAddressDto;
import cn.com.cgbchina.user.model.MemberAddressModel;
import cn.com.cgbchina.user.service.MemberAddressService;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.charset.Charset;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * MAL318 添加地址接口(分期商城) 从soap对象生成的vo转为 接口调用的bean
 *
 * @author Lizy
 *
 */
@Service
@TradeCode(value = "MAL318")
@Slf4j
public class AppStageMallAddressAddProvideServiceImpl implements  SoapProvideService <AppStageMallAddressAddVO,AppStageMallAddressAddReturnVO>{
	@Autowired
	MemberAddressService memberAddressService;
	@Resource
	UserService userService;

	/**
	 * 添加地址接口
	 * @param model
	 * @param content 添加参数
	 * @return 添加结果
	 *
	 * geshuo 20160727
	 */
	@Override
	public AppStageMallAddressAddReturnVO process(SoapModel<AppStageMallAddressAddVO> model, AppStageMallAddressAddVO content) {
		AppStageMallAddressAddReturnVO appStageMallAddressAddReturnVO = new AppStageMallAddressAddReturnVO();


		String origin = content.getOrigin();// 发起方
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
		String csgIdCard = StringUtil.dealNull(content.getIdCard());//身份证号
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
					appStageMallAddressAddReturnVO.setReturnCode("000027");
					appStageMallAddressAddReturnVO.setReturnDes("添加地址异常");
					return appStageMallAddressAddReturnVO;
				}

			}
			// 需要判断包含中文的字段长度
			if (csgProvince.getBytes(Charset.forName("UTF-8")).length > 50) {
				appStageMallAddressAddReturnVO.setReturnCode("000008");
				appStageMallAddressAddReturnVO.setReturnDes("报文参数错误:csg_province长度必须小于等于50");
				return appStageMallAddressAddReturnVO;
			}
			if (csgCity.getBytes(Charset.forName("UTF-8")).length > 50) {
				appStageMallAddressAddReturnVO.setReturnCode("000008");
				appStageMallAddressAddReturnVO.setReturnDes("报文参数错误:csg_city长度必须小于等于50");
				return appStageMallAddressAddReturnVO;

			}
			if (csgBorough.getBytes(Charset.forName("UTF-8")).length > 50) {
				appStageMallAddressAddReturnVO.setReturnCode("000008");
				appStageMallAddressAddReturnVO.setReturnDes("报文参数错误:csg_borough长度必须小于等于50");
				return appStageMallAddressAddReturnVO;
			}
			if (csgAddress.getBytes(Charset.forName("UTF-8")).length > 200) {
				appStageMallAddressAddReturnVO.setReturnCode("000008");
				appStageMallAddressAddReturnVO.setReturnDes("报文参数错误:csg_address长度必须小于等于200");
				return appStageMallAddressAddReturnVO;
			}
			if (csgName.getBytes(Charset.forName("UTF-8")).length > 30) {
				appStageMallAddressAddReturnVO.setReturnCode("000008");
				appStageMallAddressAddReturnVO.setReturnDes("报文参数错误:csg_address长度必须小于等于200");
				return appStageMallAddressAddReturnVO;
			}
//			if (StringUtils.isEmpty(custId)) {//客户号必填
//				appStageMallAddressAddReturnVO.setReturnCode("000008");
//				appStageMallAddressAddReturnVO.setReturnDes("报文参数错误:客户号不能为空");
//				return appStageMallAddressAddReturnVO;
//			}
			if(csgName.getBytes().length>30){
				appStageMallAddressAddReturnVO.setReturnCode("000008");
				appStageMallAddressAddReturnVO.setReturnDes("报文参数错误:csg_name长度必须小于等于30");
				return appStageMallAddressAddReturnVO;
			}
			if(StringUtils.isEmpty(csgMobile) && StringUtils.isEmpty(csgPhone)){
				appStageMallAddressAddReturnVO.setReturnCode("000008");
				appStageMallAddressAddReturnVO.setReturnDes("报文参数错误:手机号和联系电话至少填一个");
				return appStageMallAddressAddReturnVO;
			}

			Map<String, Object> paramMap = Maps.newHashMap();
			if(Contants.CHANNEL_SN_WX.equals(origin)||Contants.CHANNEL_SN_WS.equals(origin)||
					Contants.CHANNEL_SN_YX.equals(origin)||Contants.CHANNEL_SN_YS.equals(origin)){//微信渠道
				if("".equals(custId) && "".equals(csgIdCard)){
					appStageMallAddressAddReturnVO.setReturnCode("000008");
					appStageMallAddressAddReturnVO.setReturnDes("报文参数错误:客户号和证件号至少填一个");
					return appStageMallAddressAddReturnVO;
				}
				if(StringUtils.isNotEmpty(custId)){
					paramMap.put("custId", custId);
				}
				if(StringUtils.isNotEmpty(csgIdCard)){
					paramMap.put("csgIdCard", csgIdCard);
				}
			}else{//手机渠道和APP渠道
				if("".equals(custId)){//客户号必填
					appStageMallAddressAddReturnVO.setReturnCode("000008");
					appStageMallAddressAddReturnVO.setReturnDes("报文参数错误:客户号不能为空");
					return appStageMallAddressAddReturnVO;
				}
				paramMap.put("custId", custId);
			}

			Response<List<MemberAddressModel>> memberAddressServiceByCustId = memberAddressService.findByParams(paramMap);
			if (!memberAddressServiceByCustId.isSuccess()) {
				throw new RuntimeException(memberAddressServiceByCustId.getError());
			}
			List<MemberAddressModel> list = memberAddressServiceByCustId.getResult();
			if (list != null) {
				if (list.size() > 5) {
					appStageMallAddressAddReturnVO.setReturnCode("000044");
					appStageMallAddressAddReturnVO.setReturnDes("每个用户最多添加6条地址信息");
					return appStageMallAddressAddReturnVO;
				}
			}

			MemberAddressDto memberAddressDto = new MemberAddressDto();
			UserInfo userInfo = new UserInfo();
			if (StringUtils.isEmpty(custId)) {
				QueryUserInfo info = new QueryUserInfo();
				info.setCertNo(csgIdCard);
				userInfo = userService.getCousrtomInfo(info);
				custId = userInfo.getCustomerId();
			}
			memberAddressDto.setCustId(custId);
			memberAddressDto.setConsignee(csgName);//收件人
			memberAddressDto.setProvinceId(csgProvinceCode);
			memberAddressDto.setProvinceName(csgProvince);
			memberAddressDto.setCityId(csgCityCode);
			memberAddressDto.setCityName(csgCity);
			if (csgBoroughCode != null && !"".equals(csgBoroughCode.trim())) {
				memberAddressDto.setAreaId(csgBoroughCode);
				memberAddressDto.setAreaName(csgBorough);
			} else {
				memberAddressDto.setAreaId("00");
				memberAddressDto.setAreaName(csgBorough);
			}
			memberAddressDto.setAddress(csgAddress);
			memberAddressDto.setPostcode(csgPostcode);
			memberAddressDto.setIdCard(csgIdCard);//广发微信商城需求 增加""证件号
			memberAddressDto.setCsgEmail(csgEmail);//邮箱
			memberAddressDto.setIsDefault(Contants.MALL_ADDRESS_STATUS_1);//初始不是默认地址

			if (StringUtils.isNotEmpty(csgSeq)) {
				memberAddressDto.setCsgSeq(Integer.parseInt(csgSeq));
			}

			if (StringUtils.isNotEmpty(csgMobile)) {
				memberAddressDto.setMobile(csgMobile);
			}
			if (StringUtils.isNotEmpty(csgPhone)) {
				memberAddressDto.setTelNumber(csgPhone);
			}
			Date date = new Date();
			memberAddressDto.setModifyTime(date);
			memberAddressDto.setCreateTime(date);
			memberAddressDto.setCreatOper(custId);//创建人
			memberAddressDto.setModifyOper(custId);
			Response<Boolean> booleanResponse = memberAddressService.create(memberAddressDto);
			if (booleanResponse.isSuccess()) {
				appStageMallAddressAddReturnVO.setReturnCode("000000");
				appStageMallAddressAddReturnVO.setReturnDes("SUCCESS");
			} else {
				appStageMallAddressAddReturnVO.setReturnCode("000027");
				appStageMallAddressAddReturnVO.setReturnDes("添加地址异常");
				return appStageMallAddressAddReturnVO;
			}
		} catch (Exception e) {
			log.error("AppStageMallAddressAddServiceImpl.add.error Exception{} ", Throwables.getStackTraceAsString(e));
			appStageMallAddressAddReturnVO.setReturnCode("000027");
			appStageMallAddressAddReturnVO.setReturnDes("添加地址异常");
		}
		return appStageMallAddressAddReturnVO;
	}

}
