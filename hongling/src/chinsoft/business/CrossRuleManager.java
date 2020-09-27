package chinsoft.business;

import java.util.List;

import org.hibernate.Query;

import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.entity.CrossRule;

public class CrossRuleManager {

	private static List<CrossRule> rules = null;
	
	@SuppressWarnings("unchecked")
	public List<CrossRule> getCrossRules()
    {
    	try {
    		if(rules == null){		
    			Query query = DataAccessObject.openSession().createQuery("FROM CrossRule");
    			rules=query.list();
    		}
			
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	return rules;
    }
}