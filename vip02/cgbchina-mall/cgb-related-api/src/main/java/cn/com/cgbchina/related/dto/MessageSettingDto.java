package cn.com.cgbchina.related.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by yuxinxin on 16-4-25.
 */
public class MessageSettingDto implements Serializable {
    private static final long serialVersionUID = 7076523564261704366L;
    @Getter
	@Setter
	private Long mallId;// 商城公告显示开关

	@Getter
	@Setter
	private Long messageId;// 短信开关

	@Getter
	@Setter
	private Long tradeId;// 支付开关

	@Getter
	@Setter
	private String mallOpen;// 是否打开 0：打开 1：关闭

	@Getter
	@Setter
	private String messageOpen;// 是否打开 0：打开 1：关闭

	@Getter
	@Setter
	private String tradeOpen;// 是否打开 0：打开 1：关闭
}
