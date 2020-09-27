/**
 * 
 */
package com.f.domain;

/**
 * @author 冯学明
 *
 * 2015-2-2上午11:09:02
 *权限表
 *
 *
 */
public class Roleaction extends BaseDomain{
		private String rolename ;
		public Roleaction(){
			this("");
		}

		public Roleaction(String rolename) {
			super();
			this.rolename = rolename;
		}

		public String getRolename() {
			return rolename;
		}

		public void setRolename(String rolename) {
			this.rolename = rolename;
		}
		@Override
		public String toString() {
			return "Roleaction [rolename=" + rolename + "]";
		}	
}
