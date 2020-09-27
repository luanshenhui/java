package cn.com.cgbchina.trade.service;

import com.spirit.common.model.Response;

import java.util.Map;

/**
 * Created by shangqinbin on 2016/7/15.
 */
public interface SmsMessageService {
    /**
     * 乐购成功购买的短信
     *
     * @param amountall
     * @param amountsuc
     * @param mobilePhone
     * @return
     */
    public Response<Boolean> sendLGSucess(int amountall, int amountsuc, String mobilePhone);

    /**
     * 乐购购买失败的短信
     *
     * @param product
     * @param mobilePhone
     * @return
     */
    public Response<Boolean> sendLGErr(int product, String mobilePhone);

    /**
     * 积分短信
     *
     * @param totalBonus
     * @param totalPrice
     * @param mobilePhone
     * @return
     */
    public Response<Boolean> sendJFSMSMessage(long totalBonus, double totalPrice, String mobilePhone, String messageFlag);

    /**
     *072FH00013
     */
    public Response<Map> sendMsg(Map map);

    /**
     * 优惠券不匹配短信
     * @param mobilePhone
     * @return
     */
    public boolean sendConponMsg(String mobilePhone);
    
    /**
	 * 资格客户但时间过期短信
	 * @param mobilePhone
	 * @return
	 */
    public Response<Boolean> sendOverDueMsg(String mobilePhone);
}
