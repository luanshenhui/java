package com.yulin.manager.control;

import com.yulin.manager.service.GoodsService;
import com.yulin.manager.ui.AddFrame;
import com.yulin.manager.ui.MyFrame;

public class Control {
	
	private GoodsService gs = new GoodsService();
	private MyFrame mf;
	private AddFrame af;
	
	public AddFrame getAf() {
		return af;
	}
	public void setAf(AddFrame af) {
		this.af = af;
	}
	public GoodsService getGs() {
		return gs;
	}
	public void setGs(GoodsService gs) {
		this.gs = gs;
	}
	public MyFrame getMf() {
		return mf;
	}
	public void setMf(MyFrame mf) {
		this.mf = mf;
	}
	
	public boolean insert(int id,String cls,String name,String time){
		if(gs.insert(id, cls, name, time)){
			return true;
		}else{
			return false;
		}
	}
	
	public boolean updateGoods(int id,String cls,String name,String time){
		if(gs.updateGood(id, cls, name, time)){
			return true;
		}else{
			return false;
		}
	}
	
	public void myFrameToAddFrame(){
		mf.setVisible(false);
		af.setVisible(true);
	}
	
	public void addFrameToMyFrame(){
		af.setVisible(false);
		mf.setVisible(true);
	}
	
	public int getCount(){
		int count = gs.queryCount();
		return count;
	}
	
	public boolean deleteGood(int id){
		if(gs.deleteGood(id)){
			return true;
		}else{
			return false;
		}
	}
}
