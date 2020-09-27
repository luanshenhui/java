package chinsoft.business;

import java.util.List;

import org.hibernate.Query;

import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.entity.ComponentPageSize;

public class ComponentPageSizeManager {

	private static List<ComponentPageSize> pageSizes = null;
	@SuppressWarnings("unchecked")
	public List<ComponentPageSize> getComponentPageSizes()
    {
    	try {
    		if(pageSizes == null){		
				Query query = DataAccessObject.openSession().createQuery("FROM ComponentPageSize");
    			pageSizes=query.list();
    		}
    	} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	return pageSizes;
    }
	
	public ComponentPageSize getComponentPageSizeByID(Integer nID){
		List<ComponentPageSize> componentPageSizes = this.getComponentPageSizes();
		for(ComponentPageSize componentPageSize:componentPageSizes){
			if(componentPageSize.getID().equals(nID)){
				return componentPageSize;
			}
		}
		return null;
	}
}