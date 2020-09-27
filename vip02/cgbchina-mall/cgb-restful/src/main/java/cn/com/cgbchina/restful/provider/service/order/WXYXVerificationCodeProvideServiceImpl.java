package cn.com.cgbchina.restful.provider.service.order;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import cn.com.cgbchina.rest.provider.model.order.VerificationCodeReturn;
import cn.com.cgbchina.rest.provider.model.order.WXYXVerificationCodeInfo;
import org.springframework.stereotype.Service;

import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.VerificationCodeQuery;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.order.VerificationCodeQueryVO;
import cn.com.cgbchina.rest.provider.vo.order.VerificationCodeReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.WXYXVerificationCodeInfoVO;
import cn.com.cgbchina.trade.dto.OrderAndOutSystemDto;
import cn.com.cgbchina.trade.service.OrderService;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL422 微信易信验证码查询 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL422")
@Slf4j
public class WXYXVerificationCodeProvideServiceImpl implements  SoapProvideService <VerificationCodeQueryVO,VerificationCodeReturnVO>{
	@Resource
	OrderService orderService;

	@Override
	public VerificationCodeReturnVO process(SoapModel<VerificationCodeQueryVO> model, VerificationCodeQueryVO content) {
		 //操作表：tbl_order、 tbl_info_outsystem
		//传入参数：origin  beginDate  endDate  goodsNm  createOper  rowsPage  currentPage
		//返回参数：totalPages  totalCount  WXYXVerificationCodeInfos
		//其中WXYXVerificationCodeInfos：List<WXYXVerificationCodeInfoVO>

		//解析content
		VerificationCodeQuery verificationCodeQuery = BeanUtils.copy(content, VerificationCodeQuery.class);
		//定义返回变量
		VerificationCodeReturn verificationCodeReturn = new VerificationCodeReturn();
		try{
			//取出传入参数
			String origin = verificationCodeQuery.getOrigin();//未知，也没用到
			String beginDate = verificationCodeQuery.getBeginDate();//开始时间
			String endDate = verificationCodeQuery.getEndDate();//结束时间
			String goodsNm = verificationCodeQuery.getGoodsNm();//商品名
			String createOper = verificationCodeQuery.getCreateOper();//创建人
			String rowsPage = verificationCodeQuery.getRowsPage();//每页条数
			String currentPage = verificationCodeQuery.getCurrentPage();//现在的页码
			int rowsPageInt = Integer.parseInt(rowsPage);//每页条数String2int
			int currentPageInt = Integer.parseInt(currentPage);//现在的页码String2int
			//分页查询订单表和行外系统信息记录表
			Response<Pager<OrderAndOutSystemDto>> response = orderService.findFor422(rowsPageInt,currentPageInt,beginDate,endDate,createOper,goodsNm);
			if(!response.isSuccess()){
				log.error("OrderAndOutSystemDto.query.error，error:{}", response.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, "OrderAndOutSystemDto.query.error");
			}
			Pager<OrderAndOutSystemDto> pager = response.getResult();
			List<WXYXVerificationCodeInfo> wxyxVerificationCodeInfos = new ArrayList<WXYXVerificationCodeInfo>();
			if(pager.getTotal() > 0){
				//对查询出来的数据进行需要返回的list数据组装
				List<OrderAndOutSystemDto> orderAndOutSystemDtos = pager.getData();
				for(OrderAndOutSystemDto orderAndOutSystemDto : orderAndOutSystemDtos){
					WXYXVerificationCodeInfo wxyxVerificationCodeInfo = new WXYXVerificationCodeInfo();
					wxyxVerificationCodeInfo.setOrderId(orderAndOutSystemDto.getOrderId());//子订单号
					wxyxVerificationCodeInfo.setCurStatusId(orderAndOutSystemDto.getCurStatusId());// 当前状态代码
					wxyxVerificationCodeInfo.setVendorFnm(orderAndOutSystemDto.getVendorSnm());//供应商名称
					wxyxVerificationCodeInfo.setVerifyCode(orderAndOutSystemDto.getVerifyCode());//验证码
					wxyxVerificationCodeInfo.setValidateStatus(orderAndOutSystemDto.getValidateStatus());//验证码状态
					wxyxVerificationCodeInfo.setCreateDate(DateHelper.getyyyyMMdd(orderAndOutSystemDto.getCreateTime()));//创建时间
					wxyxVerificationCodeInfo.setCreateTime(DateHelper.getHHmmss(orderAndOutSystemDto.getCreateTime()));//创建日期
					wxyxVerificationCodeInfo.setGoodsNm(orderAndOutSystemDto.getGoodsNm());//商品名
					wxyxVerificationCodeInfos.add(wxyxVerificationCodeInfo);//将单条数据放入需要返回的list中
				}
				//组装需要返回的数据
				verificationCodeReturn.setWXYXVerificationCodeInfos(wxyxVerificationCodeInfos);//订单信息及验证码信息的list
				verificationCodeReturn.setTotalCount(Long.toString(pager.getTotal()));//总条数
				Long totalPages = pager.getTotal() % rowsPageInt == 0 ? pager.getTotal()  / rowsPageInt : pager.getTotal()  / rowsPageInt + 1 ;//计算总页数
				verificationCodeReturn.setTotalPages(Long.toString(totalPages));//总页数
				verificationCodeReturn.setReturnCode("000000");
			}
		}catch (Exception e){
			log.error("exception", e);
			verificationCodeReturn.setReturnCode("000009");
			verificationCodeReturn.setReturnDes("系统异常");
		}
		//返回变量转Vo进行返回
		VerificationCodeReturnVO verificationCodeReturnVO = BeanUtils.copy(verificationCodeReturn,
				VerificationCodeReturnVO.class);
		return verificationCodeReturnVO;
	}
}
