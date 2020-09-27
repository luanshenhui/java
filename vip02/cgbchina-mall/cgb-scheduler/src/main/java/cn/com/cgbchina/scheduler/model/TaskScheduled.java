package cn.com.cgbchina.scheduler.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
import java.util.Date;

/**
 * 计划任务信息
 * 
 */

@Getter
@Setter
@ToString
public class TaskScheduled implements Serializable {

	private static final long serialVersionUID = -9051690177769272813L;
	/** 任务id */
	private String id;
	/** 任务名称 */
	private String taskName;
	/** 任务分组 */
	private String taskGroup;
	/** 任务状态 0禁用 1启用 2删除 */
	private String status;
	/** 任务运行时间表达式 */
	private String taskCron;
	/** 最后一次执行时间 */
	private Date previousFireTime;
	/** 下次执行时间 */
	private Date nextFireTime;
	/** 任务描述 */
	private String desc;
	/** 任务类型 */
	private String taskType;
	/** 活动开始时间*/
	private Date promotionStartDate;
	private String[] paramArgs;
	/** 活动ID*/
	private String promotionId;
	/** 活动场次ID*/
	private String periodId;
}
