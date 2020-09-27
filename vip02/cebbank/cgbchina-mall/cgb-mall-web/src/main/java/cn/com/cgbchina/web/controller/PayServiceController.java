package cn.com.cgbchina.web.controller;

import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.SignAndVerify;
import cn.com.cgbchina.trade.dto.OrderDealDto;
import cn.com.cgbchina.trade.dto.PayOrderInfoDto;
import cn.com.cgbchina.trade.dto.PayOrderSubDto;
import cn.com.cgbchina.trade.service.OrderDealService;
import com.google.common.base.Charsets;
import com.google.common.hash.Hashing;
import com.google.common.io.Resources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 支付网关支付返回报文后的处理流程
 *
 * @author shangqb
 * @version 2016年6月27日 下午15:00:00
 */
@Slf4j
@Controller
@RequestMapping("/pay")
public class PayServiceController {

    @Autowired
    private OrderDealService orderDealService;

    @Value("#{app.entPublicKey}")
    private String entPublicKey;

    @Value("#{app.orderResult1}")
    private String orderResult1;

    @Value("#{app.orderResult2}")
    private String orderResult2;

    @Value("#{app.orderResult3}")
    private String orderResult3;

    @Value("#{app.orderResult4}")
    private String orderResult4;

    @Value("#{app.orderResult5}")
    private String orderResult5;

    @Value("#{app.orderResult6}")
    private String orderResult6;

    @Value("#{app.orderResult7}")
    private String orderResult7;

    @Value("#{app.orderResult8}")
    private String orderResult8;

    @RequestMapping(value = "/dealPay", method = RequestMethod.POST)
    public String dealPay(HttpServletRequest request, HttpServletResponse response) {
        log.info(DateHelper.getCurrentTime()+request.getContextPath());
        String YFflag = "1";// 积分标识 1:广发  2积分
        try {
            String orderid = this.getTrimValue(request.getParameter("orderid"));  //订单号
            String payAccountNo = this.getTrimValue(request.getParameter("payAccountNo"));// 支付账号
            String cardType = this.getTrimValue(request.getParameter("cardType"));// 卡类型
            String orders = this.getTrimValue(request.getParameter("orders"));// 订单信息串
            String crypt = this.getTrimValue(request.getParameter("crypt"));// 签名
            String payTime = this.getTrimValue(request.getParameter("payTime"));// 支付时间
            if(orderid==null||payAccountNo==null||cardType==null||orders==null||crypt==null||payTime==null){
                response.sendRedirect(orderResult2);
            }
            YFflag = judgeLJ(orders);
            // 验签 String
            String singGene = orderid + "|" + payAccountNo + "|" + cardType + "|" + orders;
            //SHA加密
            boolean isCrypt = SignAndVerify.verify_md(singGene, crypt,entPublicKey);
            if (isCrypt == false) {// 如果验签失败
//                log.info("验签出错");
//                response.sendRedirect(orderResult8);
            }

            String phone = "";
            PayOrderInfoDto payOrderInfoDto = new PayOrderInfoDto();
            payOrderInfoDto.setOrderid(orderid);
            payOrderInfoDto.setPayAccountNo(payAccountNo);
            payOrderInfoDto.setCardType(cardType);
            payOrderInfoDto.setCrypt(crypt);
            payOrderInfoDto.setPhone(phone);
            payOrderInfoDto.setPayTime(payTime);  //插入订单支付时间
            parseOrders(orders, payOrderInfoDto);// 解析子订单信息
            OrderDealDto ResData = null;// 请求生成订单

            try {
                ResData = orderDealService.dealPay(payOrderInfoDto);
                ResData.setRetcode("0");
                ResData.setMessage("");
            } catch (Exception e) {
                ResData.setRetcode("0");
                ResData.setMessage(e.getMessage());
            }
            if (ResData != null) {// 如果ejb返回数据不为空
                String retcode = ResData.getRetcode();
                String message = ResData.getMessage();
                String errorCode = ResData.getErrorCode();
                String errorDesc = ResData.getErrorDesc();
                String orderType = ResData.getOrderType();
                String sucessFlag = ResData.getSucessFlag();
                if (sucessFlag == null || "".equals(sucessFlag.trim())) {
                    sucessFlag = "0";
                }
                List torders = new ArrayList();
                log.info("errorCode:" + errorCode);
                if ("3333".equals(errorCode)) {// 如果是支付网关重复返回结果
                    log.info("支付网关重复返回结果");
//                    request.setAttribute("error", "您好,订单正在受理中,请稍后查询订单信息，谢谢!");
//                    request.setAttribute("sucessFlag", "2");
                    response.sendRedirect(orderResult3);
                } else if ("YG".equals(orderType)) {// 一期
                    log.info("一次性支付处理");
                    if ("0".equals(retcode) && "0000".equals(errorCode)) {// 如果订单处理正常
                        log.info("订单处理正常");
                        if ("0".equals(sucessFlag.trim())) {
//                            request.setAttribute("error", "支付成功");
                            log.info("支付成功");
                            response.sendRedirect(orderResult1);
                        } else if ("1".equals(sucessFlag.trim())) {
                            log.info("支付失败");
//                            request.setAttribute("error", "支付失败");
                            response.sendRedirect(orderResult2);
                        }else if ("7".equals(sucessFlag.trim())) {
                            log.info("支付状态未明");
//                            request.setAttribute("error", "支付状态未明");
                            response.sendRedirect(orderResult3);
                        } else {
                            log.info("支付部分成功");
//                            request.setAttribute("error", "支付部分成功");
                            response.sendRedirect(orderResult6);
                        }
                    } else {// 支付失败
                        log.info("订单处理异常");
//                        request.setAttribute("error", "订单处理异常");
                        response.sendRedirect(orderResult2);
                    }
                } else if ("FQ".equals(orderType)) {// 分期
                    log.info("分期支付处理");
                    boolean holland = false;
                    if ("0".equals(retcode) && "0000".equals(errorCode)) {// 如果订单处理正常
                        log.info("订单处理正常");
                        if ("0".equals(sucessFlag.trim())) { // 全部订单成功
//                            request.setAttribute("error", "订单已受理");
                            log.info("全部订单成功");
                            response.sendRedirect(orderResult1);
                        } else if ("1".equals(sucessFlag.trim())) { // 全部子订单失败
//                            request.setAttribute("error", "订单受理失败");
                            log.info("全部子订单失败");
                            response.sendRedirect(orderResult2);
                        } else if ("3".equals(sucessFlag.trim())) { // 如果全部子订单处理中
//                            request.setAttribute("error", "订单已受理");
                            log.info("全部子订单处理中");
                            response.sendRedirect(orderResult4);
                        } else if ("2".equals(sucessFlag.trim())) { // 如果部分成功、部分失败、部分处理中
//                            request.setAttribute("error", "订单已受理");
                            log.info("部分成功、部分失败、部分处理中");
                            response.sendRedirect(orderResult7);
                        } else if ("4".equals(sucessFlag.trim())) { // 部分成功、部分处理中
//                            request.setAttribute("error", "订单已受理");
                            log.info("部分成功、部分处理中");
                            response.sendRedirect(orderResult5);
                        } else if ("5".equals(sucessFlag.trim())) { // 部分成功、部分失败
//                            request.setAttribute("error", "订单已受理");
                            log.info("部分成功、部分失败");
                            response.sendRedirect(orderResult6);
                        } else if ("6".equals(sucessFlag.trim())) { // 部分处理中、部分失败
//                            request.setAttribute("error", "订单已受理");
                            log.info("部分处理中、部分失败");
                            response.sendRedirect(orderResult7);
                        } else if ("7".equals(sucessFlag.trim())) { // 状态未明
//                            request.setAttribute("error", "订单状态未明");
                            log.info("状态未明");
                            response.sendRedirect(orderResult3);
                        }
                    } else {// 支付失败
                        log.info("订单处理异常");
//                        request.setAttribute("error", "订单处理异常");
                        response.sendRedirect(orderResult2);
                    }
                } else if ("JF".equals(orderType)) {// 积分
//                    log.info("积分支付处理");
//                    if ("0".equals(retcode) && "0000".equals(errorCode)) {// 如果订单处理正常
//                        log.info("订单处理正常");
//                        if ("0".equals(sucessFlag.trim())) {
//                            request.setAttribute("error", "支付成功");
//                        } else if ("1".equals(sucessFlag.trim())) {
//                            request.setAttribute("error", "支付失败");
//                        } else {
//                            request.setAttribute("error", "支付部分成功");
//                        }
//                    } else {// 支付异常
//                        log.info("订单处理异常");
//                        request.setAttribute("error", "订单处理异常");
//                    }
//                    request.setAttribute("sucessFlag", sucessFlag);
//                    dispatcher = request.getRequestDispatcher("/eshop_jf/scart/payResultJF.jsp");
                } else {
                    log.info("程序处理异常");
                    response.sendRedirect(orderResult2);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            log.error(e.getMessage(), e);
        }
        return null;
    }

    /**
     * 判断乐购还是积分 1:广发 2积分
     *
     * @param orders
     * @return
     * @throws Exception
     */
    private String judgeLJ(String orders) throws Exception {
        if (orders == null || "".equals(orders)) {
            throw new Exception("子订单不能为空");
        }
        String orderArray[] = orders.split("\\|");
        if (orderArray.length % 4 != 0) {// 如果除以5余数不为0
            throw new Exception("子订单数据错误");
        }
        if (orderArray[1].length() == 16) {// 如果是积分
            return "2";
        }
        return "1";
    }

    /**
     * 根据子订单拼xml报文
     *
     * @throws Exception
     */
    private void parseOrders(String orders, PayOrderInfoDto payOrderInfoDto) throws Exception {
        log.info("进入parseOrders");
        log.info("子订单信息：" + orders);
        if (orders == null || "".equals(orders)) {
            log.info("拼xml报文时子订单为空");
            throw new Exception("子订单不能为空");
        }
        String orderArray[] = orders.split("\\|");
        if (orderArray.length % 4 != 0) {// 如果除以5余数不为0
            log.info("子订单数据错误");
            throw new Exception("子订单数据错误");
        }
        List<PayOrderSubDto> payOrderSubDtoList = new ArrayList<PayOrderSubDto>();
        for (int i = 0; i < orderArray.length; i = i + 4) {
            PayOrderSubDto payOrderSubDto = new PayOrderSubDto();
            payOrderSubDto.setVendor_id(orderArray[i]);
            payOrderSubDto.setOrder_id(orderArray[i + 1]);
            payOrderSubDto.setMoney(orderArray[i + 2]);
            payOrderSubDto.setReturnCode(orderArray[i + 3]);
            payOrderSubDtoList.add(payOrderSubDto);
        }
        payOrderInfoDto.setPayOrderSubDtoList(payOrderSubDtoList);
    }

    private String getPhone(HttpSession session) {
        Object userinfo = session.getAttribute("userinfo");
        String phone = "";
        Map mapAttr = new HashMap();
        if (userinfo != null) {
            mapAttr = (HashMap) userinfo;
            phone = (String) mapAttr.get("cust_mobile_phone");
        } else {
        }
        return phone;
    }

    /**
     * 返回s的trim值，如果s为空，则返回空
     *
     * @param s
     */
    public static String getTrimValue(String s) {
        if (s == null) {
            return null;
        } else {
            return s.trim();
        }
    }
}
