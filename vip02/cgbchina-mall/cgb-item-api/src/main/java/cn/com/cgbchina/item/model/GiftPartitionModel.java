package cn.com.cgbchina.item.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by 11150221040129 on 16-4-12.
 */
public class GiftPartitionModel implements Serializable {

	private static final long serialVersionUID = 2829157706276395773L;
	@Getter
	@Setter
	private Long partitionId;
	@Getter
	@Setter
	private String partitionName;
	@Getter
	@Setter
	private Long order;
	@Getter
	@Setter
	private String pointsType;
	@Getter
	@Setter
	private String cardId;
	@Getter
	@Setter
	private String releaseState;
	@Getter
	@Setter
	private String nowState;
	@Getter
	@Setter
	private String remarkPartition;

}
