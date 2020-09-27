package com.dpn.ciqqlc.common.util;

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
public class LazySingleton {
	@Autowired
	@Qualifier("warningLinkRuleService")
	private WarningLinkRuleService warningLinkRuleService;
	
	 private static LazySingleton intance = null;
	    
	    private LazySingleton()
	    {
			try {
				this.list = warningTypeUtil.warningLinkRuleService.findBillList(new WarningLinkRuleForm());
				for (WarningLinkRuleForm m: list) {
					if (rules.containsKey(m.getBusinessType())) {
						rules.get(m.getBusinessType()).add(m);
					} else {
						List<WarningLinkRuleForm> list = new ArrayList<WarningLinkRuleForm>();
						list.add(m);
						rules.put(m.getBusinessType(), list);
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
	    }
	    
	    public static synchronized LazySingleton getInstance()    
	    {
	        if(intance == null)
	        {
	            intance = new LazySingleton();
	        }
	        return intance;
	    }
	    
	    
	    //private static LazySingleton instance = new LazySingleton();
		
		//增加spring注入
		public static LazySingleton warningTypeUtil;
		
		@PostConstruct
		public void init() {
			warningTypeUtil = this;
		}
		
		
		Map<String , List<WarningLinkRuleForm>> rules = new HashMap<String , List<WarningLinkRuleForm>>();
		List<WarningLinkRuleForm> list = new ArrayList<WarningLinkRuleForm>();
		

		public Map<String, List<WarningLinkRuleForm>> getRules() {
			return rules;
		}

		public void setRules(Map<String, List<WarningLinkRuleForm>> rules) {
			this.rules = rules;
		}

		public List<WarningLinkRuleForm> getList() {
			return list;
		}

		public void setList(List<WarningLinkRuleForm> list) {
			this.list = list;
		}
}
