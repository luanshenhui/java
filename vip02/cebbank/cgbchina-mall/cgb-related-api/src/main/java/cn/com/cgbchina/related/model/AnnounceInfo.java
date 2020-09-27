package cn.com.cgbchina.related.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.Date;

/**
 * Created by 11141021040453 on 16-4-13.
 */
public class AnnounceInfo implements Serializable {

	private static final long serialVersionUID = 8300270305117405486L;

	@Getter
	@Setter
	private String topic;// 名称

	@Getter
	@Setter
	private Date time;// 发布时间

	@Getter
	@Setter
	private String content;// 内容
}
