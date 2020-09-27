package chinsoft.business;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.namespace.QName;

import net.sf.json.JSONObject;

import org.apache.axis2.AxisFault;
import org.apache.axis2.addressing.EndpointReference;
import org.apache.axis2.client.Options;
import org.apache.axis2.rpc.client.RPCServiceClient;
import org.apache.axis2.transport.http.HTTPConstants;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Logistic;
import chinsoft.entity.LogisticXMLBean;
import chinsoft.entity.OrdenXMLBean;

public class LogisticManager {

	DataAccessObject dao = new DataAccessObject();

	// 添加&修改
	public void saveLogistic(Logistic logistic) {
		dao.saveOrUpdate(logistic);
	}
	// 根据ID查询
	public Logistic getLogisticByOrdenID(String strOrdenID) {
		Logistic logistic = new Logistic();
		List<Logistic> logistics = new ArrayList<Logistic>();
		try{
			String hql ="from Logistic l where l.ordenID =:ordenID";
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString("ordenID", strOrdenID);
			logistics= query.list();
			if(logistics.size()>0){
				logistic = logistics.get(0);
			}
		}catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
		return logistic;
	}
	public Logistic getLogisticByOrdenID2(String strOrdenID) {
		Logistic logistic = null;
		List<Logistic> logistics = new ArrayList<Logistic>();
		try{
			String hql ="from Logistic l where l.ordenID =:ordenID";
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString("ordenID", strOrdenID);
			logistics= query.list();
			if(logistics.size()>0){
				logistic=new Logistic();
				logistic = logistics.get(0);
			}
		}catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
		return logistic;
	}
	//根据运单号查询
	public Logistic getLogisticByLogisticNo(String strLogisticNo){
		Logistic logistic = new Logistic();
		List<Logistic> logistics = new ArrayList<Logistic>();
		try{
			String hql ="from Logistic l where l.logisticNo =:logisticNo";
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString("logisticNo", strLogisticNo);
			logistics= query.list();
			if(logistics.size()>0){
				logistic = logistics.get(0);
			}
		}catch (Exception e) {
			LogPrinter.error(e.getMessage());
		}finally{
			DataAccessObject.closeSession();
		}
		return logistic;
	}
	
	//删除物流信息
	public void removeLogisticByOrdenID(String strID) {
		String deleteSql = "DELETE FROM Logistic WHERE ordenID=:ordenID";

		Session session = null;
		Transaction transaction = null;
		try {
			session = DataAccessObject.openSession();
			transaction = session.beginTransaction();
			Query deleteQuery = session.createQuery(deleteSql);
			deleteQuery.setString("ordenID", strID);
			deleteQuery.executeUpdate();
			
			transaction.commit();
		} catch (Exception e) {
			transaction.rollback();
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
	}
	public String getSFinfoByWebservice(String xml){
		RPCServiceClient serviceClient;
		String rxml="";
		EndpointReference targetEPR = new EndpointReference("http://219.134.187.132:9090/bsp-ois/ws/expressService?wsdl");
		try {
			serviceClient=new RPCServiceClient();
			Options options = serviceClient.getOptions();
			options.setManageSession(true);
			options.setProperty(HTTPConstants.REUSE_HTTP_CLIENT,true);
			options.setTo(targetEPR);
			QName opAddEntry = new QName("http://service", "sfexpressService");
			Object[] params=new Object[]{xml};
			Class[] classes=new Class[]{String.class};
			Object[] objs=serviceClient.invokeBlocking(opAddEntry, params,classes);
			rxml=Utility.toSafeString(objs[0]);
		} catch (AxisFault e) {
			e.printStackTrace();
		}
		return rxml;
	}
	
	public void updateLogisticInfoByOrdenID(String ordenID,String company,String logisticNo){
		
		Session session=null;
		Transaction trans=null;
		
		try {
			String hql="UPDATE Logistic SET logisticCompany=:company,logisticNo=:logisticNo where ordenID=:ordenID";
			session=DataAccessObject.openSession();
			trans=session.beginTransaction();
			Query query=session.createQuery(hql);
			query.setString("company",company);
			query.setString("logisticNo", logisticNo);
			query.setString("ordenID", ordenID);
			query.executeUpdate();
			trans.commit();
		} catch (HibernateException e) {
			if(trans!=null) trans.rollback();
			e.printStackTrace();
		}
		finally{
			DataAccessObject.closeSession();
		}
	}
	
	public String getLogisticBean(JSONObject logistic){
		LogisticXMLBean xmlbean=null;
		xmlbean=new LogisticXMLBean();
		xmlbean.setAddress(logistic.getString("address"));
		xmlbean.setMobile(logistic.getString("mobile"));
		xmlbean.setName(logistic.getString("name"));
		
		try {
			xmlbean.setTel(logistic.getString("tel"));
		} catch (Exception e) {
			xmlbean.setTel("");
		}
		return this.getLogisticXML(xmlbean);
	}
	
	public String getLogisticXML(LogisticXMLBean logistic){
		String xml="";
		OrdenXMLBean xmlbean=new OrdenXMLBean();
		xmlbean.setLogistic(logistic);
		try {
			JAXBContext context=JAXBContext.newInstance(OrdenXMLBean.class);
			Marshaller marshaller=context.createMarshaller();
			marshaller.setProperty(Marshaller.JAXB_ENCODING, "GB2312");
			marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
			ByteArrayOutputStream os = new ByteArrayOutputStream();
			marshaller.marshal(xmlbean, os);
			xml = new String(os.toByteArray());
		} catch (JAXBException e) {
			e.printStackTrace();
		}
		return xml;
	}
	
	public static void main(String[] args) {
		Logistic logistic=new Logistic();
		logistic.setAddress("测试地址1");
		logistic.setMobile("88598027");
		logistic.setName("杨磊1");
		logistic.setTel("18661855675");
		LogisticManager m=new LogisticManager();
		//System.out.println(m.getLogisticBean(logistic,"1987-12-17"));
	}
}