package cn.com.cgbchina.item.model;

import lombok.Getter;
import lombok.Setter;

import javax.annotation.Nullable;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 * Created by 11150221040129 on 16-4-8.
 */
public class GoodsConsultListModel implements Serializable {

	private static final long serialVersionUID = -6585030014588888130L;
	@Getter
	@Setter
	private GoodsModel goodsModel;

	@Getter
	@Setter
	private List<GoodsConsultModel> goodsConsultModelList;

}
