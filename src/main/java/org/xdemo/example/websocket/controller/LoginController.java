package org.xdemo.example.websocket.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import com.alibaba.fastjson.JSON;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.xdemo.example.websocket.entity.User;
import org.xdemo.example.websocket.entity.UserDetail;
import org.xdemo.example.websocket.service.UserDetailService;
import org.xdemo.example.websocket.service.UserService;

@Controller
public class LoginController {
	
	@Resource 
	private UserService userService;
	@Resource 
	private UserDetailService userDetailService;
	
	@RequestMapping(value="/main")
	public String main(){
		return "main";
	}
	
	@RequestMapping(value="/login")
	public String login(){
		return "login";
	}
	
	/**
	 * 登录
	 * @param userName
	 * @param userPassword
	 * @param httpSession
	 * @return
	 */
	@RequestMapping(value="/doLogin",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> doLogin(String userName,HttpServletRequest  request,String userPassword,HttpSession httpSession){
		String result="fail";
		System.out.println(userName+","+userPassword);
		User user = userService.getUser(userName);
		UserDetail userDetail = userDetailService.getUserDetail(userName);
		if(user!=null){
			if(Objects.equals(userDetail.getUserDetailPassword(), userPassword)){
			    //用户信息存入session
				httpSession.setAttribute("currentUser",user);
				request.getSession().setAttribute("uid", user.getId());
				result = "success";
			}
			else{
				result = "wrong";
			}
		}
		else{
			result = "unexist";
		}
		Map<String, Object> results = new HashMap<String,Object>();
		results.put("result", result);
		if(result.equals("success"))
			results.put("user", JSON.toJSON(user));
		return results;
	}
	
	
	@RequestMapping(value="/doLogout")
	public String doLogout(HttpSession httpSession){
		httpSession.removeAttribute("currentUser");
		return "redirect:login";
	}
}