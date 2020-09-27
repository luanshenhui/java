package cn.lsh.web.mapper.login.dao.impl;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

import cn.lsh.web.mapper.login.dao.LoginDao;
import cn.lsh.web.mapper.login.domain.AreaDomain;
import cn.lsh.web.mapper.login.domain.ColorUserVo;
import cn.lsh.web.mapper.login.domain.FoltDomain;
import cn.lsh.web.mapper.login.domain.GroupDomain;
import cn.lsh.web.mapper.login.domain.ImgDomain;
import cn.lsh.web.mapper.login.domain.LshTable;
import cn.lsh.web.mapper.login.domain.ManagerDomain;
import cn.lsh.web.mapper.login.domain.PersonDomain;
import cn.lsh.web.mapper.login.domain.Role;
import cn.lsh.web.mapper.login.domain.RolePersonDomain;
import login.model.FoltVo;
import login.model.GroupUserVo;



@Repository("loginDao")
public class LoginDaoImpl implements LoginDao {
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
//	@Autowired
//	@Qualifier("blankSST")
//	private SqlSession sqlSession2 = null;

	public SqlSessionTemplate getSqlSession() {
		return sqlSession;
	}

	public void setSqlSession(SqlSessionTemplate sqlSession) {
		this.sqlSession = sqlSession;
	}

	
	public PageInfo<ColorUserVo> findByWhere(int pageNo, int pageSize,
			ColorUserVo paramObj) throws Exception {
		PageInfo<ColorUserVo> result = null;
		try {
			try {
				PageHelper.startPage(pageNo, pageSize, true);
				List<ColorUserVo> list = sqlSession.selectList("colorUserVoList", paramObj);
				result = new PageInfo<ColorUserVo>(list);
			} catch (Exception e) {
				throw new Exception("colorUserVoList");
			} 
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
//			sqlSession.commit();
//			sqlSession.close();
		}
		return result;
	}

	
	public PageInfo<GroupUserVo> groupListView(int pageNo, int pageSize,
			GroupDomain paramObj) {
		PageInfo<GroupUserVo> result = null;
		PageHelper.startPage(pageNo, pageSize, true);
		List<GroupUserVo> list = sqlSession.selectList("GroupbyGroup", paramObj);
		for(GroupUserVo d:list){
			GroupDomain ds=new GroupDomain();
			ds.setPerson_id(d.getPerson_id());
			List<GroupDomain> lp=sqlSession.selectList("GroupbyGroup", d);//找出同族用户
			d.setNum(String.valueOf(lp.size()));
			FoltDomain folist=sqlSession.selectOne("sumFolt", lp);
			if(null!=folist){
				d.setC_a(folist.getC_a());
				d.setC_b(folist.getC_b());
				d.setC_c(folist.getC_c());
				d.setC_d(folist.getC_d());
				d.setC_e(folist.getC_e());
			}else{
				d.setC_a("0");
				d.setC_b("0");
				d.setC_c("0");
				d.setC_d("0");
				d.setC_e("0");
			}
		
		}
		result = new PageInfo<GroupUserVo>(list);
		return result;
	}

	
	public List<GroupUserVo> getGroupUserVoList(GroupDomain g) {
		List<GroupUserVo> list = sqlSession.selectList("GroupbyGroup",g);
		for(GroupUserVo d:list){
			GroupDomain ds=new GroupDomain();
			ds.setPerson_id(d.getPerson_id());
			List<GroupDomain> lp=sqlSession.selectList("GroupbyGroup", d);//找出同族用户
			d.setNum(String.valueOf(lp.size()));
			FoltDomain folist=sqlSession.selectOne("sumFolt", lp);
			if(null!=folist){
				d.setC_a(folist.getC_a());
				d.setC_b(folist.getC_b());
				d.setC_c(folist.getC_c());
				d.setC_d(folist.getC_d());
				d.setC_e(folist.getC_e());
			}else{
				d.setC_a("0");
				d.setC_b("0");
				d.setC_c("0");
				d.setC_d("0");
				d.setC_e("0");
			}
		
		}
		return list;
	}

	
	public List<FoltVo> getStreetDrew(GroupDomain group) {
		return sqlSession.selectList("getStreetDraw",group);
	}

	
	public List<Role> getRoleList(Role role) {
		return sqlSession.selectList("findRoleList",role);
	}

	
	public List<AreaDomain> getProvinceList(AreaDomain areaDomain) {
		return sqlSession.selectList("getProvinceList",areaDomain);
	}

	
	public List<ColorUserVo> getUserVoList(ColorUserVo user) {
		return sqlSession.selectList("colorUserVoList",user);
	}

	
	public List<FoltVo> getOracleDrew(FoltDomain folt) {
		return null;
	}

	
	public Integer getOracleDrew(FoltVo v) {
		return sqlSession.selectOne("getOracleDrew",v);
	}

	
	public ManagerDomain getLoginManager(ManagerDomain m) {
		return sqlSession.selectOne("getLoginManager",m);
	}

	
	public void createPerson(PersonDomain person) {
		sqlSession.insert("insertPerson",person);
		
	}

	
	public void createGroup(GroupDomain person) {
		sqlSession.insert("insertGroup",person);
		
	}

	
	public void insertFolt(FoltDomain folt) {
		sqlSession.insert("insertFolt",folt);
		
	}

	
	public void updateImgName(ImgDomain img) {
		sqlSession.update("updateImgName",img);
		
	}

	
	public List<ImgDomain> getImgInfo(ImgDomain imgDomain) {
		return sqlSession.selectList("getImgInfo",imgDomain);
	}

	
	public void insertRegister(ManagerDomain d) {
		sqlSession.insert("insertRegister",d);
		
	}

	
	public void updateUser(ManagerDomain d) {
		sqlSession.update("updateUser",d);
		
	}

	
	public PageInfo<Role> findRoleList(int pageNo, int pageSize, Role paramObj) {
		PageInfo<Role> result = null;
		try {
			try {
				PageHelper.startPage(pageNo, pageSize, true);
				List<Role> list = sqlSession.selectList("findRoleList", paramObj);
				result = new PageInfo<Role>(list);
			} catch (Exception e) {
				throw new Exception("findRoleList");
			} 
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
//			sqlSession.commit();
//			sqlSession.close();
		}
		return result;
	}

	
	public Role getRole(Role role) {
		return sqlSession.selectOne("findRoleList", role);
	}

	
	public void updateRole(Role role) {
		sqlSession.update("updateRole", role);
	}

	
	public List<RolePersonDomain> getAllList(RolePersonDomain rolePersonDomain) {
		return sqlSession.selectList("getAllList", rolePersonDomain);
	}

	
	public void insertRoleVo(Role role) {
		sqlSession.insert("insertRoleVo", role);
		
	}

	
	public List<GroupDomain> selectWatchNum(GroupDomain group) {
		return sqlSession.selectList("selectWatchNum", group);
	}

	
	public PersonDomain getClientPerson(PersonDomain personDomain) {
		return sqlSession.selectOne("getClientPerson", personDomain);
	}

	
	public AreaDomain getProvinceCode(PersonDomain person) {
		return sqlSession.selectOne("getProvinceCode", person);
	}

	
	public List<String> getGroupPerson(FoltDomain folt) {
		return sqlSession.selectList("getGroupPerson", folt);
	}

	
	public List<ImgDomain> getMsg(FoltDomain folt) {
		return sqlSession.selectList("getMsg", folt);
	}

	
	public PersonDomain selectPerson(PersonDomain person) {
		return sqlSession.selectOne("selectPerson", person);
	}

	public List<AreaDomain> getCallList(AreaDomain a) {
		return sqlSession.selectList("getCallList", a);
	}

	public void insertGroup2(RolePersonDomain g) {
		sqlSession.insert("insertGroup2", g);
		
	}

	public List<LshTable> getLshTableList(LshTable lshTable) {
//		return sqlSession2.selectList("getLshTableList");
		return null;
	}

	
}
