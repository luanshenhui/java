package com.yulin.exam;
import java.io.*;

public class ExamUtil {
	public static Question[] questionUtil(String path) throws IOException{	//TODO Question[]
		File file = new File(path);
		BufferedReader br = new BufferedReader(new FileReader(file));
		Question[] qs = new Question[10];
		int ��� = 0;
		while(br.ready()){
			String str = br.readLine();
			if(str.startsWith("@1")){
				String[] ss = str.split("#");	//�����з�				//Integer.parseInt(ss[3])//���ַ����������
				FillingQuestion fq = new FillingQuestion(ss[1],ss[2],Integer.parseInt(ss[3]));//����һ�������Ķ��� ,
				fq.set���(���);
				qs[���++] = fq;//��ö�Ӧ������±�
			}else if(str.startsWith("@2")){
				String[] ss = str.split("#");	//�����з�
				String[] options = ss[2].split(",");	//ѡ���з�
				SelectQuestion sq = new SelectQuestion(ss[1],options,ss[3],Integer.parseInt(ss[4]));//����һ��ѡ�������
				sq.set���(���);
				qs[���++] = sq;
			}
		}
		return qs;
	}
	public static void userWriter(String path){
		
	}
	public static void userReader(String path){		//TODO User

	}
	
	public static void main(String[] args){
		Question[] qs;
		try {
			qs = ExamUtil.questionUtil("src/com/yulin/exam/exam.txt");
			for(Question q : qs){
				q.��ʾ();
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
