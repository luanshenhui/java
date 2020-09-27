package chinsoft.business;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Paypal {
	AlipayConfig pay = new AlipayConfig();
	//给paypal充值
	public String Charge(String strOrdenId ,String strFee){
		Map<String, String> sParaTemp = new HashMap<String, String>();
		sParaTemp.put("item_name", pay.item_name);
		sParaTemp.put("item_number", strOrdenId);
		sParaTemp.put("amount", strFee);
		sParaTemp.put("cmd", pay.cmd);
		sParaTemp.put("business", pay.business);   
		sParaTemp.put("currency_code", pay.currency_code);
		sParaTemp.put("cancel_return", pay.cancel_return);
		sParaTemp.put("notify_url", pay.paypal_notify_url);
//		sParaTemp.put("charset", pay.input_charset);
		
		String strButtonName = "确认";
		
		return this.buildForm(sParaTemp, pay.PAYPAL_URL, "post", strButtonName);
	}

    /**
     * 构造提交表单HTML数据
     * @param sParaTemp 请求参数数组
     * @param gateway 网关地址
     * @param strMethod 提交方式。两个值可选：post、get
     * @param strButtonName 确认按钮显示文字
     * @return 提交表单HTML文本
     */
    public String buildForm(Map<String, String> sParaTemp, String gateway, String strMethod,
                                   String strButtonName) {
        //待请求参数数组
        Map<String, String> sPara = this.buildRequestPara(sParaTemp);
        List<String> keys = new ArrayList<String>(sPara.keySet());
        StringBuffer sbHtml = new StringBuffer();
        sbHtml.append("<form id=\"alipaysubmit\" name=\"alipaysubmit\" action=\"" + gateway
                      + "\" method=\"" + strMethod + "\">");
        for (int i = 0; i < keys.size(); i++) {
            String name = (String) keys.get(i);
            String value = (String) sPara.get(name);
            sbHtml.append("<input type=\"hidden\" name=\"" + name + "\" value=\"" + value + "\"/>");
        }
        //submit按钮控件请不要含有name属性
        sbHtml.append("<input type=\"submit\" value=\"" + strButtonName + "\" style=\"display:none;\"></form>");
        sbHtml.append("<script>document.forms['alipaysubmit'].submit();</script>");
        return sbHtml.toString();
        
    }
    
    /**
     * 生成要请求给支付宝的参数数组
     * @param sParaTemp 请求前的参数数组
     * @return 要请求的参数数组
     */
    private Map<String, String> buildRequestPara(Map<String, String> sParaTemp) {
        //除去数组中的空值
        Map<String, String> sPara = this.paraFilter(sParaTemp);
        return sPara;
    }
    
    /** 
     * 除去数组中的空值
     * @param sArray 
     * @return 去掉空值
     */
    public Map<String, String> paraFilter(Map<String, String> sArray) {

        Map<String, String> result = new HashMap<String, String>();
        if (sArray == null || sArray.size() <= 0) {
            return result;
        }
        for (String key : sArray.keySet()) {
            String value = sArray.get(key);
            if (value == null || value.equals("")) {
                continue;
            }
            result.put(key, value);
        }
        return result;
    }
    
}
