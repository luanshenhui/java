package com.letv;

import com.letv.account.AccountRequest;
import com.letv.account.AccountResponse;
import com.letv.common.LevpUtils;
import com.letv.order.OrderRequest;
import com.letv.order.OrderResponse;
import com.letv.token.TokenRequest;
import com.letv.token.TokenResponse;

public class LevpClient {

	LevpUtils levpUtils = new LevpUtils();

	public LevpClient(String url, String channel, String api_secret) {
		levpUtils.setUrl(url);
		levpUtils.setChannel(channel);
		levpUtils.setApi_secret(api_secret);
	}

	//获取Token
	public TokenResponse GetToken() {
		try {
			TokenRequest req = new TokenRequest();
			TokenResponse rsp = req.DoPost(levpUtils);
			return rsp;
		} catch (Exception ex) {
			com.letv.common.LoggerUtil.ErrorException(ex);
			return null;
		}
	}

	//充值接口
	public OrderResponse GenOrder(String token, String open_id,
								  String channel_order_id, String channel_order_amount,
								  String months, String type) {
		try {
			OrderRequest req = new OrderRequest();
			OrderResponse rsp = req.DoPost(levpUtils, token, open_id,
					channel_order_id, channel_order_amount, months, type);
			return rsp;
		} catch (Exception ex) {
			com.letv.common.LoggerUtil.ErrorException(ex);
			return null;
		}
	}

	//查询渠道乐视用户
	public AccountResponse GetAccount(String token, String account) {
		try {
			AccountRequest req = new AccountRequest();
			AccountResponse rsp = req.GetAccount(levpUtils, account, token);
			return rsp;
		} catch (Exception ex) {
			com.letv.common.LoggerUtil.ErrorException(ex);
			return null;
		}
	}

}
