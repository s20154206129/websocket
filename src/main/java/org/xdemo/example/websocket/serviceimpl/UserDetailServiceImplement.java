package org.xdemo.example.websocket.serviceimpl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.xdemo.example.websocket.dao.UserDetailDao;
import org.xdemo.example.websocket.entity.UserDetail;
import org.xdemo.example.websocket.service.UserDetailService;

@Service("userDetailService")
public class UserDetailServiceImplement implements UserDetailService {

	@Autowired 
	private UserDetailDao userDetailDao;
	
	@Override
	public UserDetail getUserDetail(int id) {
		return userDetailDao.getUserDetailById(id);
	}
	
	@Override
	public UserDetail getUserDetail(String name) {
		return userDetailDao.getUserDetailByName(name);
	}

	@Override
	public void addUserDetail(UserDetail userDetail) {
		userDetailDao.addUserDetail(userDetail);
	}

	@Override
	public boolean deleteUserDetail(int id) {
		return userDetailDao.deleteUserDetail(id);
	}

	@Override
	public boolean updateUserDetail(UserDetail userDetail) {
		return userDetailDao.updateUserDetail(userDetail);
	}

	@Override
	public List<UserDetail> getAllUserDetail() {
		return userDetailDao.getAllUserDetail();
	}

}
