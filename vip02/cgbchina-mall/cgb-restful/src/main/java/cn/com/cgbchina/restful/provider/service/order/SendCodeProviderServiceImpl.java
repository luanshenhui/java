package cn.com.cgbchina.restful.provider.service.order;

import cn.com.cgbchina.related.model.InfoOutSystemModel;
import cn.com.cgbchina.related.service.InfoOutSystemService;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.SendCodeInfo;
import cn.com.cgbchina.rest.provider.model.order.SendCodeOrderInfo;
import cn.com.cgbchina.rest.provider.model.order.SendCodeReturn;
import cn.com.cgbchina.rest.provider.service.XMLProvideService;
import cn.com.cgbchina.rest.provider.vo.order.SendCodeInfoVO;
import cn.com.cgbchina.rest.provider.vo.order.SendCodeOrderInfoVO;
import cn.com.cgbchina.rest.provider.vo.order.SendCodeReturnVO;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderOutSystemModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.service.OrderOutSystemService;
import cn.com.cgbchina.trade.service.OrderService;
import cn.com.cgbchina.user.dto.MessageDto;
import cn.com.cgbchina.user.service.NewMessageService;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;

import static com.google.common.base.Preconditions.checkArgument;

/**
 * 发码（购票）成功通知接口
 *
 * @author Lizy
 */
@Service
@TradeCode(value = "21")
@Slf4j
public class SendCodeProviderServiceImpl implements XMLProvideService<SendCodeInfoVO, SendCodeReturnVO> {
	@Resource
	private NewMessageService newMessageService;

    @Resource
    private MessageSources messageSources;

    @Resource
    private OrderService orderService;

    @Resource
    InfoOutSystemService infoOutSystemService;

    @Resource
    OrderOutSystemService orderOutSystemService;

    @Override
    public SendCodeReturnVO process(SendCodeInfoVO model) {
        SendCodeReturn sendCodeReturn = new SendCodeReturn();
        try {
            SendCodeInfo sendCodeInfo = BeanUtils.copy(model, SendCodeInfo.class);
            log.info("SendCodeProviderService.sendCode Start");
            log.info("发码成功通知处理报文：" + sendCodeInfo);

            // 请求报文为null
            checkArgument(sendCodeInfo != null, "order.sendCode.null");
            // 订单ID为null
            checkArgument(!Strings.isNullOrEmpty(sendCodeInfo.getOrderNo()), "order.sendCode.orderno.null");

            // 小订单为null
            List<SendCodeOrderInfo> sendCodeOrderInfos = sendCodeInfo.getItems();
            //checkArgument(sendCodeOrderInfos.isEmpty(), "order.sendCode.suborder.null");

            for (SendCodeOrderInfo sendCodeOrderInfo : sendCodeOrderInfos) {
                String subOrderNo = sendCodeOrderInfo.getSubOrderNo();
                String codeData = sendCodeOrderInfo.getCodeData();

                // 小订单ID为null
                checkArgument(!Strings.isNullOrEmpty(subOrderNo), "order.sendCode.suborderno.null");
                // 小订单codeData为null
                checkArgument(!Strings.isNullOrEmpty(codeData), "order.sendCode.codedata.null");

                // 查找 小订单 对应的 订单
                Response<OrderSubModel> responseOrderSubModel = orderService.validateOrderInf(subOrderNo);

                // 小订单在系统中不存在
                checkArgument(responseOrderSubModel.isSuccess() && responseOrderSubModel.getResult() != null,
                        "order.sendCode.suborderno.notExists");
                String status = responseOrderSubModel.getResult().getCurStatusId();

                // 查找 小订单 对应的 行外系统信息记录表
                Response<InfoOutSystemModel> responsInfoOutSystemModel = infoOutSystemService
                        .validateOrderId(subOrderNo);
                // 小订单在 行外系统信息记录表 中不存在
                if (responsInfoOutSystemModel.isSuccess() && responsInfoOutSystemModel.getResult() == null) {
                    InfoOutSystemModel infoOutSystemModel = new InfoOutSystemModel();
                    infoOutSystemModel.setOrderId(subOrderNo);
                    infoOutSystemModel.setVerifyCode(codeData);
                    infoOutSystemModel.setVerifyId(codeData);
                    infoOutSystemModel.setValidateStatus("00");
                    infoOutSystemModel.setSystemRole("00");
                    infoOutSystemModel.setCreateOper("system");
                    infoOutSystemModel.setModifyOper("system");
                    // 新插入 行外系统信息记录表
                    infoOutSystemService.insert(infoOutSystemModel);

                    OrderSubModel orderSubModel = new OrderSubModel();
                    orderSubModel.setOrderId(subOrderNo);
                    orderSubModel.setGoodssendFlag("2"); //2－已签收'
                    orderSubModel.setCurStatusId("0310");
                    orderSubModel.setCurStatusNm("已签收");
                    orderSubModel.setModifyOper("system");
                    // 更新状态为已签收
                    orderService.updateStatues(orderSubModel);

                    // 增加订单历史表记录
                    OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
                    orderDoDetailModel.setOrderId(subOrderNo);
                    orderDoDetailModel.setDoTime(new Date());
                    orderDoDetailModel.setUserType("3");
                    orderDoDetailModel.setDoUserid("020行外系统返回");
                    orderDoDetailModel.setStatusId("0310");
                    orderDoDetailModel.setStatusNm("已签收");
                    orderDoDetailModel.setDoDesc("020通知返回");
					Response<Integer> res = orderService.insertOrderDoDetail(orderDoDetailModel);
					if(res.isSuccess()) {
						MessageDto messageDto = new MessageDto();
						messageDto.setOrderId(subOrderNo);
						messageDto.setOrderStatus("0310");
						messageDto.setGoodName(null != responseOrderSubModel.getResult() ? responseOrderSubModel.getResult().getGoodsNm() : "");
						messageDto.setCustId(null != responseOrderSubModel.getResult() ? responseOrderSubModel.getResult().getCreateOper() : "");
						messageDto.setVendorId(null != responseOrderSubModel.getResult() ? responseOrderSubModel.getResult().getVendorId() : "");
						messageDto.setCreateOper(null != responseOrderSubModel.getResult() ? responseOrderSubModel.getResult().getCreateOper() : "");
						messageDto.setUserType("02");
						newMessageService.insertUserMessage(messageDto);
					}

                    // 判断是否存在推送表，并且是否为推送失败的订单，如果存在，则修改状态为推送成功，本地异常不做抛出处理
                    Response<OrderOutSystemModel> tuiModel = orderOutSystemService.findHanleTuiSongMsg(subOrderNo);
                    if (tuiModel.getResult() != null) { // 推送表存在信息推送失败信息
                        OrderOutSystemModel orderOutSystemModel = new OrderOutSystemModel();
                        orderOutSystemModel.setOrderId(subOrderNo);
                        orderOutSystemModel.setTuisongFlag("1"); //成功状态
                        orderOutSystemModel.setModifyOper("system");
                        orderOutSystemService.updateTuiSongMsg(orderOutSystemModel);
                    }
                } else if (!StringUtils.equals("0310", status)) { ////本来存在，订单状态不为“已签收”则更新信息验证码信息
                    InfoOutSystemModel updateOutSystemModel = new InfoOutSystemModel();
                    updateOutSystemModel.setOrderId(subOrderNo);
                    updateOutSystemModel.setVerifyCode(codeData); //验证码id
                    updateOutSystemModel.setModifyOper("system");
                    infoOutSystemService.updateValidateCode(updateOutSystemModel);
                }
            }
            sendCodeReturn.setReturnCode("true");
        } catch (IllegalArgumentException e) {
            sendCodeReturn.setReturnCode("false");
            log.error("failed to sendCode, cause:{}, SendCodeInfoVO:{}",
                    messageSources.get(Throwables.getStackTraceAsString(e)),
                    model);
        } catch (Exception e) {
            sendCodeReturn.setReturnCode("false");
            log.error("failed to sendCode, cause:{}, SendCodeInfoVO:{}",
                    e.getMessage(),
                    model);
        } finally {
            log.info("SendCodeProviderService.sendCode End");
            return BeanUtils.copy(sendCodeReturn, SendCodeReturnVO.class);
        }
    }
}
