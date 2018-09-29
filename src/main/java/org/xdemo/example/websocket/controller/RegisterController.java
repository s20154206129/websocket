package org.xdemo.example.websocket.controller;

import java.sql.Timestamp;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.xdemo.example.websocket.entity.User;
import org.xdemo.example.websocket.entity.UserDetail;
import org.xdemo.example.websocket.service.UserDetailService;
import org.xdemo.example.websocket.service.UserService;
@Controller
public class RegisterController {
	
	@Autowired
	private UserService userService;
	@Autowired 
	private UserDetailService userDetailService;
	
	@RequestMapping(value="/register")
	public String register(){
		return "register";
	}
	
	@RequestMapping(value="/doRegister",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> doRegister(String userName,String userNickName,String userPassword){
		String result="fail";
		if(userService.getUser(userName)==null){
			UserDetail userDetail = new UserDetail();
			userDetail.setUserDetailName(userName);
			userDetail.setUserDetailNickName(userNickName);
			userDetail.setUserDetailPassword(userPassword);
			userDetail.setUserDetailRole(0);
			Date date = new Date();
			Timestamp timestamp = new Timestamp(date.getTime());
			userDetail.setUserRegisterTime(timestamp);
			userDetail.setUserMailNumber("");
			userDetail.setUserPhoneNumber("");
			userDetailService.addUserDetail(userDetail);
			userDetail = userDetailService.getUserDetail(userName);
			User user = new  User(userDetail);
		
			userService.addUser(user);
			result = "success";
		}
		else{
			result = "exist";
		}
		Map<String, Object> results = new HashMap<String,Object>();
		results.put("result", result);
		return results;
	}
}