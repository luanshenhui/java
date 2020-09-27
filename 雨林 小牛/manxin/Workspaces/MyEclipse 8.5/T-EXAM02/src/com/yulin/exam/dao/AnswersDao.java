package com.yulin.exam.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import com.yulin.exam.bean.Answers;
import com.yulin.exam.bean.Question;
import com.yulin.exam.util.DBUtil;

public class AnswersDao {

	private String insertAnswers = "insert into exam_user values(?,?)";
	private String queryAll = "select * from exam_user";
	
	/*将用户答案放入数据库*/
	public boolean insertAnswers(Answers an){
		Connection conn = DBUtil.getConnection();
		int falg = 0;
		try {
			PreparedStatement ps = conn.prepareStatement(insertAnswers);
			ps.setString(1, an.getAnswer());
			ps.setString(2, an.getLoginid());
			falg = ps.executeUpdate();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return falg == 1;
	}
	
	/*查询，取出用户答案*/
	public ArrayList<Answers> getAnswer(){
		Answers an = null;
		Connection conn = DBUtil.getConnection();
		ArrayList<Answers> list = new ArrayList<Answers>();
		try {
			PreparedStatement ps = conn.prepareStatement(queryAll);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				an = new Answers(rs.getString("answer"),rs.getString("loginid"));
				list.add(an);
			}
			rs.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public static void main(String[] args) {
		AnswersDao ao = new AnswersDao();
		ArrayList<Answers> list = ao.getAnswer();
		System.out.println(list);
	}
	
//	public int getScore(ArrayList<Question> arrQuestion){
//		int score = 0;
//		for(int i = 0; i< arrQuestion.size();i++){
//			if(arrQuestion.get(i).equals(arr.get(i))){
//				score += 5;
//			}
//		}
//		return score;
//	} 
}
