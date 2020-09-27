package com.yulin.exam.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import com.yulin.exam.bean.Question;
import com.yulin.exam.util.DBUtil;

public class QuestionDao {
	private String queryAll = "select * from user_exam";
	private String queryCount = "select count(*) from user_exam";
	
	//查询试题
	public ArrayList<Question> findQuestion(){
		Connection conn = DBUtil.getConnection();
		Question question = null;
		ArrayList<Question> list = new ArrayList<Question>();
		try {
			PreparedStatement ps = conn.prepareStatement(queryAll);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				question = new Question(rs.getString(1),rs.getString(2),rs.getString(3).split(","),rs.getInt(4));
//				System.out.println(rs.getString(3));
				list.add(question);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	/*查询题总数*/
	public int queryCount(){
		Connection conn = DBUtil.getConnection();
		int count = 0;
		try {
			PreparedStatement ps = conn.prepareStatement(queryCount);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				count = rs.getInt(1);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return count;
	}
	
	public static void main(String[] args) {
		QuestionDao qd = new QuestionDao();
		System.out.println(qd.findQuestion());
	}
}
