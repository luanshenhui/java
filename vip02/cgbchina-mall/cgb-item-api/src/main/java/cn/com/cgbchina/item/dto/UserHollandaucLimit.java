package cn.com.cgbchina.item.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by 1115012105001 on 2016/10/31.
 */
public class UserHollandaucLimit implements Serializable {

    private static final long serialVersionUID = 7834098888170350533L;
    @Setter
	@Getter
	private Integer ruleLimitTicket;//可拍次数
	@Setter
	@Getter
	private Integer userHollandaucLimit;//出手次数
    @Setter
    @Getter
    private Integer remainingTicket;//剩余出手次数

    public UserHollandaucLimit() {
    }
    public UserHollandaucLimit(Integer ruleLimitTicket,Integer userHollandaucLimit){
        this.ruleLimitTicket=ruleLimitTicket;
        this.userHollandaucLimit=userHollandaucLimit;
        this.remainingTicket=remainingTicket();

    }

    /**
     *获取剩余出手次数
     */
    public Integer remainingTicket(){
        Integer remain=ruleLimitTicket-userHollandaucLimit;
        return remain>=0?remain:0;
    }
}
