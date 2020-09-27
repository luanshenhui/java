package cn.com.cgbchina.restful.provider.service.order;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.elasticsearch.common.base.Strings;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrder;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrdersQuery;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrdersReturn;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.order.CCIntergralOrdersQueryVO;
import cn.com.cgbchina.rest.provider.vo.order.CCIntergralOrdersReturnVO;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.TblOrderMainBackupModel;
import cn.com.cgbchina.trade.model.TblOrdermainHistoryModel;
import cn.com.cgbchina.trade.service.TblOrderMainBackupService;
import cn.com.cgbchina.trade.service.TblOrderMainHistoryService;
import cn.com.cgbchina.trade.service.TblOrderMainService;

import com.alibaba.dubbo.common.utils.StringUtils;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;

/**
 * MAL105 CC积分商城订单列表查询 从soap对象生成的vo转为 接口调用的bean niufw
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL105")
@Slf4j
public class CCIntergralOrdersQueryProvideServiceImpl
		implements SoapProvideService<CCIntergralOrdersQueryVO, CCIntergralOrdersReturnVO> {
	@Resource
	TblOrderMainService tblOrderMainService;
	@Resource
	TblOrderMainHistoryService tblOrderMainHistoryService;
	@Resource
	TblOrderMainBackupService tblOrderMainBackupService;

	@Override
	public CCIntergralOrdersReturnVO process(SoapModel<CCIntergralOrdersQueryVO> model,
			CCIntergralOrdersQueryVO content) {
		// 需要查询的表：tbl_order_main、tblordermain_history、tblordermain_backup
		// 需要传入的参数： cardNo、 orderMainId、 startDate、 endDate
		// 需要返回的参数： returnCode、 returnDes、 channelSN、 successCode、 loopTag、 loopCount、 CCIntergralOrders
		// CCIntergralOrders 是List<CCIntergralOrder>
		// CCIntergralOrder：orderMainId、 acceptedNo

		// donghb 0903 start
		// 定义返回值
		CCIntergralOrdersReturn cCIntergralOrdersReturn = new CCIntergralOrdersReturn();
		try {
			// donghb 0903 end
			//校验
			if(content == null){
				throw new ResponseException(Contants.ERROR_CODE_500, "content.time.query.error");
			}
			// 取出传入的参数
			CCIntergralOrdersQuery cCIntergralOrdersQuery = BeanUtils.copy(content, CCIntergralOrdersQuery.class);
			String cardNo = cCIntergralOrdersQuery.getCardNo();
			String orderMainId = cCIntergralOrdersQuery.getOrderMainId();
			String startDate = cCIntergralOrdersQuery.getStartDate();
			String endDate = cCIntergralOrdersQuery.getEndDate();
			// 校验开始
			if (StringUtils.isEmpty(cardNo)) {
				cardNo = "";
			} else {
				cardNo = cardNo.trim();
			}
			if (StringUtils.isEmpty(orderMainId)) {
				orderMainId = "";
			} else {
				orderMainId = orderMainId.trim();
			}
			Date startTime = null;
			Date endTime =  null ;
			if (StringUtils.isEmpty(startDate)) {
				// donghb 0903 start
				endDate = DateHelper.getyyyyMMdd();// 如果开始日期为空，则结束日期取当前日期
				endTime = DateHelper.string2Date(endDate, DateHelper.YYYYMMDD);
				startTime = DateHelper.addMonth(endTime, -6);// 如果没传入开始日期，则默认返回半年前的数据
				startDate = DateHelper.date2string(startTime, DateHelper.YYYYMMDD);
				// donghb 0903 end
			}else {
				if (StringUtils.isEmpty(endDate)) {//结束时间为空
					startTime = DateHelper.string2Date(startDate, DateHelper.YYYYMMDD);
					endDate = DateHelper.getyyyyMMdd();// 如果开始日期为空，则结束日期取当前日期
					endTime = DateHelper.string2Date(endDate, DateHelper.YYYYMMDD);
					endTime = DateHelper.addDay(endTime, 1);
				} else {
					startTime = DateHelper.string2Date(startDate, DateHelper.YYYYMMDD);
					endTime = DateHelper.string2Date(endDate, DateHelper.YYYYMMDD);
					endTime = DateHelper.addDay(endTime, 1);
				}
			}
	
			// 校验结束
			//当查询参数为空时
			if (cardNo.length() == 0 && orderMainId.length() == 0) {
				// 固定参数
				cCIntergralOrdersReturn.setChannelSN("CCAG");
				// donghb 0903 start
				cCIntergralOrdersReturn.setSuccessCode("00");
				cCIntergralOrdersReturn.setReturnCode("000008");
				// donghb 0903 end
				cCIntergralOrdersReturn.setReturnDes("报文参数错误");
				CCIntergralOrdersReturnVO cCIntergralOrdersReturnVO = BeanUtils.copy(cCIntergralOrdersReturn,
						CCIntergralOrdersReturnVO.class);
				return cCIntergralOrdersReturnVO;
			}
			List<CCIntergralOrder> ccIntergralOrderList = new ArrayList<>();
			// 查询tbl_order_main表的数据
			Response<List<OrderMainModel>> orderMainModels = tblOrderMainService.findForCC(cardNo, orderMainId, startTime,
					endTime);
			List<OrderMainModel> orderMainModelList = orderMainModels.getResult();
			for (OrderMainModel orderMainModel : orderMainModelList) {
				CCIntergralOrder ccIntergralOrder = new CCIntergralOrder();
				// 取出需要的数据orderMainId和acceptedNo
				String thisOrderMainId = orderMainModel.getOrdermainId();
				String acceptedNo = orderMainModel.getAcceptedNo();
				if (Strings.isNullOrEmpty(acceptedNo)) {
					acceptedNo = "没有受理号";
				}
				// 将orderMainId和acceptedNo存入定义的ccIntergralOrder
				ccIntergralOrder.setOrderMainId(thisOrderMainId);
				ccIntergralOrder.setAcceptedNo(acceptedNo);
				// 将ccIntergralOrder放入ccIntergralOrderList
				ccIntergralOrderList.add(ccIntergralOrder);
			}
			// 查询tblordermain_history表的数据
			Response<List<TblOrdermainHistoryModel>> tblOrdermainHistoryModels = tblOrderMainHistoryService
					.findForCC(cardNo, orderMainId, startTime, endTime);
			List<TblOrdermainHistoryModel> tblOrdermainHistoryModelList = tblOrdermainHistoryModels.getResult();
			for (TblOrdermainHistoryModel tblOrdermainHistoryModel : tblOrdermainHistoryModelList) {
				CCIntergralOrder ccIntergralOrder = new CCIntergralOrder();
				// 取出需要的数据orderMainId和acceptedNo
				String thisOrderMainId = tblOrdermainHistoryModel.getOrdermainId();
				String acceptedNo = tblOrdermainHistoryModel.getAcceptedNo();
				if (Strings.isNullOrEmpty(acceptedNo)) {
					acceptedNo = "没有受理号";
				}
				// 将orderMainId和acceptedNo存入定义的ccIntergralOrder
				ccIntergralOrder.setOrderMainId(thisOrderMainId);
				ccIntergralOrder.setAcceptedNo(acceptedNo);
				// 将ccIntergralOrder放入ccIntergralOrderList
				ccIntergralOrderList.add(ccIntergralOrder);
			}
	
			// 查询tblordermain_backup表的数据
			Response<List<TblOrderMainBackupModel>> tblOrderMainBackupModels = tblOrderMainBackupService.findForCC(cardNo,
					orderMainId, startTime, endTime);
			List<TblOrderMainBackupModel> tblOrderMainBackupModelList = tblOrderMainBackupModels.getResult();
			for (TblOrderMainBackupModel tblOrderMainBackupModel : tblOrderMainBackupModelList) {
				CCIntergralOrder ccIntergralOrder = new CCIntergralOrder();
				// 取出需要的数据orderMainId和acceptedNo
				String thisOrderMainId = tblOrderMainBackupModel.getOrdermainId();
				String acceptedNo = tblOrderMainBackupModel.getAcceptedNo();
				if (Strings.isNullOrEmpty(acceptedNo)) {
					acceptedNo = "没有受理号";
				}
				// 将orderMainId和acceptedNo存入定义的ccIntergralOrder
				ccIntergralOrder.setOrderMainId(thisOrderMainId);
				ccIntergralOrder.setAcceptedNo(acceptedNo);
				// 将ccIntergralOrder放入ccIntergralOrderList
				ccIntergralOrderList.add(ccIntergralOrder);
			}
			// 固定参数
			cCIntergralOrdersReturn.setChannelSN("CCAG");
			// donghb 0903 start
			cCIntergralOrdersReturn.setSuccessCode("01");
			cCIntergralOrdersReturn.setReturnCode("000000");
			// donghb 0903 start
			cCIntergralOrdersReturn.setReturnDes("正常");
			cCIntergralOrdersReturn.setLoopTag("0000");
			cCIntergralOrdersReturn.setLoopCount(String.valueOf(ccIntergralOrderList.size()));
			cCIntergralOrdersReturn.setCcIntergralOrders(ccIntergralOrderList);
			CCIntergralOrdersReturnVO cCIntergralOrdersReturnVO = BeanUtils.copy(cCIntergralOrdersReturn,
					CCIntergralOrdersReturnVO.class);
			return cCIntergralOrdersReturnVO;
		// donghb 0903 start
		} catch (Exception e) {
			// 固定参数
			cCIntergralOrdersReturn.setChannelSN("CCAG");
			cCIntergralOrdersReturn.setSuccessCode("00");
			cCIntergralOrdersReturn.setReturnCode("000009");
			cCIntergralOrdersReturn.setReturnDes("系统异常");
			CCIntergralOrdersReturnVO cCIntergralOrdersReturnVO = BeanUtils.copy(cCIntergralOrdersReturn,
					CCIntergralOrdersReturnVO.class);
			return cCIntergralOrdersReturnVO;
		}
		// donghb 0903 end
	}
}
