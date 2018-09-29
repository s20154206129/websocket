package org.xdemo.example.websocket.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.xdemo.example.websocket.entity.User;
import org.xdemo.example.websocket.service.UserService;
@Controller
public class UserController {
	
	@Autowired 
	private UserService userService;
	
	
	/**
	 * 查找好友
	 * doFindUserByName
	 * @param userName
	 * @return
	 */
	@RequestMapping(value="/doFindUserByName",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> findUserByName(String userName){
		User user = userService.getUser(userName);
		//通过HashMap来构建Json数据，其实和Server里面通过JSONObject来构建效果是一样的
		Map<String,Object> resoult = new HashMap<String,Object>();
		if(user!=null){
			resoult.put("userId", user.getId());
			resoult.put("userName", user.getName());
			resoult.put("userNickName", user.getUserNickName());
			resoult.put("userIsOnline", user.getUserIsOnline());
			resoult.put("userRole", user.getUserRole());
		}
		else
			resoult=null;
		return resoult;
	};
	
	/**
	 *  根据id 查找 用户  
	 * 
	 * @param userId
	 * @return
	 */
	@RequestMapping(value="/doFindUserById",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> findUserById(int userId){
		User user = userService.getUser(userId);
		Map<String,Object> resoult = new HashMap<String,Object>();
		if(user!=null){
			resoult.put("userId", user.getId());
			resoult.put("userName", user.getName());
			resoult.put("userNickName", user.getUserNickName());
			resoult.put("userIsOnline", user.getUserIsOnline());
			resoult.put("userRole", user.getUserRole());
		}
		else
			resoult=null;
		return resoult;
	};
	
	
}