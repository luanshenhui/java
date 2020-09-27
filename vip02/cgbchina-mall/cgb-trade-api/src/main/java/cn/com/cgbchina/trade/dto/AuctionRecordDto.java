package cn.com.cgbchina.trade.dto;

import java.io.Serializable;
import java.util.List;

import cn.com.cgbchina.trade.model.AuctionRecordModel;
import lombok.Getter;
import lombok.Setter;

/**
 * Created by Congzy
 */
public class AuctionRecordDto implements Serializable {

	private static final long serialVersionUID = -3060423609214592896L;

	@Setter
	@Getter
	private Integer countNum;

	@Setter
	@Getter
	private List<AuctionRecordModel> auctionRecordList;

	@Setter
	@Getter
	private String urlStrBuffer;
}
