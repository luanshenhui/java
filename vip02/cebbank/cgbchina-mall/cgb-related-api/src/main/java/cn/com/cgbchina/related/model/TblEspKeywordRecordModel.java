package cn.com.cgbchina.related.model;

import lombok.Getter;
import lombok.Setter;
import java.io.Serializable;

public class TblEspKeywordRecordModel implements Serializable {

	private static final long serialVersionUID = 1519154157373429559L;
	@Getter
	@Setter
	private Long id;// 自增主键
	@Getter
	@Setter
	private String keyWords;// 关键字
	@Getter
	@Setter
	private String ordertypeId;// 业务类型代码yg：广发jf：积分
	@Getter
	@Setter
	private String sourceId;// 搜索渠道代码
	@Getter
	@Setter
	private String createOper;// 创建人
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
}