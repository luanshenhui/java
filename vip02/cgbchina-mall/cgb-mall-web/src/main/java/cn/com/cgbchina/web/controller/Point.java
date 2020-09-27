/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.web.controller;

import cn.com.cgbchina.rest.visit.model.point.QueryPointsInfo;
import cn.com.cgbchina.rest.visit.model.point.QueryPointsInfoResult;
import cn.com.cgbchina.trade.service.OrderService;
import com.spirit.user.User;
import com.spirit.user.UserAccount;
import com.spirit.user.UserUtil;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.*;

@Controller
@RequestMapping("/api/mall/point")
@Slf4j
public class Point {
    @Autowired
    private OrderService orderService;

    /**
     * 查询积分
     *
     * @return List<QueryPointsInfoResult>
     */
    @RequestMapping(value = "/getPoint", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<QueryPointsInfoResult> getPoint(@RequestBody  QueryPointsInfo info) {
        String cardNo = "";
        if (info != null){
            User user = UserUtil.getUser();
            cardNo = info.getCardNo();
            if (StringUtils.isNotEmpty(cardNo)){
                String cardNo1 = cardNo.substring(0, 4) + cardNo.substring(cardNo.length() - 4);
                List<UserAccount> cardNos = user.getAccountList();
                if (!cardNos.isEmpty()){
                    for (UserAccount userAccount : cardNos){
                        String cardNoNew =  userAccount.getCardNo();
                        if (StringUtils.isEmpty(cardNoNew))
                            continue;
                        String cardNoNew1 = cardNoNew.substring(0, 4) + cardNoNew.substring(cardNoNew.length() - 4);
                        if (cardNoNew1.equals(cardNo1)){
                            cardNo = cardNoNew;
                            break;
                        }
                    }
                }
            }
        }
       return orderService.getAmount(cardNo, "0", true);
    }

}
