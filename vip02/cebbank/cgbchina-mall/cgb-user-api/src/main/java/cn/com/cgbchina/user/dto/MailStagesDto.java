package cn.com.cgbchina.user.dto;

import cn.com.cgbchina.user.model.MailStagesModel;
import cn.com.cgbchina.user.model.StageRateModel;

import java.io.Serializable;
import java.util.List;

/**
 * Created by niufw on 16-4-25.
 */
public class MailStagesDto implements Serializable {
	private static final long serialVersionUID = -2968786071297055399L;
	private List<MailStagesModel> mailStagesModelList;

	public List<MailStagesModel> getMailStagesModelList() {
		return mailStagesModelList;
	}

	public void setMailStagesModelList(List<MailStagesModel> mailStagesModelList) {
		this.mailStagesModelList = mailStagesModelList;
	}
}
