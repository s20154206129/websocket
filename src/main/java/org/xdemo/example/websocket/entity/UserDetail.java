package org.xdemo.example.websocket.entity;

import java.sql.Timestamp;
import com.alibaba.fastjson.annotation.JSONField;


public class UserDetail{
	private Long userDetailId;
	//用户名
	private String userDetailName;
	//昵称
	private String userDetailNickName;
	
	private String userDetailPassword;
	
	private int userDetailRole;
	
	private String userMailNumber;
	private String userPhoneNumber;
	private Timestamp userRegisterTime;
	
	
	public Long getUserDetailId() {
		return userDetailId;
	}
	public void setUserDetailId(Long userDetailId) {
		this.userDetailId = userDetailId;
	}
	
	
	public String getUserDetailName() {
		return userDetailName;
	}
	public void setUserDetailName(String userDetailName) {
		this.userDetailName = userDetailName;
	}
	
	
	public String getUserDetailNickName() {
		return userDetailNickName;
	}
	public void setUserDetailNickName(String userDetailNickName) {
		this.userDetailNickName = userDetailNickName;
	}
	
	public String getUserDetailPassword() {
		return userDetailPassword;
	}
	public void setUserDetailPassword(String userDetailPassword) {
		this.userDetailPassword = userDetailPassword;
	}
	
	
	public int getUserDetailRole() {
		return userDetailRole;
	}
	public void setUserDetailRole(int userDetailRole) {
		this.userDetailRole = userDetailRole;
	}
	
	
	public String getUserMailNumber() {
		return userMailNumber;
	}
	public void setUserMailNumber(String userMailNumber) {
		this.userMailNumber = userMailNumber;
	}
	
	public String getUserPhoneNumber() {
		return userPhoneNumber;
	}
	public void setUserPhoneNumber(String userPhoneNumber) {
		this.userPhoneNumber = userPhoneNumber;
	}
	
	public Timestamp getUserRegisterTime() {
		return userRegisterTime;
	}
	public void setUserRegisterTime(Timestamp userRegisterTime) {
		this.userRegisterTime = userRegisterTime;
	}
	@Override
	public String toString() {
		return "UserDetail [userDetailId=" + userDetailId + ", userDetailName=" + userDetailName
				+ ", userDetailNickName=" + userDetailNickName + ", userDetailPassword=" + userDetailPassword
				+ ", userDetailRole=" + userDetailRole + ", userMailNumber=" + userMailNumber + ", userPhoneNumber="
				+ userPhoneNumber + ", userRegisterTime=" + userRegisterTime + "]";
	}
	
	
	
}
