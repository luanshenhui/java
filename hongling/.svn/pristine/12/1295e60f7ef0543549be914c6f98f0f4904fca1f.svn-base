package chinsoft.business;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;

import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.ClothingBodyType;
import chinsoft.entity.Dict;
import chinsoft.entity.SizeStandard;

public class SizeManager{
   
	DataAccessObject dao = new DataAccessObject();
	public List<SizeStandard> getValidSizeStandard(List<SizeStandard> sizeStandards, String strTempComponentIDs) {
		List<SizeStandard> validSizeStandards = new ArrayList<SizeStandard>();
		/*for(SizeStandard sizeStandard :sizeStandards){
			if(StringUtils.isNotEmpty(sizeStandard.getPleatID())){
				String[] pleats = Utility.getStrArray(sizeStandard.getPleatID());
				for(String pleat:pleats){
					if(Utility.contains(strTempComponentIDs, pleat)){
						validSizeStandards.add(sizeStandard);
					}
				}
			}else if(!"3029".equals(sizeStandard.getPleatID())){
				validSizeStandards.add(sizeStandard);
			}
		}*/
		String pleatID="3029";//短袖
		for(SizeStandard sizeStandard :sizeStandards){
			if(StringUtils.isNotEmpty(sizeStandard.getPleatID())){
				String[] pleats = Utility.getStrArray(sizeStandard.getPleatID());
				for(String pleat:pleats){
					if(Utility.contains(strTempComponentIDs, pleat) && "3029".equals(pleat)){
						pleatID="3028";//长袖
					}
				}
			}
		}
		for(SizeStandard sizeStandard :sizeStandards){
			 if(!pleatID.equals(sizeStandard.getPleatID())){
				 validSizeStandards.add(sizeStandard);
			 }
		}
		return validSizeStandards;
	}
    public List<Dict> getSizeCategory(Integer nClothingID){
    	List<Dict> dicts = DictManager.getDicts(CDictCategory.SizeCategory.getID());
    	int nGroupId = CurrentInfo.getCurrentMember().getGroupID();
    	if(CDict.ClothingPeiJian.getID().equals(nClothingID)){
    		if(dicts.size()>2){
//    			dicts.remove(2);//配件去掉标准号
    			//配件去掉净体量体、标准号
    			dicts.remove(0);
    			dicts.remove(1);
    		}
    	}
    	if(CDict.GROUPID_C == nGroupId){//C账号只保留标准号
    		dicts.remove(1);
    		dicts.remove(0);
    	}else{
    		if(CDict.ClothingDaYi.getID().equals(nClothingID)){
        		if(dicts.size()>2){//大衣去掉标准号
        			dicts.remove(2);
        		}
        	}
    		if(CDict.ClothingSuit2PCS_LFXK.getID().equals(nClothingID) || CDict.ClothingLF.getID().equals(nClothingID) || 
    				CDict.ClothingNXF.getID().equals(nClothingID) || CDict.ClothingNXK.getID().equals(nClothingID)
    				|| CDict.ClothingSuit2PCS_W2PCS.getID().equals(nClothingID)){
        		if(dicts.size()>2){//只保留净体量体
        			dicts.remove(2);
        			dicts.remove(1);
        		}
        	}
    	}
    	return dicts;
    }

    public List<ClothingBodyType> getClotingBodyType(int nClothingID, int nSizeCategoryID){
    	List<ClothingBodyType> list = new ArrayList<ClothingBodyType>();
    	if(nClothingID != 5000){
    		Dict dictClothing = DictManager.getDictByID(nClothingID);
        	String[] bodyTypeIDs = Utility.getStrArray(this.getStrValueBySizeCategory(nSizeCategoryID, dictClothing.getBodyType()));
        	for(String bodyTypeID:bodyTypeIDs ){
        		ClothingBodyType bodyType = new ClothingBodyType();
        		bodyType.setCategoryID(Utility.toSafeInt(bodyTypeID));
        		bodyType.setCategoryName(DictCategoryManager.getDictCategoryNameByID(Utility.toSafeInt(bodyTypeID)));
        		bodyType.setBodyTypes(DictManager.getDicts(Utility.toSafeInt(bodyTypeID)));
        		list.add(bodyType);
        	}
    	}
    	return list;
    } 
    /**
     * 查特体信息的着装风格
     * @param nClothingID
     * @param nSizeCategoryID
     * @return
     */
    public List<ClothingBodyType> getClothingStyles(int nClothingID, int nSizeCategoryID){
    	Dict dictClothing = DictManager.getDictByID(nClothingID);
    	String[] bodyTypeIDs = Utility.getStrArray(this.getStrValueBySizeCategory(nSizeCategoryID, dictClothing.getBodyType()));
    	
    	List<ClothingBodyType> list = new ArrayList<ClothingBodyType>();
    	for(String bodyTypeID:bodyTypeIDs ){
    		if(bodyTypeID.equals("32")){
	    		ClothingBodyType bodyType = new ClothingBodyType();
	    		bodyType.setCategoryID(Utility.toSafeInt(bodyTypeID));
	    		bodyType.setCategoryName(DictCategoryManager.getDictCategoryNameByID(Utility.toSafeInt(bodyTypeID)));
	    		bodyType.setBodyTypes(this.getDict(nClothingID,Utility.toSafeInt(bodyTypeID)));
	    		bodyType.setClothName(dictClothing.getName());
	    		list.add(bodyType);
    		}
    	}
    	return list;
    }
    
    private List<Dict> getDict(int nClothingID,int nCategoryID){
    	List<Dict> dicts = new ArrayList<Dict>();
    	StringBuffer hql = new StringBuffer("From Dict t where t.CategoryID = '32' and t.Extension like '%"+nClothingID+"%'");
    	dicts = DataAccessObject.openSession().createQuery(hql.toString()).list();
		return dicts;
    }
    
    
    private String getStrValueBySizeCategory(int nSizeCategoryID, String strBodyTypes){
    	//nSizeCategoryID = 10052 OR 10053
    	//str = "10052[10061,10062]|10053[10061,10064]"
    	//返回值= 如果是10052 就是 10061，10062，如果是10053 就是 10061，10064
    	String[] bodyTypes=strBodyTypes.split("\\|");
    	for (String bodyType : bodyTypes) {
    		String[] strParts=bodyType.split("\\[");
    		if(strParts[0].equals(Utility.toSafeString(nSizeCategoryID))){
    			return strParts[1].split("\\]")[0];
    		}
		}
    	return "";
    }
	 @SuppressWarnings("rawtypes")
    public List<Dict> getArea(int nClothingID, int nSizeCategoryID){
		int nSingleClothingID = getFirstSingleClothingID(nClothingID);
    	List<Dict> dicts = new ArrayList<Dict>();;
    	try {
    	 String hql="SELECT DISTINCT AreaID FROM SizeStandard WHERE SingleClothingID=:SingleClothingID AND SizeCategoryID=:SizeCategoryID ORDER BY AreaID";
       	 Query query= DataAccessObject.openSession().createQuery(hql);
       	 query.setInteger("SingleClothingID", nSingleClothingID);
       	 query.setInteger("SizeCategoryID", nSizeCategoryID);
       	
		 List list= query.list();
       	 
       	 if(list != null&& list.size()>0){
       		for ( Object areaID : list) {
          		 Dict dict = DictManager.getDictByID(Utility.toSafeInt(areaID));
          		 if(dict != null){
          			dicts.add(dict); 
          		 }
          	 }
       	 }
       	 
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	return sortDicts(dicts);
    }
	 
	private List<Dict> sortDicts(List<Dict> dicts){
		 for (int k = 0; k < dicts.size(); k++){     
           for (int j = dicts.size() - 1; j > k; j--)     
            {     
                Dict dict_1 = (Dict)dicts.get(j);  
                Dict dict_2 = (Dict)dicts.get(j-1);  
                if (dict_1.getSequenceNo()<dict_2.getSequenceNo())     
                 {     
                     final Dict temp = dict_2;     
                     dicts.remove(j - 1);     
                     dicts.add(j - 1, dict_1);     
                     dicts.remove(j);     
                     dicts.add(j, temp);  
                 }     
             }     
        }    
		 return dicts;
	}
	
	
    @SuppressWarnings({ "unchecked" })
	public String getSpecHeight(int nClothingID, int nAreaID, String strTempComponentIDs){
    	int nSingleClothingID = getFirstSingleClothingID(nClothingID);
	    String strHeight="";
    	try {
    		String hql="FROM SizeStandard WHERE SingleClothingID=:SingleClothingID AND AreaID=:AreaID ORDER BY ID,SpecHeight" ;
    		Query query=DataAccessObject.openSession().createQuery(hql);
    		query.setInteger("SingleClothingID", nSingleClothingID);
    		query.setInteger("AreaID", nAreaID);
    		List<SizeStandard> list= query.list();
    		List<SizeStandard> valids = this.getValidSizeStandard(list, strTempComponentIDs);

    		for (SizeStandard sizeStandard : valids) {
    			if(StringUtils.isNotEmpty(sizeStandard.getSpecHeight())){
    				if(!Utility.contains(strHeight, sizeStandard.getSpecHeight())){
    					strHeight += sizeStandard.getSpecHeight() +",";
    				}
    			}
			}
    		if(strHeight.endsWith(",")){
    			strHeight.substring(0, strHeight.length()-1);
    		}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	return strHeight.toString();
    }
    
    @SuppressWarnings("unchecked")
	public String getSpecChest(int nSingleClothingID, int nAreaID, String strSpecHeight, String strTempComponentIDs){
	    String strChest = "";
    	try {
    		String hql="FROM SizeStandard WHERE SingleClothingID=:SingleClothingID AND AreaID=:AreaID AND SpecHeight=:SpecHeight  ORDER BY SpecChest" ;
    		Query query=DataAccessObject.openSession().createQuery(hql);
    		query.setInteger("SingleClothingID", nSingleClothingID);
    		query.setInteger("AreaID", nAreaID);
    		query.setString("SpecHeight", strSpecHeight);
    		List<SizeStandard> list= (List<SizeStandard>)query.list();
    		List<SizeStandard> valids = this.getValidSizeStandard(list, strTempComponentIDs);
    		for (SizeStandard sizeStandard : valids) {
    			if(StringUtils.isNotEmpty(sizeStandard.getSpecChest())){
    				if(!Utility.contains(strChest, sizeStandard.getSpecChest())){
    					strChest += sizeStandard.getSpecChest() +",";
    				}
    			}
			}
    		if(strChest.endsWith(",")){
    			strChest.substring(0, strChest.length()-1);
    		}
    		
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
    	return strChest;
    }

    private int getFirstSingleClothingID(int nClothingID) {
		int nSingleClothing = nClothingID;
		List<Dict> singleClothings = new ClothingManager().getSingleClothings(nClothingID);
		if(singleClothings.size() > 0){
			nSingleClothing = singleClothings.get(0).getID();
		}
		return nSingleClothing;
	}   

    @SuppressWarnings("unchecked")
	public List<SizeStandard> getSizeStandard(int nSingleClothingID, int nSizeCategoryID, int nAreaID, String strSpecHeight,String strSpecChest, Integer nUnitID){
    	nSingleClothingID = this.getFirstSingleClothingID(nSingleClothingID);
    	List<SizeStandard> sizeStandards=new ArrayList<SizeStandard>();
    	try {
    		String hql="FROM SizeStandard WHERE SingleClothingID= :SingleClothingID AND SizeCategoryID= :SizeCategoryID ";
    		if(nAreaID!=-1){
    			hql+=" AND AreaID= :AreaID ";
    		}
    		if(StringUtils.isNotEmpty(strSpecHeight) && !"undefined".equals(strSpecHeight)){
    			hql+=" AND SpecHeight= :SpecHeight ";
    		}
    		if(StringUtils.isNotEmpty(strSpecChest) && !"undefined".equals(strSpecChest)){
    			hql+=" AND SpecChest= :SpecChest ";
    		}
    		hql += " ORDER BY SequenceNo ";
        	Query query=DataAccessObject.openSession().createQuery(hql);
        	
        	query.setInteger("SingleClothingID", nSingleClothingID);
        	query.setInteger("SizeCategoryID", nSizeCategoryID);
        	
        	if(nAreaID!=-1){
        		query.setInteger("AreaID", nAreaID);
    		}
        	
        	if(StringUtils.isNotEmpty(strSpecHeight) && !"undefined".equals(strSpecHeight)){
            	query.setString("SpecHeight", strSpecHeight);
    		}
        	if(StringUtils.isNotEmpty(strSpecChest) && !"undefined".equals(strSpecChest)){
            	query.setString("SpecChest", strSpecChest);
    		}

        	sizeStandards=query.list();
        	for (SizeStandard sizeStandard : sizeStandards) {
        		extendSizeStandard(nUnitID, sizeStandard);
			}
		} catch (Exception e) {
		}finally{
			DataAccessObject.closeSession();
		}
    	return sizeStandards;
    }
    
    @SuppressWarnings("unchecked")
	public List<SizeStandard> getSizeStandardByGroup(int nSizeStandardID, int nUnitID){
    	List<SizeStandard> sizeStandards=new ArrayList<SizeStandard>();
    	try {
    		SizeStandard currentSizeStandard = this.getSizeStandardByID(nSizeStandardID, nUnitID);
    		
    		String hql="FROM SizeStandard WHERE GroupID = :GroupID AND ID <> :CurrentSizeStandardID ";

        	Query query=DataAccessObject.openSession().createQuery(hql);
        	
        	query.setInteger("GroupID", currentSizeStandard.getGroupID());
        	query.setInteger("CurrentSizeStandardID", currentSizeStandard.getID());

			sizeStandards=query.list();
        	for (SizeStandard sizeStandard : sizeStandards) {
        		extendSizeStandard(nUnitID, sizeStandard);
			}
		} catch (Exception e) {
		}finally{
			DataAccessObject.closeSession();
		}
    	return sizeStandards;
    }

	private void extendSizeStandard(int nUnitID, SizeStandard sizeStandard) {
		sizeStandard.setPartName(DictManager.getDictNameByID(sizeStandard.getPartID()));
		if(CDict.UnitInch.getID().equals(nUnitID)){
			if(StringUtils.isNotEmpty(Utility.toSafeString(sizeStandard.getDefaultValue()))){	
				sizeStandard.setDefaultValue(Utility.cmToInch(sizeStandard.getDefaultValue()));
			}
			if(StringUtils.isNotEmpty(Utility.toSafeString(sizeStandard.getSizeFrom()))){       	  			
				sizeStandard.setSizeFrom(Utility.cmToInch(sizeStandard.getSizeFrom()));
			}
			if(StringUtils.isNotEmpty(Utility.toSafeString(sizeStandard.getSizeTo()))){       			
				sizeStandard.setSizeTo(Utility.cmToInch(sizeStandard.getSizeTo()));
			}
			if(StringUtils.isNotEmpty(Utility.toSafeString(sizeStandard.getRangeStart()))){       			
				sizeStandard.setRangeStart(Utility.cmToInch(sizeStandard.getRangeStart()));
			}
			if(StringUtils.isNotEmpty(Utility.toSafeString(sizeStandard.getRangeStep()))){       			
				sizeStandard.setRangeStep(Utility.cmToInch(sizeStandard.getRangeStep()));
			}
		}
	}
    
    public SizeStandard getSizeStandardByID(Integer sizeStandardID,int nUnitID) {
    	SizeStandard sizeStandard = (SizeStandard) dao.getEntityByID(SizeStandard.class, sizeStandardID);
    	this.extendSizeStandard(nUnitID, sizeStandard);
		return sizeStandard;
	}
}