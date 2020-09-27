package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class TblMakecheckjobHistoryModel implements Serializable {

	private static final long serialVersionUID = 4243273222067222680L;
	@Getter
	@Setter
	private Long id;// 自增主键
	@Getter
	@Setter
	private String ope;// 操作员
	@Getter
	@Setter
	private String opedate;// 操作日期
	@Getter
	@Setter
	private String opetime;// 操作时间
	@Getter
	@Setter
	private String ip;// 操作员ip
	@Getter
	@Setter
	private java.util.Date date;// 对账文件日期
	@Getter
	@Setter
	private String result;// 对账结果
	@Getter
	@Setter
	private String resultdesc;// 对账结果描述
	@Getter
	@Setter
	private String desc;// 详细描述
	@Getter
	@Setter
	private String isshoudong;// 是否手动标识
	@Getter
	@Setter
	private String isrenew;// 是否补发标识
}