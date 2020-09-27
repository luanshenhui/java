package cn.com.cgbchina.restful.provider.impl.goods;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.item.model.RestCCIntergalPresentDetail;
import cn.com.cgbchina.item.service.RestItemService;
import cn.com.cgbchina.rest.common.util.MallReturnCode;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.goods.CCIntergalPresentDetail;
import cn.com.cgbchina.rest.provider.model.goods.CCIntergalPresentDetailQuery;
import cn.com.cgbchina.rest.provider.service.goods.CCIntergralPresentDetailService;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.service.VendorService;

import com.spirit.common.model.Response;
import com.spirit.util.JsonMapper;

/**
 * MAL102 CC积分商城礼品详细查询
 * 
 * @author lizy
 */
@Service
@Slf4j
public class CCIntergralPresentDetailServiceImpl implements CCIntergralPresentDetailService {
	@Resource
	RestItemService restItemService;

	@Resource
	private VendorService vendorService; // 供应商
	private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

	@Override
	public CCIntergalPresentDetail detail(CCIntergalPresentDetailQuery query) {
		CCIntergalPresentDetail detail = new CCIntergalPresentDetail();
		try {
			Response<RestCCIntergalPresentDetail> detailResp = restItemService.findGoodsByItemid(query.getGoodsId(),
					query.getOrigin());
			if (detailResp.isSuccess() && detailResp != null && detailResp.getResult() != null) {
				detail = BeanUtils.copy(detailResp.getResult(), detail.getClass());
				String vendorId = detailResp.getResult().getVendorId();
				Response<VendorInfoDto> vendorResp = vendorService.findById(vendorId);
				if (vendorResp != null && vendorResp.getResult() != null) {
					detail.setVendorName(vendorResp.getResult().getSimpleName());
				}
				detail.setChannelSN(MallReturnCode.CHANNELCN_CCAG);
				detail.setSuccessCode("01");
				detail.setReturnCode(MallReturnCode.RETURN_SUCCESS_CODE);
				detail.setReturnDes("查询成功");
			}else{
				detail.setChannelSN(MallReturnCode.CHANNELCN_CCAG);
				detail.setSuccessCode("00");
				detail.setReturnCode(MallReturnCode.NotFound_Goods_Code);
				detail.setReturnDes(MallReturnCode.NotFound_Goods_Des);
			}
		} catch (Exception ex) {
			detail.setReturnCode(MallReturnCode.RETURN_SYSERROR_CODE);
			detail.setReturnDes(MallReturnCode.RETURN_SYSERROR_MSG);
			detail.setSuccessCode("00");
			log.error("[MAL102 CC积分商城礼品详细查询 异常] " + ex.getMessage(), ex);
		}
		return detail;
	}
}
