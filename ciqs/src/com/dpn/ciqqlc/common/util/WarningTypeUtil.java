/*package com.dpn.ciqqlc.common.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import com.dpn.ciqqlc.http.form.WarningLinkRuleForm;
import com.dpn.ciqqlc.standard.service.WarningLinkRuleService;
@Component
public class WarningTypeUtil {
	@Autowired
	@Qualifier("warningLinkRuleService")
	private WarningLinkRuleService warningLinkRuleService;
	
	private static WarningTypeUtil instance = new WarningTypeUtil();
	
	//增加spring注入
	public static WarningTypeUtil warningTypeUtil;
	
	@PostConstruct
	public void init() {
		warningTypeUtil = this;
	}
	
	
	Map<String , WarningLinkRuleForm> rules = new HashMap<String , WarningLinkRuleForm>();
	List<WarningLinkRuleForm> list = new ArrayList<WarningLinkRuleForm>();
	
	private WarningTypeUtil (){
		try {
			this.list = warningTypeUtil.warningLinkRuleService.findBillList(new WarningLinkRuleForm());
			System.out.println(1);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static WarningTypeUtil getInstance () {
		return instance;
	}

	public Map<String, WarningLinkRuleForm> getRules() {
		return rules;
	}

	public void setRules(Map<String, WarningLinkRuleForm> rules) {
		this.rules = rules;
	}

	public List<WarningLinkRuleForm> getList() {
		return list;
	}

	public void setList(List<WarningLinkRuleForm> list) {
		this.list = list;
	}
	
	
}
*/