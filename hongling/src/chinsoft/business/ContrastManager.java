package chinsoft.business;

import java.util.List;

import org.hibernate.Query;

import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.entity.Contrast;

public class ContrastManager {

	private static List<Contrast> contrasts = null;
	
	@SuppressWarnings("unchecked")
	public List<Contrast> getContrasts()
    {
    	try {
    		if(contrasts == null){		
    			Query query = DataAccessObject.openSession().createQuery("FROM Contrast");
    			contrasts=query.list();
    		}
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	return contrasts;
    }
}