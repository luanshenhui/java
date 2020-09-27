package hongling.business;

import hongling.entity.FabricTrader;
import hongling.entity.FabricWareroom;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;

import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import chinsoft.business.CurrentInfo;
import chinsoft.business.DictManager;
import chinsoft.business.FabricManager;
import chinsoft.business.XmlManager;
import chinsoft.core.ConfigHelper;
import chinsoft.core.DataAccessObject;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;

@SuppressWarnings("unchecked")
public class FabricWareroomManager {
	
	private String WebService_Erp_Address = Utility.toSafeString(ConfigHelper.getContextParam().get("WebService_Erp_Address"));
	private String WebService_NameSpace = Utility.toSafeString(ConfigHelper.getContextParam().get("WebService_NameSpace"));
	
	public List<FabricTrader> getFabricTraderList(){
		List<FabricTrader> fabricTraders=new ArrayList<FabricTrader>();
		String hql="FROM FabricTrader";
		Query query=DataAccessObject.openSession().createQuery(hql);
		fabricTraders=(List<FabricTrader>)query.list();
		return fabricTraders;
	}
	
	public List<FabricWareroom> getFabricWarerooms(int pageNo,int pageSize,String fabricNo,String property,String brands,String category,String belong,String status){
		List<FabricWareroom> fabricWarerooms=new ArrayList<FabricWareroom>();
		Query query=this.getQuery("f", fabricNo, property, brands, category,belong,status);
		query.setFirstResult(pageNo*pageSize);
		query.setMaxResults(pageSize);
		fabricWarerooms=(List<FabricWareroom>)query.list();
		fabricWarerooms=this.extendFabricWareroom(fabricWarerooms);
		return fabricWarerooms;
		
	}
	public List<FabricWareroom> extendFabricWareroom(List<FabricWareroom> list){
		for(FabricWareroom fw:list){
			extendFabricWareroom(fw);
			fw.setStock(this.getStockByFabricNo(fw.getFabricNo()));
			fw.setDict(DictManager.getDictByID(Utility.toSafeInt(fw.getProperty())));
		}
		return list;
	}
	public void extendFabricWareroom(FabricWareroom fw){
		fw.setColorName(DictManager.getDictNameByID(fw.getColor())==null?"":DictManager.getDictNameByID(fw.getColor()));
		fw.setCategoryName(DictManager.getDictNameByID(fw.getCategory())==null?"":DictManager.getDictNameByID(fw.getCategory()));
		fw.setFlowerName(DictManager.getDictNameByID(fw.getFlower())==null?"":DictManager.getDictNameByID(fw.getFlower()));
		fw.setCompositionName(DictManager.getDictNameByID(fw.getComposition())==null?"":DictManager.getDictNameByID(fw.getComposition()));
		fw.setPropertyName(DictManager.getDictNameByID(Utility.toSafeInt(fw.getProperty()))==null?"":DictManager.getDictNameByID(Utility.toSafeInt(fw.getProperty())));
		fw.setFabricTrader(new FabricTraderManager().getFabricTraderByID(fw.getBrands()));
	}
	public int getCount(String fabricNo,String property,String brands,String category,String belong,String status){
		int count=0;
		Query query=this.getQuery("COUNT(*)", fabricNo, property, brands, category,belong,status);
		count=Utility.toSafeInt(query.uniqueResult());
		return count;
	}
	public Query getQuery(String strchange,String fabricNo,String property,String brands,String category,String belong,String status){
		Query query=null;
		String hql="select "+strchange+" from FabricWareroom f where f.fabricNo like :fabricNo and f.property like :property and f.brands like :brands and f.category like :category and f.belong like :belong and f.status=:status";
		query=DataAccessObject.openSession().createQuery(hql);
		query.setString("fabricNo", "%"+fabricNo+"%");
		query.setString("property", "%"+property+"%");
		query.setString("brands", "%"+brands+"%");
		query.setString("category","%"+category+"%");
		query.setString("belong", "%"+belong+"%");
		query.setString("status", status);
		return query;
	}
	public Double getStockByFabricNo(String fabricNo){
		Double d=0.0;
		try {
			Object[] params = new Object[] {fabricNo};
			d = Utility.toSafeDouble(XmlManager.invokeService(WebService_Erp_Address, WebService_NameSpace, "getFabricStock", params,new Class[]{String.class}));
			d = Utility.toSafeDouble(new java.text.DecimalFormat("#.00").format(d));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return d;
	}
	public void saveFabricWareroom(FabricWareroom fabricWareroom){
		new DataAccessObject().saveOrUpdate(fabricWareroom);
	}
	public FabricWareroom getFabricWareroomByID(String id){
		return (FabricWareroom)new DataAccessObject().getEntityByID(FabricWareroom.class, Utility.toSafeInt(id));
	}
	public String removeFabricWareroom(String ids){
		if (ids.equals("")) {
			return "请选择待删除项";
		}
		Transaction transaction=null;
    	Session session=null;
    	
    	try {
			session= DataAccessObject.openSession();
			transaction=session.beginTransaction();
			String[] IDs = Utility.getStrArray(ids);
			for(Object ID : IDs){
				if(ID!=null&&ID!=""){
					new DataAccessObject().remove(session,FabricWareroom.class, Utility.toSafeInt(ID));
				}
			}
			transaction.commit();
	    	return Utility.RESULT_VALUE_OK;
		} catch (HibernateException e) {
			e.printStackTrace();
			return e.getMessage();
		}
    	finally{
    		DataAccessObject.closeSession();
    	}
	}
	public void changeRate(double rate){
		Session session=DataAccessObject.openSession();
		Transaction tran=session.beginTransaction();
		String sql="UPDATE FABRICWAREROOM SET DOLLAR=round(RMB*?,2)";
		Query query=session.createSQLQuery(sql);
		query.setDouble(0, rate);
		query.executeUpdate();
		tran.commit();
	}
	
	public double getEx(){
		double d=0.00;
		String sql="Select US from CHARGE where ID=1";
		Query query=DataAccessObject.openSession().createSQLQuery(sql);
		d=Double.parseDouble(query.list().get(0).toString());
		return d;
	}
	public double getusEx(){
		double d=0.0;
		String sql="Select CN from CHARGE where ID=1";
		Query query=DataAccessObject.openSession().createSQLQuery(sql);
		d=Double.parseDouble(query.list().get(0).toString());
		return d;
	}
	public void changeEx(double us,double cn){
		Session session=DataAccessObject.openSession();
		Transaction tran=session.beginTransaction();
		String sql="UPDATE CHARGE set US = ?,CN= ? where ID=1";
		Query query=session.createSQLQuery(sql);
		query.setDouble(0, us);
		query.setDouble(1, cn);
		query.executeUpdate();
		tran.commit();
	}
	public List<FabricWareroom> initExcel(String path){
		List<FabricWareroom> fabrics=new ArrayList<FabricWareroom>();
		InputStream inputstream = null;
		Workbook book = null;
		try {
			inputstream=new FileInputStream(path);
			book=Workbook.getWorkbook(inputstream);
			for(int num=0;num<book.getNumberOfSheets();num++){
				Sheet sheet=book.getSheet(num);
				if (sheet == null) {
					continue;
				}
				int row = sheet.getRows();
				FabricWareroom fabricwareroom=null;
				for(int i=1;i<row;i++){
					fabricwareroom=new FabricWareroom();
					//编码
					Cell cell1=sheet.getCell(0, i);
					fabricwareroom.setFabricNo(cell1.getContents()==""?"XXX":cell1.getContents());
					//服装分类
					Cell cell5=sheet.getCell(4, i);
					fabricwareroom.setCategory("大衣".equals(cell5.getContents())?8050:getCategoryIdByName(cell5.getContents()));
					//成分
					Cell cell2=sheet.getCell(1, i);
					fabricwareroom.setComposition(getCompostionByNameAndCatory(cell2.getContents(),"大衣".equals(cell5.getContents())?8050:getCategoryIdByName(cell5.getContents())));
					//纱织
					Cell cell3=sheet.getCell(2, i);
					fabricwareroom.setShazhi(cell3.getContents());
					//克重
					Cell cell4=sheet.getCell(3, i);
					fabricwareroom.setWeight(Utility.toSafeDouble(cell4.getContents()));
					//花型
					Cell cell6=sheet.getCell(5, i);
					fabricwareroom.setFlower(getFlowerByNameAndCatory(cell6.getContents(),"大衣".equals(cell5.getContents())?8050:getCategoryIdByName(cell5.getContents())));
					//色系
					Cell cell7=sheet.getCell(6, i);
					fabricwareroom.setColor(getColorByNameAndCatory(cell7.getContents(),"大衣".equals(cell5.getContents())?8050:getCategoryIdByName(cell5.getContents())));
					//属性
					Cell cell8=sheet.getCell(7, i);
					fabricwareroom.setProperty(getPropertyByNameAndCotory(cell8.getContents(), "大衣".equals(cell5.getContents())?8050:getCategoryIdByName(cell5.getContents())));
					//rmb
					Cell cell9=sheet.getCell(8, i);
					fabricwareroom.setRmb(Utility.toSafeDouble(cell9.getContents()));
					//dollar
					fabricwareroom.setDollar(Utility.toSafeDouble(cell9.getContents())*(getEx()));
					//产地 地址
					Cell cell10=sheet.getCell(9, i);
					fabricwareroom.setAddress(cell10.getContents());
					//单位
					Cell cell11=sheet.getCell(10, i);
					fabricwareroom.setBelong(cell11.getContents());
					//状态
					Cell cell12=sheet.getCell(11, i);
					if("0".equals(cell12.getContents())){
						fabricwareroom.setStatus(10050);
					}
					else
					{
						fabricwareroom.setStatus(10051);
					}
					//品牌
					Cell cell13=sheet.getCell(12, i);
					fabricwareroom.setBrands(getBrandIdByVabrictrader(cell13.getContents())==null?"":Utility.toSafeString(getBrandIdByVabrictrader(cell13.getContents()).getId()));
					fabricwareroom.setCreateBy(CurrentInfo.getCurrentMember().getUsername());
					//创建时间
					fabricwareroom.setCreateTime(new Date());
					fabrics.add(fabricwareroom);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return fabrics;
	}
	
	private Dict getDictByName(String name){
		List<Dict> dicts=new ArrayList<Dict>();
		Dict dict=new Dict();
		String hql="From Dict d where d.Name=:sname";
		try {
			Query query=DataAccessObject.openSession().createQuery(hql);
			query.setString("sname", name);
			dicts=(List<Dict>)query.list();
			if(dicts.size()>0){
				dict=(Dict)query.list().get(0);
			}
			else
			{
				dict=null;
			}
		} catch (HibernateException e) {
			dict=null;
		}
		return dict;
	}
	private int getCategoryIdByName(String name){
		int id=0;
		Dict dict=getDictByName(name);
		try {
			if(dict!=null){
				id=dict.getID();
			}
		} catch (Exception e) {
			id=0;
		}
		return id;
	}
	private int getFlowerByNameAndCatory(String name,int catoryId){
		int id=0;
		try {
			List<Dict> flowers=new FabricManager().getFlower(catoryId);
			for (int i = 0; i < flowers.size(); i++) {
				if(name.equals((DictManager.getDictByID(flowers.get(i).getID())).getName())){
				   id=flowers.get(i).getID();
				}
			}
		} catch (Exception e) {
			id=0;
		}
		return id;
	}
	private int getColorByNameAndCatory(String name,int catoryId){
		int id=0;
		try {
			List<Dict> colors=new FabricManager().getColor(catoryId);
			for(int i=0;i<colors.size();i++){
				if(name.equals(DictManager.getDictByID(colors.get(i).getID()).getName())){
					id=colors.get(i).getID();
				}
			}
		} catch (Exception e) {
			id=0;
		}
		return id;
	}
	private int getCompostionByNameAndCatory(String name,int catoryId){
		int id=0;
		try {
			List<Dict> compostions=new FabricManager().getComposition(catoryId);
			for (int i = 0; i <compostions.size() ; i++) {
				if(name.equals(DictManager.getDictByID(compostions.get(i).getID()).getName())){
					id=compostions.get(i).getID();
				}
			}
		} catch (Exception e) {
			id=0;
		}
		return id;
	}
	private String getPropertyByNameAndCotory(String name,int catoryId){
		String id="";
		int propertyID=0;
		if(catoryId==8001){
			propertyID=8341;
		}
		if(catoryId==8050){
			propertyID=8343;
		}
		if(catoryId==8030){
			propertyID=8342;
		}
		List<Dict> propertys=new FabricManager().getProperty(propertyID);
		for (int i = 0; i < propertys.size(); i++) {
			if(name.equals(propertys.get(i).getName())){
				id=Utility.toSafeString(propertys.get(i).getID());
			}
		}
		return id;
	}
	private FabricTrader getBrandIdByVabrictrader(String name){
		List<FabricTrader> fabrictraders=new ArrayList<FabricTrader>();
		FabricTrader trader=new FabricTrader();
		String hql="From FabricTrader f where f.traderName=:name";
		Query query=DataAccessObject.openSession().createQuery(hql);
		
		query.setString("name", name);
		fabrictraders=query.list();
		if(fabrictraders.size()>0){
			trader=(FabricTrader)fabrictraders.get(0);
		}
		else
		{
			trader=null;
		}
		return trader;
	}
	
	public FabricWareroom getFabricWareroomByFabricCode(String fabricCode){
		String hql="FROM FabricWareroom m where m.fabricNo=:fabricCode";
		Query query=DataAccessObject.openSession().createQuery(hql);
		query.setString("fabricCode", fabricCode);
		List<FabricWareroom> fabricwarerooms=query.list();
		if(fabricwarerooms.size()==0){
			return null;
		}
		FabricWareroom fw = fabricwarerooms.get(0);
		fw.setColorName(DictManager.getDictNameByID(fw.getColor()));
		fw.setFlowerName(DictManager.getDictNameByID(fw.getFlower()));
		fw.setCompositionName(DictManager.getDictNameByID(fw.getComposition()));
		return fw;
	}
	
	public void updateStatus(String ids){
		String idarray=ids.substring(0, ids.length()-1); 
		Session session=null;
		Transaction tran=null;
		try {
			String hql="UPDATE FabricWareroom SET status=10051 where id in ("+idarray+")";
			session=DataAccessObject.openSession();
			tran=session.beginTransaction();
			Query query=session.createQuery(hql);
			query.executeUpdate();
			tran.commit();
		} catch (HibernateException e) {
			if(tran!=null) tran.rollback();
			e.printStackTrace();
		}
		finally{
			DataAccessObject.closeSession();
		}
	}
	
}
